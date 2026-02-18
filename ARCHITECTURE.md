# OrsaCusto - System Architecture

## Architecture Overview

OrsaCusto follows a **Clean Architecture** approach with clear separation of concerns, ensuring the system is:
- **Independent of frameworks**: Business rules don't depend on external libraries
- **Testable**: Business logic can be tested without UI, database, or external services
- **Independent of UI**: UI can change without affecting business rules
- **Independent of database**: Business logic is not bound to a specific database
- **Independent of external agencies**: Business rules know nothing about the outside world

## Architecture Layers

### 1. Presentation Layer (Frontend)
**Technology**: TypeScript + React

**Responsibilities:**
- User interface and user experience
- User input validation
- State management
- Routing
- API communication

**Key Components:**
- React components (presentational and container)
- Redux Toolkit or Zustand for state management
- React Router for navigation
- Axios for HTTP requests
- React Hook Form for form handling

### 2. API Layer (Backend)
**Technology**: C# ASP.NET Core Web API

**Responsibilities:**
- HTTP request/response handling
- Request validation
- Authentication/Authorization
- API documentation (Swagger)
- Rate limiting
- CORS configuration

**Key Components:**
- Controllers (thin, delegate to Application layer)
- Middleware (authentication, logging, exception handling)
- Filters (validation, authorization)
- DTOs (Data Transfer Objects)

### 3. Application Layer (Backend)
**Technology**: C# Class Library

**Responsibilities:**
- Business logic orchestration
- Use case implementation
- Application services
- Command/Query handling (CQRS)
- Validation (FluentValidation)
- Mapping (AutoMapper)

**Key Components:**
- Application Services
- Command Handlers
- Query Handlers
- DTOs and View Models
- Validators
- Mappers

### 4. Domain Layer (Backend)
**Technology**: C# Class Library

**Responsibilities:**
- Core business logic
- Domain entities
- Domain events
- Business rules
- Domain services
- Value objects

**Key Components:**
- Entities (Insumo, Service, Budget, Event, User)
- Value Objects (Money, Address, Email)
- Domain Events
- Repository Interfaces
- Domain Services
- Specifications

### 5. Infrastructure Layer (Backend)
**Technology**: C# Class Library

**Responsibilities:**
- Data persistence
- External service integration
- Email service
- File storage
- Caching
- Logging

**Key Components:**
- Database Context (EF Core)
- Repository Implementations
- External API clients
- Email service implementation
- File storage service
- Cache service (Redis)

## Architectural Patterns

### 1. CQRS (Command Query Responsibility Segregation)
- **Commands**: Modify state (Create, Update, Delete)
- **Queries**: Read state (Get, List, Search)
- Separate read and write models for optimization

### 2. Repository Pattern
- Abstracts data access logic
- Provides a collection-like interface for domain entities
- Defined in Domain layer, implemented in Infrastructure layer

### 3. Unit of Work Pattern
- Manages database transactions
- Ensures atomic operations
- Coordinates multiple repository operations

### 4. Mediator Pattern
- Decouples request sender from receiver
- Uses MediatR library
- Centralizes request handling logic

### 5. Factory Pattern
- Creates complex objects
- Used for entity creation with business rules

### 6. Specification Pattern
- Encapsulates business rules for querying
- Composable and reusable query logic

## Data Flow

### Command Flow (Write Operations)
```
User → Frontend → API Controller → Command Handler → Domain Service → Repository → Database
                                         ↓
                                   Domain Event → Event Handler
```

### Query Flow (Read Operations)
```
User → Frontend → API Controller → Query Handler → Repository → Database
                                                        ↓
                                                    View Model → Frontend
```

## Multi-Tenancy Architecture

OrsaCusto implements **database-per-tenant** approach for strong data isolation:

### Tenant Identification
1. Subdomain-based: `tenant1.orsacusto.com`
2. Custom domain: `events.company.com`
3. Request header: `X-Tenant-Id`

