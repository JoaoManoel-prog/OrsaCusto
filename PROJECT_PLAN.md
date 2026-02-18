# OrsaCusto - Event Budget Planning Platform

## Project Overview

OrsaCusto is a whitelabel budget planning platform focused on event planning and organization. The platform enables establishment owners to efficiently manage budgets by composing services from individual inputs (insumos), automate planning, and organize events with advanced features.

### Reference System
SieconSP7 - Event management and budget planning system

## Core Concept

The platform uses a composition model where:
- **Insumos (Inputs)** are the basic building blocks (e.g., sugar, pulp, cup, water, operation cost)
- **Services/Products** are composed of multiple insumos (e.g., "juice" = sugar + pulp + cup + water + operation cost)
- **Budgets** are composed of multiple services
- **Events** are managed with budgets, schedules, and tasks

## Technical Stack

### Frontend
- **Primary Language**: TypeScript (mandatory)
- **Secondary**: JavaScript for specific components
- **Focus**: Performance optimization and intuitive UI/UX
- **Key Technologies**:
  - React with TypeScript
  - State Management (Redux Toolkit or Zustand)
  - UI Component Library (Material-UI or Ant Design)
  - Form Management (React Hook Form)
  - Data Visualization (Chart.js or Recharts)

### Backend
- **Primary Language**: C# (.NET 8+)
- **Focus**: High performance and optimization
- **Architecture**: Clean Architecture / Hexagonal Architecture
- **Key Technologies**:
  - ASP.NET Core Web API
  - Entity Framework Core
  - SignalR (real-time updates)
  - MediatR (CQRS pattern)
  - FluentValidation
  - AutoMapper

### Database
- **Primary**: PostgreSQL (structured data, relations)
- **Cache**: Redis (session management, performance)
- **Optional**: MongoDB (flexible schemas for customization)

### Infrastructure
- **Containerization**: Docker
- **Orchestration**: Kubernetes
- **CI/CD**: GitHub Actions
- **Cloud Platform**: Azure / AWS / GCP (cloud-agnostic design)
- **Monitoring**: Prometheus + Grafana
- **Logging**: ELK Stack (Elasticsearch, Logstash, Kibana)

## System Architecture

### High-Level Architecture
```
[Frontend - TypeScript/React]
         ↓
[API Gateway / Load Balancer]
         ↓
[Backend API - C# .NET]
         ↓
[Database Layer - PostgreSQL/Redis]
```

### Microservices Architecture (Future Phase)
1. **User Service** - Authentication, Authorization, User Management
2. **Insumo Service** - Input management, catalog
3. **Service Composition Service** - Service creation from insumos
4. **Budget Service** - Budget planning and management
5. **Event Service** - Event planning, scheduling, task management
6. **Integration Service** - Third-party integrations
7. **Notification Service** - Email, SMS, push notifications

## Core Modules

### 1. User Management Module
**Features:**
- Administrator dashboard
- User registration and management
- Role-based access control (RBAC)
  - Super Admin
  - Admin
  - Manager
  - User
- Multi-tenant support (whitelabel)
- User profiles and preferences
- Authentication (JWT + Refresh tokens)
- OAuth2 integration (Google, Microsoft)

**Database Tables:**
- Users
- Roles
- Permissions
- UserRoles
- Tenants
- TenantUsers

### 2. Insumo (Input) Management Module
**Features:**
- CRUD operations for insumos
- Categorization and tagging
- Pricing management (cost tracking)
- Supplier information
- Stock/inventory tracking
- Unit of measurement (kg, L, units, etc.)
- Historical price tracking
- Bulk import/export (CSV, Excel)

**Database Tables:**
- Insumos
- Categories
- Suppliers
- InsumoSuppliers
- PriceHistory
- Units

### 3. Service Composition Module
**Features:**
- Create services from multiple insumos
- Define insumo quantities for each service
- Calculate total service cost
- Service templates
- Margin/markup configuration
- Recipe management (step-by-step)
- Cost simulation

