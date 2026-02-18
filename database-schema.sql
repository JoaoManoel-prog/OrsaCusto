-- OrsaCusto Database Schema
-- PostgreSQL 15+

-- Enable UUID extension
CREATE EXTENSION IF NOT EXISTS "uuid-ossp";

-- ============================================
-- TENANTS AND MULTI-TENANCY
-- ============================================

CREATE TABLE Tenants (
    Id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    Name VARCHAR(255) NOT NULL,
    Subdomain VARCHAR(100) UNIQUE,
    CustomDomain VARCHAR(255),
    IsActive BOOLEAN DEFAULT TRUE,
    PlanType VARCHAR(50) NOT NULL DEFAULT 'Basic',
    MaxUsers INT DEFAULT 10,
    CreatedAt TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    UpdatedAt TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE TenantSettings (
    Id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    TenantId UUID NOT NULL,
    SettingKey VARCHAR(100) NOT NULL,
    SettingValue TEXT,
    CreatedAt TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    UpdatedAt TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (TenantId) REFERENCES Tenants(Id) ON DELETE CASCADE,
    UNIQUE(TenantId, SettingKey)
);

CREATE TABLE BrandingConfigurations (
    Id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    TenantId UUID NOT NULL UNIQUE,
    LogoUrl VARCHAR(500),
    PrimaryColor VARCHAR(7),
    SecondaryColor VARCHAR(7),
    FontFamily VARCHAR(100),
    CustomCss TEXT,
    CreatedAt TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    UpdatedAt TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (TenantId) REFERENCES Tenants(Id) ON DELETE CASCADE
);

-- ============================================
-- USERS AND AUTHENTICATION
-- ============================================

CREATE TABLE Roles (
    Id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    Name VARCHAR(50) NOT NULL UNIQUE,
    Description TEXT,
    CreatedAt TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE Permissions (
    Id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    Name VARCHAR(100) NOT NULL UNIQUE,
    Description TEXT,
    Module VARCHAR(50) NOT NULL,
    CreatedAt TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE RolePermissions (
    RoleId UUID NOT NULL,
    PermissionId UUID NOT NULL,
    PRIMARY KEY (RoleId, PermissionId),
    FOREIGN KEY (RoleId) REFERENCES Roles(Id) ON DELETE CASCADE,
    FOREIGN KEY (PermissionId) REFERENCES Permissions(Id) ON DELETE CASCADE
);

CREATE TABLE Users (
    Id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    TenantId UUID NOT NULL,
    Email VARCHAR(255) NOT NULL,
    PasswordHash VARCHAR(255) NOT NULL,
    FirstName VARCHAR(100) NOT NULL,
    LastName VARCHAR(100) NOT NULL,
    PhoneNumber VARCHAR(20),
    IsActive BOOLEAN DEFAULT TRUE,
    EmailConfirmed BOOLEAN DEFAULT FALSE,
    LastLoginAt TIMESTAMP,
    CreatedAt TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    UpdatedAt TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (TenantId) REFERENCES Tenants(Id) ON DELETE CASCADE,
    UNIQUE(TenantId, Email)
);

CREATE TABLE UserRoles (
    UserId UUID NOT NULL,
    RoleId UUID NOT NULL,
    AssignedAt TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    AssignedBy UUID,
    PRIMARY KEY (UserId, RoleId),
    FOREIGN KEY (UserId) REFERENCES Users(Id) ON DELETE CASCADE,
    FOREIGN KEY (RoleId) REFERENCES Roles(Id) ON DELETE CASCADE
);

CREATE TABLE RefreshTokens (
    Id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    UserId UUID NOT NULL,
    Token VARCHAR(500) NOT NULL UNIQUE,
    ExpiresAt TIMESTAMP NOT NULL,
    CreatedAt TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    RevokedAt TIMESTAMP,
    FOREIGN KEY (UserId) REFERENCES Users(Id) ON DELETE CASCADE
);

-- ============================================
-- CATEGORIES AND SUPPLIERS
-- ============================================

CREATE TABLE Categories (
    Id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    TenantId UUID NOT NULL,
    Name VARCHAR(255) NOT NULL,
    Description TEXT,
    ParentCategoryId UUID,
    CreatedAt TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    UpdatedAt TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (TenantId) REFERENCES Tenants(Id) ON DELETE CASCADE,
    FOREIGN KEY (ParentCategoryId) REFERENCES Categories(Id) ON DELETE SET NULL
);

CREATE TABLE Suppliers (
    Id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    TenantId UUID NOT NULL,
    Name VARCHAR(255) NOT NULL,
    ContactPerson VARCHAR(255),
    Email VARCHAR(255),
    PhoneNumber VARCHAR(20),
    Address TEXT,
    Website VARCHAR(500),
    Notes TEXT,
    IsActive BOOLEAN DEFAULT TRUE,
    CreatedAt TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    UpdatedAt TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (TenantId) REFERENCES Tenants(Id) ON DELETE CASCADE
);

-- ============================================
-- INSUMOS (INPUTS)
-- ============================================

CREATE TABLE Units (
    Id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    Name VARCHAR(50) NOT NULL UNIQUE,
    Abbreviation VARCHAR(10) NOT NULL UNIQUE,
    UnitType VARCHAR(50) NOT NULL, -- Weight, Volume, Count, etc.
    CreatedAt TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE Insumos (
    Id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    TenantId UUID NOT NULL,
    CategoryId UUID,
    Name VARCHAR(255) NOT NULL,
    Description TEXT,
    UnitId UUID NOT NULL,
    CurrentPrice DECIMAL(18, 2) NOT NULL,
    StockQuantity DECIMAL(18, 4) DEFAULT 0,
    MinimumStock DECIMAL(18, 4) DEFAULT 0,
    Sku VARCHAR(100),
    Barcode VARCHAR(100),
    ImageUrl VARCHAR(500),
    IsActive BOOLEAN DEFAULT TRUE,
    CreatedAt TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    UpdatedAt TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (TenantId) REFERENCES Tenants(Id) ON DELETE CASCADE,
    FOREIGN KEY (CategoryId) REFERENCES Categories(Id) ON DELETE SET NULL,
    FOREIGN KEY (UnitId) REFERENCES Units(Id)
);

CREATE TABLE InsumoSuppliers (
    Id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    InsumoId UUID NOT NULL,
    SupplierId UUID NOT NULL,
    SupplierSku VARCHAR(100),
    LeadTimeDays INT,
    MinimumOrderQuantity DECIMAL(18, 4),
    IsPreferred BOOLEAN DEFAULT FALSE,
    CreatedAt TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (InsumoId) REFERENCES Insumos(Id) ON DELETE CASCADE,
    FOREIGN KEY (SupplierId) REFERENCES Suppliers(Id) ON DELETE CASCADE
);

CREATE TABLE PriceHistory (
    Id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    InsumoId UUID NOT NULL,
    Price DECIMAL(18, 2) NOT NULL,
    EffectiveDate TIMESTAMP NOT NULL,
    Reason VARCHAR(255),
    ChangedBy UUID,
    CreatedAt TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (InsumoId) REFERENCES Insumos(Id) ON DELETE CASCADE,
    FOREIGN KEY (ChangedBy) REFERENCES Users(Id) ON DELETE SET NULL
);

-- ============================================
-- SERVICES
-- ============================================

CREATE TABLE Services (
    Id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    TenantId UUID NOT NULL,
    Name VARCHAR(255) NOT NULL,
    Description TEXT,
    Markup DECIMAL(5, 2) DEFAULT 0,
    ImageUrl VARCHAR(500),
    IsTemplate BOOLEAN DEFAULT FALSE,
    IsActive BOOLEAN DEFAULT TRUE,
    CreatedAt TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    UpdatedAt TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (TenantId) REFERENCES Tenants(Id) ON DELETE CASCADE
);

CREATE TABLE ServiceInsumos (
    Id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    ServiceId UUID NOT NULL,
    InsumoId UUID NOT NULL,
    Quantity DECIMAL(18, 4) NOT NULL,
    UnitCost DECIMAL(18, 2) NOT NULL,
    Notes TEXT,
    SortOrder INT DEFAULT 0,
    CreatedAt TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    UpdatedAt TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (ServiceId) REFERENCES Services(Id) ON DELETE CASCADE,
    FOREIGN KEY (InsumoId) REFERENCES Insumos(Id) ON DELETE RESTRICT
);

CREATE TABLE ServiceSteps (
    Id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    ServiceId UUID NOT NULL,
    StepNumber INT NOT NULL,
    Title VARCHAR(255) NOT NULL,
    Description TEXT,
    DurationMinutes INT,
    CreatedAt TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (ServiceId) REFERENCES Services(Id) ON DELETE CASCADE
);

-- ============================================
-- CLIENTS
-- ============================================

CREATE TABLE Clients (
    Id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    TenantId UUID NOT NULL,
    Name VARCHAR(255) NOT NULL,
    Email VARCHAR(255),
    PhoneNumber VARCHAR(20),
    Address TEXT,
    TaxId VARCHAR(50),
    ContactPerson VARCHAR(255),
    Notes TEXT,
    IsActive BOOLEAN DEFAULT TRUE,
    CreatedAt TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    UpdatedAt TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (TenantId) REFERENCES Tenants(Id) ON DELETE CASCADE
);

-- ============================================
-- BUDGETS
-- ============================================

CREATE TABLE Budgets (
    Id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    TenantId UUID NOT NULL,
    Number VARCHAR(50) NOT NULL,
    ClientId UUID,
    EventId UUID,
    Status VARCHAR(50) NOT NULL DEFAULT 'Draft',
    Subtotal DECIMAL(18, 2) NOT NULL DEFAULT 0,
    DiscountPercent DECIMAL(5, 2) DEFAULT 0,
    DiscountAmount DECIMAL(18, 2) DEFAULT 0,
    TaxPercent DECIMAL(5, 2) DEFAULT 0,
    TaxAmount DECIMAL(18, 2) DEFAULT 0,
    TotalAmount DECIMAL(18, 2) NOT NULL DEFAULT 0,
    ValidUntil DATE,
    Notes TEXT,
    CreatedBy UUID NOT NULL,
    ApprovedBy UUID,
    ApprovedAt TIMESTAMP,
    RejectedBy UUID,
    RejectedAt TIMESTAMP,
    RejectionReason TEXT,
    CreatedAt TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    UpdatedAt TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (TenantId) REFERENCES Tenants(Id) ON DELETE CASCADE,
    FOREIGN KEY (ClientId) REFERENCES Clients(Id) ON DELETE SET NULL,
    FOREIGN KEY (EventId) REFERENCES Events(Id) ON DELETE SET NULL,
    FOREIGN KEY (CreatedBy) REFERENCES Users(Id),
    FOREIGN KEY (ApprovedBy) REFERENCES Users(Id),
    FOREIGN KEY (RejectedBy) REFERENCES Users(Id),
    UNIQUE(TenantId, Number)
);

CREATE TABLE BudgetServices (
    Id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    BudgetId UUID NOT NULL,
    ServiceId UUID NOT NULL,
    ServiceName VARCHAR(255) NOT NULL,
    Description TEXT,
    Quantity DECIMAL(18, 4) NOT NULL,
    UnitPrice DECIMAL(18, 2) NOT NULL,
    TotalPrice DECIMAL(18, 2) NOT NULL,
    SortOrder INT DEFAULT 0,
    CreatedAt TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (BudgetId) REFERENCES Budgets(Id) ON DELETE CASCADE,
    FOREIGN KEY (ServiceId) REFERENCES Services(Id) ON DELETE RESTRICT
);

CREATE TABLE BudgetVersions (
    Id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    BudgetId UUID NOT NULL,
    VersionNumber INT NOT NULL,
    VersionName VARCHAR(255),
    Data JSONB NOT NULL,
    CreatedBy UUID NOT NULL,
    CreatedAt TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (BudgetId) REFERENCES Budgets(Id) ON DELETE CASCADE,
    FOREIGN KEY (CreatedBy) REFERENCES Users(Id),
    UNIQUE(BudgetId, VersionNumber)
);

-- ============================================
-- EVENTS
-- ============================================

CREATE TABLE Events (
    Id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    TenantId UUID NOT NULL,
    Name VARCHAR(255) NOT NULL,
    Description TEXT,
    StartDate TIMESTAMP NOT NULL,
    EndDate TIMESTAMP NOT NULL,
    Location VARCHAR(255),
    Status VARCHAR(50) NOT NULL DEFAULT 'Planning',
    BudgetId UUID,
    CreatedBy UUID NOT NULL,
    CreatedAt TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    UpdatedAt TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (TenantId) REFERENCES Tenants(Id) ON DELETE CASCADE,
    FOREIGN KEY (BudgetId) REFERENCES Budgets(Id) ON DELETE SET NULL,
    FOREIGN KEY (CreatedBy) REFERENCES Users(Id)
);

CREATE TABLE EventTeamMembers (
    Id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    EventId UUID NOT NULL,
    UserId UUID NOT NULL,
    Role VARCHAR(100),
    AssignedAt TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    AssignedBy UUID,
    FOREIGN KEY (EventId) REFERENCES Events(Id) ON DELETE CASCADE,
    FOREIGN KEY (UserId) REFERENCES Users(Id) ON DELETE CASCADE,
    FOREIGN KEY (AssignedBy) REFERENCES Users(Id),
    UNIQUE(EventId, UserId)
);

CREATE TABLE EventSchedules (
    Id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    EventId UUID NOT NULL,
    Title VARCHAR(255) NOT NULL,
    Description TEXT,
    StartTime TIMESTAMP NOT NULL,
    EndTime TIMESTAMP NOT NULL,
    Location VARCHAR(255),
    SortOrder INT DEFAULT 0,
    CreatedAt TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    UpdatedAt TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (EventId) REFERENCES Events(Id) ON DELETE CASCADE
);

CREATE TABLE Tasks (
    Id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    EventId UUID NOT NULL,
    Title VARCHAR(255) NOT NULL,
    Description TEXT,
    Status VARCHAR(50) NOT NULL DEFAULT 'Todo',
    Priority VARCHAR(20) DEFAULT 'Medium',
    AssignedTo UUID,
    DueDate TIMESTAMP,
    CompletedAt TIMESTAMP,
    ParentTaskId UUID,
    SortOrder INT DEFAULT 0,
    CreatedBy UUID NOT NULL,
    CreatedAt TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    UpdatedAt TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (EventId) REFERENCES Events(Id) ON DELETE CASCADE,
    FOREIGN KEY (AssignedTo) REFERENCES Users(Id) ON DELETE SET NULL,
    FOREIGN KEY (ParentTaskId) REFERENCES Tasks(Id) ON DELETE CASCADE,
    FOREIGN KEY (CreatedBy) REFERENCES Users(Id)
);

CREATE TABLE TaskComments (
    Id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    TaskId UUID NOT NULL,
    UserId UUID NOT NULL,
    Comment TEXT NOT NULL,
    CreatedAt TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (TaskId) REFERENCES Tasks(Id) ON DELETE CASCADE,
    FOREIGN KEY (UserId) REFERENCES Users(Id)
);

CREATE TABLE Checklists (
    Id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    EventId UUID NOT NULL,
    Name VARCHAR(255) NOT NULL,
    Description TEXT,
    SortOrder INT DEFAULT 0,
    CreatedAt TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (EventId) REFERENCES Events(Id) ON DELETE CASCADE
);

CREATE TABLE ChecklistItems (
    Id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    ChecklistId UUID NOT NULL,
    Title VARCHAR(255) NOT NULL,
    IsCompleted BOOLEAN DEFAULT FALSE,
    CompletedBy UUID,
    CompletedAt TIMESTAMP,
    SortOrder INT DEFAULT 0,
    CreatedAt TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (ChecklistId) REFERENCES Checklists(Id) ON DELETE CASCADE,
    FOREIGN KEY (CompletedBy) REFERENCES Users(Id)
);

CREATE TABLE Milestones (
    Id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    EventId UUID NOT NULL,
    Name VARCHAR(255) NOT NULL,
    Description TEXT,
    DueDate TIMESTAMP NOT NULL,
    IsCompleted BOOLEAN DEFAULT FALSE,
    CompletedAt TIMESTAMP,
    SortOrder INT DEFAULT 0,
    CreatedAt TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (EventId) REFERENCES Events(Id) ON DELETE CASCADE
);

-- ============================================
-- DOCUMENTS AND FILES
-- ============================================

CREATE TABLE Documents (
    Id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    TenantId UUID NOT NULL,
    EntityType VARCHAR(50) NOT NULL,
    EntityId UUID NOT NULL,
    FileName VARCHAR(255) NOT NULL,
    FileUrl VARCHAR(500) NOT NULL,
    FileSize BIGINT,
    MimeType VARCHAR(100),
    UploadedBy UUID NOT NULL,
    CreatedAt TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (TenantId) REFERENCES Tenants(Id) ON DELETE CASCADE,
    FOREIGN KEY (UploadedBy) REFERENCES Users(Id)
);

-- ============================================
-- AUDIT LOG
-- ============================================

CREATE TABLE AuditLogs (
    Id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    TenantId UUID NOT NULL,
    UserId UUID,
    EntityType VARCHAR(100) NOT NULL,
    EntityId UUID NOT NULL,
    Action VARCHAR(50) NOT NULL,
    OldValues JSONB,
    NewValues JSONB,
    IpAddress VARCHAR(50),
    UserAgent TEXT,
    CreatedAt TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (TenantId) REFERENCES Tenants(Id) ON DELETE CASCADE,
    FOREIGN KEY (UserId) REFERENCES Users(Id) ON DELETE SET NULL
);

-- ============================================
-- CUSTOM FIELDS
-- ============================================

CREATE TABLE CustomFields (
    Id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    TenantId UUID NOT NULL,
    EntityType VARCHAR(50) NOT NULL,
    FieldName VARCHAR(100) NOT NULL,
    FieldType VARCHAR(50) NOT NULL,
    IsRequired BOOLEAN DEFAULT FALSE,
    DefaultValue TEXT,
    Options JSONB,
    SortOrder INT DEFAULT 0,
    CreatedAt TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (TenantId) REFERENCES Tenants(Id) ON DELETE CASCADE,
    UNIQUE(TenantId, EntityType, FieldName)
);

CREATE TABLE CustomFieldValues (
    Id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    CustomFieldId UUID NOT NULL,
    EntityId UUID NOT NULL,
    Value TEXT,
    CreatedAt TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    UpdatedAt TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (CustomFieldId) REFERENCES CustomFields(Id) ON DELETE CASCADE
);

-- ============================================
-- NOTIFICATIONS
-- ============================================

CREATE TABLE Notifications (
    Id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    UserId UUID NOT NULL,
    Type VARCHAR(50) NOT NULL,
    Title VARCHAR(255) NOT NULL,
    Message TEXT NOT NULL,
    Data JSONB,
    IsRead BOOLEAN DEFAULT FALSE,
    ReadAt TIMESTAMP,
    CreatedAt TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (UserId) REFERENCES Users(Id) ON DELETE CASCADE
);

-- ============================================
-- WEBHOOKS
-- ============================================

CREATE TABLE Webhooks (
    Id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    TenantId UUID NOT NULL,
    Url VARCHAR(500) NOT NULL,
    Events TEXT[] NOT NULL,
    Secret VARCHAR(255) NOT NULL,
    IsActive BOOLEAN DEFAULT TRUE,
    CreatedAt TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (TenantId) REFERENCES Tenants(Id) ON DELETE CASCADE
);

CREATE TABLE WebhookLogs (
    Id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    WebhookId UUID NOT NULL,
    EventType VARCHAR(100) NOT NULL,
    Payload JSONB NOT NULL,
    ResponseStatus INT,
    ResponseBody TEXT,
    AttemptCount INT DEFAULT 1,
    CreatedAt TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (WebhookId) REFERENCES Webhooks(Id) ON DELETE CASCADE
);

-- ============================================
-- INDEXES
-- ============================================

-- Users
CREATE INDEX idx_users_tenant_email ON Users(TenantId, Email);
CREATE INDEX idx_users_tenant_active ON Users(TenantId, IsActive);

-- Insumos
CREATE INDEX idx_insumos_tenant ON Insumos(TenantId);
CREATE INDEX idx_insumos_category ON Insumos(CategoryId);
CREATE INDEX idx_insumos_name ON Insumos(Name);
CREATE INDEX idx_insumos_sku ON Insumos(Sku);

-- Services
CREATE INDEX idx_services_tenant ON Services(TenantId);
CREATE INDEX idx_services_name ON Services(Name);

-- Budgets
CREATE INDEX idx_budgets_tenant ON Budgets(TenantId);
CREATE INDEX idx_budgets_client ON Budgets(ClientId);
CREATE INDEX idx_budgets_event ON Budgets(EventId);
CREATE INDEX idx_budgets_status ON Budgets(Status);
CREATE INDEX idx_budgets_created ON Budgets(CreatedAt);

-- Events
CREATE INDEX idx_events_tenant ON Events(TenantId);
CREATE INDEX idx_events_status ON Events(Status);
CREATE INDEX idx_events_dates ON Events(StartDate, EndDate);

-- Tasks
CREATE INDEX idx_tasks_event ON Tasks(EventId);
CREATE INDEX idx_tasks_assigned ON Tasks(AssignedTo);
CREATE INDEX idx_tasks_status ON Tasks(Status);
CREATE INDEX idx_tasks_due_date ON Tasks(DueDate);

-- Audit Logs
CREATE INDEX idx_audit_tenant ON AuditLogs(TenantId);
CREATE INDEX idx_audit_entity ON AuditLogs(EntityType, EntityId);
CREATE INDEX idx_audit_created ON AuditLogs(CreatedAt);

-- Notifications
CREATE INDEX idx_notifications_user ON Notifications(UserId);
CREATE INDEX idx_notifications_unread ON Notifications(UserId, IsRead);

-- ============================================
-- FUNCTIONS AND TRIGGERS
-- ============================================

-- Update timestamp function
CREATE OR REPLACE FUNCTION update_updated_at_column()
RETURNS TRIGGER AS $$
BEGIN
    NEW.UpdatedAt = CURRENT_TIMESTAMP;
    RETURN NEW;
END;
$$ language 'plpgsql';

-- Apply update trigger to relevant tables
CREATE TRIGGER update_tenants_updated_at BEFORE UPDATE ON Tenants
    FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();

CREATE TRIGGER update_users_updated_at BEFORE UPDATE ON Users
    FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();

CREATE TRIGGER update_insumos_updated_at BEFORE UPDATE ON Insumos
    FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();

CREATE TRIGGER update_services_updated_at BEFORE UPDATE ON Services
    FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();

CREATE TRIGGER update_budgets_updated_at BEFORE UPDATE ON Budgets
    FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();

CREATE TRIGGER update_events_updated_at BEFORE UPDATE ON Events
    FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();

CREATE TRIGGER update_tasks_updated_at BEFORE UPDATE ON Tasks
    FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();

-- ============================================
-- SEED DATA
-- ============================================

-- Insert default roles
INSERT INTO Roles (Name, Description) VALUES
    ('SuperAdmin', 'Full system access'),
    ('Admin', 'Administrative access within tenant'),
    ('Manager', 'Manage events, budgets, and insumos'),
    ('User', 'Basic user access');

-- Insert default permissions
INSERT INTO Permissions (Name, Description, Module) VALUES
    ('users.create', 'Create users', 'Users'),
    ('users.read', 'View users', 'Users'),
    ('users.update', 'Update users', 'Users'),
    ('users.delete', 'Delete users', 'Users'),
    ('insumos.create', 'Create insumos', 'Insumos'),
    ('insumos.read', 'View insumos', 'Insumos'),
    ('insumos.update', 'Update insumos', 'Insumos'),
    ('insumos.delete', 'Delete insumos', 'Insumos'),
    ('services.create', 'Create services', 'Services'),
    ('services.read', 'View services', 'Services'),
    ('services.update', 'Update services', 'Services'),
    ('services.delete', 'Delete services', 'Services'),
    ('budgets.create', 'Create budgets', 'Budgets'),
    ('budgets.read', 'View budgets', 'Budgets'),
    ('budgets.update', 'Update budgets', 'Budgets'),
    ('budgets.delete', 'Delete budgets', 'Budgets'),
    ('budgets.approve', 'Approve budgets', 'Budgets'),
    ('events.create', 'Create events', 'Events'),
    ('events.read', 'View events', 'Events'),
    ('events.update', 'Update events', 'Events'),
    ('events.delete', 'Delete events', 'Events');

-- Insert default units
INSERT INTO Units (Name, Abbreviation, UnitType) VALUES
    ('Kilogram', 'kg', 'Weight'),
    ('Gram', 'g', 'Weight'),
    ('Liter', 'L', 'Volume'),
    ('Milliliter', 'mL', 'Volume'),
    ('Unit', 'un', 'Count'),
    ('Dozen', 'dz', 'Count'),
    ('Meter', 'm', 'Length'),
    ('Hour', 'h', 'Time');