### Tenant Context
- Middleware extracts tenant information from request
- Tenant context is injected into all services
- All queries automatically filter by tenant
- EF Core global query filters ensure data isolation

### Tenant Database Management
- Each tenant has a separate database
- Schema migrations applied to all tenant databases
- Centralized tenant registry database
- Connection pooling per tenant

## Security Architecture

### Authentication
- **JWT (JSON Web Tokens)**: Stateless authentication
- **Refresh Tokens**: Long-lived tokens for refreshing access tokens
- **OAuth2**: Support for Google, Microsoft authentication

### Authorization
- **Role-Based Access Control (RBAC)**: Roles define permissions
- **Policy-Based Authorization**: Fine-grained access control
- **Claims-Based Authorization**: User attributes for decisions

### Data Security
- **Encryption at Rest**: Database encryption (TDE)
- **Encryption in Transit**: HTTPS/TLS
- **Password Hashing**: bcrypt with salt
- **Sensitive Data Encryption**: AES-256 for PII

### API Security
- **Rate Limiting**: Prevent abuse
- **CORS**: Controlled cross-origin access
- **Input Validation**: Prevent injection attacks
- **Output Encoding**: Prevent XSS
- **API Keys**: For service-to-service authentication

## Scalability Architecture

### Horizontal Scaling
- **Stateless API**: Multiple instances behind load balancer
- **Database Read Replicas**: Separate read and write databases
- **Caching Layer**: Redis for frequently accessed data
- **CDN**: Static assets served from edge locations

### Vertical Scaling
- Increase resource allocation per instance
- Database performance tuning
- Query optimization

### Async Processing
- **Background Jobs**: Heavy operations processed asynchronously
- **Message Queue**: RabbitMQ or Azure Service Bus
- **Event-Driven Architecture**: Domain events trigger async operations

## High Availability Architecture

### Load Balancing
- **API Gateway**: Routes requests to healthy instances
- **Health Checks**: Kubernetes probes for instance health
- **Auto-Scaling**: Scale based on CPU, memory, or custom metrics

### Database HA
- **Primary-Replica Setup**: Automatic failover
- **Connection Pooling**: Efficient connection management
- **Backup Strategy**: Regular automated backups

### Disaster Recovery
- **Multi-Region Deployment**: Active-passive or active-active
- **Data Replication**: Geo-redundant storage
- **Recovery Point Objective (RPO)**: < 15 minutes
- **Recovery Time Objective (RTO)**: < 1 hour

## Performance Optimization

### Backend Optimization
1. **Database Indexing**: Strategic indexes on frequently queried columns
2. **Query Optimization**: Avoid N+1 queries, use projection
3. **Caching**: Redis for expensive operations
4. **Async/Await**: Non-blocking I/O operations
5. **Connection Pooling**: Reuse database connections
6. **Pagination**: Limit data transfer
7. **Compression**: Gzip response compression

### Frontend Optimization
1. **Code Splitting**: Load code on demand
2. **Lazy Loading**: Load components when needed
3. **Memoization**: Cache expensive computations
4. **Virtual Scrolling**: Efficient rendering of large lists
5. **Image Optimization**: WebP format, lazy loading
6. **Bundle Optimization**: Tree shaking, minification
7. **Service Workers**: Offline capabilities, caching

## Monitoring and Observability

### Application Performance Monitoring (APM)
- **Metrics**: Response time, throughput, error rate
- **Tracing**: Distributed request tracing
- **Profiling**: CPU, memory profiling

### Infrastructure Monitoring
- **Prometheus**: Metrics collection
- **Grafana**: Visualization and dashboards
- **Alert Manager**: Automated alerting

### Logging
- **Structured Logging**: JSON format for easy parsing
- **Log Aggregation**: ELK Stack (Elasticsearch, Logstash, Kibana)
- **Log Levels**: Debug, Info, Warning, Error, Critical
- **Correlation IDs**: Track requests across services