**Database Tables:**
- Services
- ServiceInsumos (junction table with quantities)
- ServiceTemplates
- ServiceSteps

### 4. Budget Management Module
**Features:**
- Create budgets from services
- Multiple budget versions
- Budget comparison
- Approval workflow
- Client information
- Budget validity period
- PDF export
- Email delivery
- Status tracking (draft, sent, approved, rejected)

**Database Tables:**
- Budgets
- BudgetServices
- BudgetVersions
- Clients
- BudgetApprovals

### 5. Event Planning Module
**Features:**
- Event creation and management
- Timeline/schedule builder
- Gantt chart visualization
- Task management (Kanban board)
- Team assignment
- Milestone tracking
- Event budget integration
- Checklist management
- Document attachment

**Database Tables:**
- Events
- EventSchedules
- Tasks
- TaskAssignments
- Milestones
- EventDocuments
- Checklists

### 6. Integration Module
**Features:**
- REST API for third-party integrations
- Webhooks
- Import from popular event management tools
- Payment gateway integration
- Calendar sync (Google Calendar, Outlook)
- Export to accounting systems

### 7. Customization Module (Whitelabel)
**Features:**
- Custom branding (logo, colors, theme)
- Custom domain
- Feature toggles per tenant
- Custom fields and forms
- Report customization
- Email template customization

**Database Tables:**
- TenantSettings
- CustomFields
- BrandingConfigurations

## API Design

### RESTful API Endpoints

#### Authentication & Users
- POST `/api/auth/login`
- POST `/api/auth/register`
- POST `/api/auth/refresh`
- GET `/api/users`
- GET `/api/users/{id}`
- POST `/api/users`
- PUT `/api/users/{id}`
- DELETE `/api/users/{id}`

#### Insumos
- GET `/api/insumos`
- GET `/api/insumos/{id}`
- POST `/api/insumos`
- PUT `/api/insumos/{id}`
- DELETE `/api/insumos/{id}`
- GET `/api/insumos/categories`
- POST `/api/insumos/import`
- GET `/api/insumos/{id}/price-history`

#### Services
- GET `/api/services`
- GET `/api/services/{id}`
- POST `/api/services`
- PUT `/api/services/{id}`
- DELETE `/api/services/{id}`
- GET `/api/services/{id}/cost-breakdown`
- POST `/api/services/{id}/simulate-cost`

#### Budgets
- GET `/api/budgets`
- GET `/api/budgets/{id}`
- POST `/api/budgets`
- PUT `/api/budgets/{id}`
- DELETE `/api/budgets/{id}`
- POST `/api/budgets/{id}/versions`
- GET `/api/budgets/{id}/pdf`
- POST `/api/budgets/{id}/send`
- PUT `/api/budgets/{id}/approve`

#### Events
- GET `/api/events`
- GET `/api/events/{id}`
- POST `/api/events`
- PUT `/api/events/{id}`
- DELETE `/api/events/{id}`
- GET `/api/events/{id}/schedule`
- GET `/api/events/{id}/tasks`
- POST `/api/events/{id}/tasks`

## Database Schema

### Core Tables

```sql
-- Users and Authentication
CREATE TABLE Users (
    Id UUID PRIMARY KEY,
    Email VARCHAR(255) UNIQUE NOT NULL,
    PasswordHash VARCHAR(255) NOT NULL,
    FirstName VARCHAR(100) NOT NULL,
    LastName VARCHAR(100) NOT NULL,
    IsActive BOOLEAN DEFAULT TRUE,
    TenantId UUID NOT NULL,
    CreatedAt TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    UpdatedAt TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (TenantId) REFERENCES Tenants(Id)
);

-- Tenants (Multi-tenancy)
CREATE TABLE Tenants (
    Id UUID PRIMARY KEY,
    Name VARCHAR(255) NOT NULL,
    Subdomain VARCHAR(100) UNIQUE,
    CustomDomain VARCHAR(255),
    IsActive BOOLEAN DEFAULT TRUE,
    CreatedAt TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    UpdatedAt TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Insumos (Inputs)
CREATE TABLE Insumos (
    Id UUID PRIMARY KEY,
    Name VARCHAR(255) NOT NULL,
    Description TEXT,
    CategoryId UUID,
    UnitOfMeasure VARCHAR(50) NOT NULL,
    CurrentPrice DECIMAL(18, 2) NOT NULL,
    TenantId UUID NOT NULL,
    CreatedAt TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    UpdatedAt TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (CategoryId) REFERENCES Categories(Id),
    FOREIGN KEY (TenantId) REFERENCES Tenants(Id)
);

-- Services
CREATE TABLE Services (
    Id UUID PRIMARY KEY,
    Name VARCHAR(255) NOT NULL,
    Description TEXT,
    Markup DECIMAL(5, 2) DEFAULT 0,
    TenantId UUID NOT NULL,
    CreatedAt TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    UpdatedAt TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (TenantId) REFERENCES Tenants(Id)
);

-- Service-Insumo Relationship
CREATE TABLE ServiceInsumos (
    Id UUID PRIMARY KEY,
    ServiceId UUID NOT NULL,
    InsumoId UUID NOT NULL,
    Quantity DECIMAL(18, 4) NOT NULL,
    UnitCost DECIMAL(18, 2) NOT NULL,
    CreatedAt TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (ServiceId) REFERENCES Services(Id),
    FOREIGN KEY (InsumoId) REFERENCES Insumos(Id)
);

-- Budgets
CREATE TABLE Budgets (
    Id UUID PRIMARY KEY,
    ClientId UUID,
    EventId UUID,
    Status VARCHAR(50) NOT NULL,
    TotalAmount DECIMAL(18, 2) NOT NULL,
    ValidUntil DATE,
    TenantId UUID NOT NULL,
    CreatedAt TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    UpdatedAt TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (ClientId) REFERENCES Clients(Id),
    FOREIGN KEY (EventId) REFERENCES Events(Id),
    FOREIGN KEY (TenantId) REFERENCES Tenants(Id)
);

-- Events
CREATE TABLE Events (
    Id UUID PRIMARY KEY,
    Name VARCHAR(255) NOT NULL,
    Description TEXT,
    StartDate TIMESTAMP NOT NULL,
    EndDate TIMESTAMP NOT NULL,
    Location VARCHAR(255),
    Status VARCHAR(50) NOT NULL,
    BudgetId UUID,
    TenantId UUID NOT NULL,
    CreatedAt TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    UpdatedAt TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (BudgetId) REFERENCES Budgets(Id),
    FOREIGN KEY (TenantId) REFERENCES Tenants(Id)
);
```

## Development Phases

### Phase 1: Foundation (Weeks 1-4)
- [ ] Project setup and repository structure
- [ ] CI/CD pipeline configuration
- [ ] Database design and migration setup
- [ ] Authentication and authorization system
- [ ] Basic admin dashboard for user management
- [ ] Docker and Kubernetes configurations

### Phase 2: Core Functionality (Weeks 5-8)
- [ ] Insumo management (CRUD)
- [ ] Service composition module
- [ ] Cost calculation engine
- [ ] Basic budget creation
- [ ] Frontend UI components library
- [ ] API documentation (Swagger/OpenAPI)

### Phase 3: Advanced Features (Weeks 9-12)
- [ ] Event planning module
- [ ] Task management (Kanban)
- [ ] Schedule builder (Timeline/Gantt)
- [ ] Budget approval workflow
- [ ] PDF generation and email delivery
- [ ] Real-time updates (SignalR)

### Phase 4: Integrations (Weeks 13-15)
- [ ] Payment gateway integration
- [ ] Calendar synchronization
- [ ] Third-party API integrations
- [ ] Import/export functionality
- [ ] Webhook system

### Phase 5: Whitelabel & Customization (Weeks 16-18)
- [ ] Multi-tenant branding
- [ ] Custom domain support
- [ ] Theme customization
- [ ] Custom fields and forms
- [ ] Report builder