### Health Checks
- **Liveness Probe**: Is the application running?
- **Readiness Probe**: Is the application ready to serve traffic?
- **Startup Probe**: Has the application started successfully?

## Integration Architecture

### External Integrations
- **RESTful APIs**: Standard HTTP APIs
- **Webhooks**: Event-driven notifications
- **Message Queues**: Async integration with external systems

### Integration Patterns
1. **API Gateway Pattern**: Single entry point for all integrations
2. **Adapter Pattern**: Translate external formats to internal models
3. **Circuit Breaker**: Prevent cascading failures
4. **Retry Pattern**: Handle transient failures
5. **Timeout Pattern**: Prevent hanging requests

## Development Architecture

### CI/CD Pipeline
```
Code Commit → Build → Unit Tests → Integration Tests → 
Static Analysis → Security Scan → Docker Build → 
Deploy to Staging → E2E Tests → Deploy to Production
```

### Environments
1. **Local**: Docker Compose, local database
2. **Development**: Shared dev environment, feature branches
3. **Staging**: Production-like, integration testing
4. **Production**: Live environment, high availability

### Version Control
- **Git**: Source control
- **Git Flow**: Branching strategy
- **Pull Requests**: Code review process
- **Semantic Versioning**: Version numbering

## Technology Stack Summary

### Frontend
- **Framework**: React 18+
- **Language**: TypeScript 5+
- **State Management**: Redux Toolkit / Zustand
- **UI Library**: Material-UI / Ant Design
- **Forms**: React Hook Form
- **HTTP Client**: Axios
- **Build Tool**: Vite / Webpack
- **Testing**: Jest, React Testing Library, Playwright

### Backend
- **Framework**: ASP.NET Core 8+
- **Language**: C# 12+
- **ORM**: Entity Framework Core 8+
- **Database**: PostgreSQL 15+
- **Cache**: Redis 7+
- **API Documentation**: Swagger/OpenAPI
- **Authentication**: JWT, OAuth2
- **Testing**: xUnit, Moq, FluentAssertions

### Infrastructure
- **Containerization**: Docker
- **Orchestration**: Kubernetes
- **CI/CD**: GitHub Actions
- **Cloud**: Azure / AWS / GCP
- **Monitoring**: Prometheus + Grafana
- **Logging**: ELK Stack
- **CDN**: CloudFlare / Azure CDN

## Deployment Architecture

### Kubernetes Architecture
```
┌─────────────────────────────────────────┐
│           Ingress Controller            │
└─────────────────┬───────────────────────┘
                  │
    ┌─────────────┴─────────────┐
    │                           │
┌───▼────────┐          ┌───────▼────┐
│  Frontend  │          │  Backend   │
│   Service  │          │   Service  │
│  (3 pods)  │          │  (5 pods)  │
└───┬────────┘          └───────┬────┘
    │                           │
    │        ┌──────────────────┘
    │        │
┌───▼────────▼───┐      ┌─────────────┐
│   PostgreSQL   │      │    Redis    │
│   StatefulSet  │      │ StatefulSet │
└────────────────┘      └─────────────┘
```

### Docker Compose (Development)
```yaml
services:
  frontend:
    - React dev server with hot reload
  backend:
    - .NET API with hot reload
  postgres:
    - Database with volume mount
  redis:
    - Cache with volume mount
```

## Conclusion

This architecture provides:
- **Scalability**: Horizontal and vertical scaling capabilities
- **Maintainability**: Clean separation of concerns
- **Testability**: Independent layers can be tested in isolation
- **Performance**: Optimized at every layer
- **Security**: Multiple layers of security controls
- **Flexibility**: Easy to adapt to changing requirements
- **Resilience**: High availability and disaster recovery

The architecture supports the whitelabel nature of OrsaCusto by providing strong multi-tenancy, customization capabilities, and efficient resource utilization.