### Phase 6: Performance & Scalability (Weeks 19-20)
- [ ] Load testing and optimization
- [ ] Caching strategy implementation
- [ ] Database query optimization
- [ ] CDN integration
- [ ] Horizontal scaling setup

### Phase 7: Testing & Quality Assurance (Weeks 21-22)
- [ ] Unit tests (>80% coverage)
- [ ] Integration tests
- [ ] E2E tests
- [ ] Security audit
- [ ] Performance benchmarking

### Phase 8: Deployment & Launch (Weeks 23-24)
- [ ] Production environment setup
- [ ] Monitoring and alerting
- [ ] Documentation finalization
- [ ] User training materials
- [ ] Beta testing
- [ ] Production release

## Directory Structure

```
OrsaCusto/
├── frontend/
│   ├── src/
│   │   ├── components/
│   │   │   ├── common/
│   │   │   ├── users/
│   │   │   ├── insumos/
│   │   │   ├── services/
│   │   │   ├── budgets/
│   │   │   └── events/
│   │   ├── pages/
│   │   ├── hooks/
│   │   ├── services/
│   │   ├── store/
│   │   ├── types/
│   │   ├── utils/
│   │   └── App.tsx
│   ├── public/
│   ├── package.json
│   ├── tsconfig.json
│   └── Dockerfile
├── backend/
│   ├── src/
│   │   ├── OrsaCusto.Api/
│   │   ├── OrsaCusto.Application/
│   │   ├── OrsaCusto.Domain/
│   │   ├── OrsaCusto.Infrastructure/
│   │   └── OrsaCusto.Tests/
│   ├── OrsaCusto.sln
│   └── Dockerfile
├── infrastructure/
│   ├── kubernetes/
│   │   ├── deployments/
│   │   ├── services/
│   │   ├── ingress/
│   │   └── configmaps/
│   ├── docker/
│   │   └── docker-compose.yml
│   └── terraform/
├── docs/
│   ├── api/
│   ├── architecture/
│   ├── user-guides/
│   └── deployment/
├── .github/
│   └── workflows/
│       ├── ci.yml
│       ├── cd.yml
│       └── tests.yml
├── README.md
└── PROJECT_PLAN.md
```

## Key Features and User Stories

### User Management
1. **As an administrator**, I want to register new users with specific roles so that I can control access to the system
2. **As a user**, I want to log in securely so that I can access my tenant's data
3. **As an administrator**, I want to manage user permissions so that I can control what each user can do

### Insumo Management
1. **As a manager**, I want to add new insumos with their prices so that I can build services
2. **As a manager**, I want to categorize insumos so that I can organize them efficiently
3. **As a manager**, I want to track price history so that I can analyze cost trends
4. **As a manager**, I want to import insumos from a CSV file so that I can quickly populate the system

### Service Composition
1. **As a manager**, I want to create a service by selecting multiple insumos so that I can define what's needed for a product
2. **As a manager**, I want to specify quantities for each insumo in a service so that I can calculate accurate costs
3. **As a manager**, I want to see the total cost breakdown of a service so that I can understand the cost composition
4. **As a manager**, I want to set a markup percentage so that I can define my profit margin

### Budget Management
1. **As a manager**, I want to create a budget by selecting services so that I can quote a client
2. **As a manager**, I want to create multiple budget versions so that I can present options to clients
3. **As a manager**, I want to export a budget as PDF so that I can send it to clients
4. **As a manager**, I want to track budget status so that I can know which budgets are approved
5. **As a client**, I want to receive budget notifications so that I can review proposals quickly

### Event Planning
1. **As a planner**, I want to create an event with a schedule so that I can organize tasks
2. **As a planner**, I want to create tasks for an event so that I can track what needs to be done
3. **As a planner**, I want to assign tasks to team members so that everyone knows their responsibilities
4. **As a planner**, I want to visualize the event timeline so that I can see the overall schedule
5. **As a team member**, I want to update task status so that the team can track progress

## Security Considerations

1. **Authentication**: JWT tokens with refresh mechanism
2. **Authorization**: Role-based access control (RBAC)
3. **Data Isolation**: Multi-tenant data separation
4. **Encryption**: HTTPS, encrypted passwords (bcrypt)
5. **API Security**: Rate limiting, CORS, input validation
6. **Audit Logging**: Track all data modifications
7. **GDPR Compliance**: Data export, deletion capabilities
8. **SQL Injection Prevention**: Parameterized queries, ORM
9. **XSS Prevention**: Input sanitization, CSP headers
10. **CSRF Protection**: Anti-forgery tokens

## Performance Optimization Strategies

1. **Database**: Indexing, query optimization, connection pooling
2. **Caching**: Redis for frequently accessed data
3. **API**: Pagination, compression, selective field loading
4. **Frontend**: Code splitting, lazy loading, memoization
5. **CDN**: Static asset delivery
6. **Load Balancing**: Distribute traffic across instances
7. **Async Operations**: Background jobs for heavy tasks
8. **Database Replication**: Read replicas for scalability

## Monitoring and Observability

1. **Application Metrics**: Response times, error rates, throughput
2. **Infrastructure Metrics**: CPU, memory, disk, network
3. **Business Metrics**: User activity, budget creation, conversion rates
4. **Logging**: Centralized logging with ELK stack
5. **Tracing**: Distributed tracing with Jaeger or Zipkin
6. **Alerting**: Automated alerts for critical issues
7. **Health Checks**: Kubernetes liveness and readiness probes

## Deployment Strategy

### Development Environment
- Local Docker Compose setup
- PostgreSQL and Redis containers
- Hot reload for frontend and backend

### Staging Environment
- Kubernetes cluster (Azure AKS / AWS EKS)
- Automated deployments from develop branch
- Integration testing

### Production Environment
- Kubernetes cluster with high availability
- Blue-green deployment strategy
- Automated rollback on failures
- CDN for static assets
- Managed database service
- Backup and disaster recovery

## Testing Strategy

### Backend Testing
- **Unit Tests**: Business logic, domain models (>80% coverage)
- **Integration Tests**: API endpoints, database operations
- **Performance Tests**: Load testing with k6 or JMeter

### Frontend Testing
- **Unit Tests**: Components, hooks, utilities (Jest + React Testing Library)
- **Integration Tests**: User flows, form submissions
- **E2E Tests**: Critical user journeys (Playwright or Cypress)

## Success Metrics

1. **Performance**: API response time < 200ms (p95)
2. **Availability**: 99.9% uptime
3. **User Adoption**: X active users per month
4. **User Satisfaction**: NPS score > 50
5. **Cost Efficiency**: Budget calculation accuracy > 95%
6. **Development Velocity**: Sprint velocity of X story points

## Risks and Mitigation

### Technical Risks
1. **Risk**: Performance issues with complex calculations
   - **Mitigation**: Caching, async processing, optimization

2. **Risk**: Scalability challenges
   - **Mitigation**: Kubernetes auto-scaling, load testing

3. **Risk**: Data loss
   - **Mitigation**: Regular backups, database replication

### Business Risks
1. **Risk**: User adoption
   - **Mitigation**: UX testing, feedback loops, training

2. **Risk**: Competition
   - **Mitigation**: Unique features, customization, performance

## Future Enhancements

1. Mobile applications (iOS, Android with React Native)
2. AI-powered budget suggestions
3. Predictive analytics for cost forecasting
4. Advanced reporting and dashboards
5. Marketplace for service templates
6. Multi-language support
7. Voice commands for task management
8. Blockchain for contract management
9. IoT integration for real-time event monitoring
10. Machine learning for demand prediction

## Conclusion

OrsaCusto is designed as a comprehensive, scalable, and customizable platform for event budget planning. The modular architecture allows for incremental development and deployment, while the technology stack ensures high performance and reliability. The whitelabel capabilities make it suitable for various establishments, from small businesses to large enterprises.

## Next Steps

1. Review and approve this plan
2. Set up development environment
3. Create initial project structure
4. Begin Phase 1 development
5. Establish sprint cadence and ceremonies
