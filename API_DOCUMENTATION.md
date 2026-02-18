# API Documentation - OrsaCusto

## Overview

The OrsaCusto API is a RESTful API built with ASP.NET Core. It follows REST principles and uses JSON for request/response payloads.

## Base URL

- **Development**: `http://localhost:5000/api`
- **Staging**: `https://staging-api.orsacusto.com/api`
- **Production**: `https://api.orsacusto.com/api`

## Authentication

The API uses JWT (JSON Web Token) for authentication.

### Obtaining a Token

```http
POST /api/auth/login
Content-Type: application/json

{
  "email": "user@example.com",
  "password": "password123"
}
```

**Response:**
```json
{
  "token": "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9...",
  "refreshToken": "refresh_token_here",
  "expiresIn": 3600,
  "user": {
    "id": "uuid",
    "email": "user@example.com",
    "firstName": "John",
    "lastName": "Doe",
    "role": "Admin"
  }
}
```

### Using the Token

Include the token in the Authorization header:

```http
Authorization: Bearer eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9...
```

### Refreshing the Token

```http
POST /api/auth/refresh
Content-Type: application/json

{
  "refreshToken": "refresh_token_here"
}
```

## Common Response Codes

- `200 OK`: Request succeeded
- `201 Created`: Resource created successfully
- `204 No Content`: Request succeeded, no content to return
- `400 Bad Request`: Invalid request data
- `401 Unauthorized`: Authentication required or failed
- `403 Forbidden`: Insufficient permissions
- `404 Not Found`: Resource not found
- `409 Conflict`: Resource conflict (e.g., duplicate)
- `422 Unprocessable Entity`: Validation errors
- `500 Internal Server Error`: Server error

## Error Response Format

```json
{
  "error": {
    "code": "VALIDATION_ERROR",
    "message": "Validation failed",
    "details": [
      {
        "field": "email",
        "message": "Email is required"
      }
    ]
  }
}
```

## Pagination

List endpoints support pagination using query parameters:

- `page`: Page number (default: 1)
- `pageSize`: Items per page (default: 20, max: 100)
- `sortBy`: Field to sort by
- `sortOrder`: `asc` or `desc`

**Example:**
```http
GET /api/insumos?page=2&pageSize=50&sortBy=name&sortOrder=asc
```

**Response:**
```json
{
  "data": [...],
  "pagination": {
    "currentPage": 2,
    "pageSize": 50,
    "totalPages": 10,
    "totalCount": 500,
    "hasNextPage": true,
    "hasPreviousPage": true
  }
}
```

## Filtering and Search

Use query parameters for filtering:

```http
GET /api/insumos?categoryId=uuid&search=sugar&minPrice=10&maxPrice=100
```

---

## Endpoints

## 1. Authentication & Authorization

### Login

```http
POST /api/auth/login
```

**Request Body:**
```json
{
  "email": "user@example.com",
  "password": "password123"
}
```

### Register

```http
POST /api/auth/register
```

**Request Body:**
```json
{
  "email": "user@example.com",
  "password": "password123",
  "firstName": "John",
  "lastName": "Doe",
  "tenantId": "uuid"
}
```

### Refresh Token

```http
POST /api/auth/refresh
```

**Request Body:**
```json
{
  "refreshToken": "refresh_token_here"
}
```

### Logout

```http
POST /api/auth/logout
```

---

## 2. Users

### List Users

```http
GET /api/users
```

**Query Parameters:**
- `page` (int): Page number
- `pageSize` (int): Items per page
- `role` (string): Filter by role
- `isActive` (bool): Filter by active status

**Response:**
```json
{
  "data": [
    {
      "id": "uuid",
      "email": "user@example.com",
      "firstName": "John",
      "lastName": "Doe",
      "role": "Manager",
      "isActive": true,
      "createdAt": "2024-01-01T00:00:00Z"
    }
  ],
  "pagination": {...}
}
```

### Get User by ID

```http
GET /api/users/{id}
```

**Response:**
```json
{
  "id": "uuid",
  "email": "user@example.com",
  "firstName": "John",
  "lastName": "Doe",
  "role": "Manager",
  "isActive": true,
  "tenantId": "uuid",
  "createdAt": "2024-01-01T00:00:00Z",
  "updatedAt": "2024-01-01T00:00:00Z"
}
```

### Create User

```http
POST /api/users
```

**Request Body:**
```json
{
  "email": "newuser@example.com",
  "password": "password123",
  "firstName": "Jane",
  "lastName": "Smith",
  "role": "User"
}
```

### Update User

```http
PUT /api/users/{id}
```

**Request Body:**
```json
{
  "firstName": "Jane",
  "lastName": "Smith",
  "role": "Manager",
  "isActive": true
}
```

### Delete User

```http
DELETE /api/users/{id}
```

---

## 3. Insumos (Inputs)

### List Insumos

```http
GET /api/insumos
```

**Query Parameters:**
- `page`, `pageSize`, `sortBy`, `sortOrder`
- `categoryId` (uuid): Filter by category
- `search` (string): Search in name/description
- `minPrice`, `maxPrice` (decimal): Price range

**Response:**
```json
{
  "data": [
    {
      "id": "uuid",
      "name": "Sugar",
      "description": "White refined sugar",
      "categoryId": "uuid",
      "categoryName": "Ingredients",
      "unitOfMeasure": "kg",
      "currentPrice": 5.50,
      "supplierId": "uuid",
      "supplierName": "ABC Supplier",
      "createdAt": "2024-01-01T00:00:00Z"
    }
  ],
  "pagination": {...}
}
```

### Get Insumo by ID

```http
GET /api/insumos/{id}
```

**Response:**
```json
{
  "id": "uuid",
  "name": "Sugar",
  "description": "White refined sugar",
  "categoryId": "uuid",
  "categoryName": "Ingredients",
  "unitOfMeasure": "kg",
  "currentPrice": 5.50,
  "supplierId": "uuid",
  "supplierName": "ABC Supplier",
  "stockQuantity": 100,
  "minimumStock": 10,
  "createdAt": "2024-01-01T00:00:00Z",
  "updatedAt": "2024-01-01T00:00:00Z"
}
```

### Create Insumo

```http
POST /api/insumos
```

**Request Body:**
```json
{
  "name": "Sugar",
  "description": "White refined sugar",
  "categoryId": "uuid",
  "unitOfMeasure": "kg",
  "currentPrice": 5.50,
  "supplierId": "uuid",
  "stockQuantity": 100,
  "minimumStock": 10
}
```

### Update Insumo

```http
PUT /api/insumos/{id}
```

**Request Body:**
```json
{
  "name": "Sugar",
  "description": "White refined sugar - updated",
  "currentPrice": 5.75,
  "stockQuantity": 120
}
```

### Delete Insumo

```http
DELETE /api/insumos/{id}
```

### Get Insumo Price History

```http
GET /api/insumos/{id}/price-history
```

**Response:**
```json
{
  "data": [
    {
      "price": 5.50,
      "date": "2024-01-01T00:00:00Z"
    },
    {
      "price": 5.75,
      "date": "2024-02-01T00:00:00Z"
    }
  ]
}
```

### Get Insumo Categories

```http
GET /api/insumos/categories
```

**Response:**
```json
{
  "data": [
    {
      "id": "uuid",
      "name": "Ingredients",
      "description": "Food ingredients",
      "parentCategoryId": null
    }
  ]
}
```

### Import Insumos

```http
POST /api/insumos/import
Content-Type: multipart/form-data
```

**Form Data:**
- `file`: CSV or Excel file

**CSV Format:**
```csv
name,description,categoryName,unitOfMeasure,currentPrice,supplierName
Sugar,White refined sugar,Ingredients,kg,5.50,ABC Supplier
```

---

## 4. Services

### List Services

```http
GET /api/services
```

**Query Parameters:**
- `page`, `pageSize`, `sortBy`, `sortOrder`
- `search` (string): Search in name/description

**Response:**
```json
{
  "data": [
    {
      "id": "uuid",
      "name": "Orange Juice",
      "description": "Fresh orange juice",
      "totalCost": 12.50,
      "markup": 30.0,
      "finalPrice": 16.25,
      "insumoCount": 5,
      "createdAt": "2024-01-01T00:00:00Z"
    }
  ],
  "pagination": {...}
}
```

### Get Service by ID

```http
GET /api/services/{id}
```

**Response:**
```json
{
  "id": "uuid",
  "name": "Orange Juice",
  "description": "Fresh orange juice",
  "markup": 30.0,
  "insumos": [
    {
      "insumoId": "uuid",
      "insumoName": "Sugar",
      "quantity": 0.1,
      "unitOfMeasure": "kg",
      "unitCost": 5.50,
      "totalCost": 0.55
    },
    {
      "insumoId": "uuid",
      "insumoName": "Orange Pulp",
      "quantity": 0.5,
      "unitOfMeasure": "L",
      "unitCost": 15.00,
      "totalCost": 7.50
    }
  ],
  "totalCost": 12.50,
  "finalPrice": 16.25,
  "createdAt": "2024-01-01T00:00:00Z",
  "updatedAt": "2024-01-01T00:00:00Z"
}
```

### Create Service

```http
POST /api/services
```

**Request Body:**
```json
{
  "name": "Orange Juice",
  "description": "Fresh orange juice",
  "markup": 30.0,
  "insumos": [
    {
      "insumoId": "uuid",
      "quantity": 0.1
    },
    {
      "insumoId": "uuid",
      "quantity": 0.5
    }
  ]
}
```

### Update Service

```http
PUT /api/services/{id}
```

**Request Body:**
```json
{
  "name": "Orange Juice - Premium",
  "markup": 35.0,
  "insumos": [
    {
      "insumoId": "uuid",
      "quantity": 0.15
    }
  ]
}
```

### Delete Service

```http
DELETE /api/services/{id}
```

### Get Service Cost Breakdown

```http
GET /api/services/{id}/cost-breakdown
```

**Response:**
```json
{
  "serviceName": "Orange Juice",
  "breakdown": [
    {
      "category": "Ingredients",
      "cost": 8.50,
      "percentage": 68.0
    },
    {
      "category": "Packaging",
      "cost": 2.00,
      "percentage": 16.0
    },
    {
      "category": "Operation",
      "cost": 2.00,
      "percentage": 16.0
    }
  ],
  "totalCost": 12.50,
  "markup": 30.0,
  "finalPrice": 16.25
}
```

### Simulate Service Cost

```http
POST /api/services/{id}/simulate-cost
```

**Request Body:**
```json
{
  "insumos": [
    {
      "insumoId": "uuid",
      "quantity": 0.2,
      "customPrice": 6.00
    }
  ],
  "customMarkup": 40.0
}
```

**Response:**
```json
{
  "totalCost": 13.00,
  "markup": 40.0,
  "finalPrice": 18.20
}
```

---

## 5. Budgets

### List Budgets

```http
GET /api/budgets
```

**Query Parameters:**
- `page`, `pageSize`, `sortBy`, `sortOrder`
- `status` (string): Filter by status (Draft, Sent, Approved, Rejected)
- `clientId` (uuid): Filter by client
- `eventId` (uuid): Filter by event
- `fromDate`, `toDate` (date): Date range

**Response:**
```json
{
  "data": [
    {
      "id": "uuid",
      "number": "BUD-2024-001",
      "clientName": "Acme Corp",
      "eventName": "Company Anniversary",
      "status": "Sent",
      "totalAmount": 5000.00,
      "validUntil": "2024-12-31",
      "createdAt": "2024-01-01T00:00:00Z"
    }
  ],
  "pagination": {...}
}
```

### Get Budget by ID

```http
GET /api/budgets/{id}
```

**Response:**
```json
{
  "id": "uuid",
  "number": "BUD-2024-001",
  "clientId": "uuid",
  "clientName": "Acme Corp",
  "eventId": "uuid",
  "eventName": "Company Anniversary",
  "status": "Sent",
  "services": [
    {
      "serviceId": "uuid",
      "serviceName": "Orange Juice",
      "quantity": 100,
      "unitPrice": 16.25,
      "totalPrice": 1625.00
    }
  ],
  "subtotal": 4500.00,
  "discount": 0.00,
  "tax": 500.00,
  "totalAmount": 5000.00,
  "validUntil": "2024-12-31",
  "notes": "Special discount applied",
  "createdAt": "2024-01-01T00:00:00Z",
  "updatedAt": "2024-01-01T00:00:00Z"
}
```

### Create Budget

```http
POST /api/budgets
```

**Request Body:**
```json
{
  "clientId": "uuid",
  "eventId": "uuid",
  "services": [
    {
      "serviceId": "uuid",
      "quantity": 100
    }
  ],
  "discount": 0.00,
  "tax": 10.0,
  "validUntil": "2024-12-31",
  "notes": "Special discount applied"
}
```

### Update Budget

```http
PUT /api/budgets/{id}
```

**Request Body:**
```json
{
  "services": [
    {
      "serviceId": "uuid",
      "quantity": 120
    }
  ],
  "discount": 5.0
}
```

### Delete Budget

```http
DELETE /api/budgets/{id}
```

### Create Budget Version

```http
POST /api/budgets/{id}/versions
```

**Request Body:**
```json
{
  "versionName": "Alternative Option",
  "services": [
    {
      "serviceId": "uuid",
      "quantity": 80
    }
  ]
}
```

### Get Budget as PDF

```http
GET /api/budgets/{id}/pdf
```

**Response:** PDF file download

### Send Budget

```http
POST /api/budgets/{id}/send
```

**Request Body:**
```json
{
  "recipientEmail": "client@example.com",
  "message": "Please review the budget for your event."
}
```

### Approve Budget

```http
PUT /api/budgets/{id}/approve
```

**Request Body:**
```json
{
  "approvedBy": "uuid",
  "notes": "Approved with minor changes"
}
```

### Reject Budget

```http
PUT /api/budgets/{id}/reject
```

**Request Body:**
```json
{
  "rejectedBy": "uuid",
  "reason": "Price too high"
}
```

---

## 6. Events

### List Events

```http
GET /api/events
```

**Query Parameters:**
- `page`, `pageSize`, `sortBy`, `sortOrder`
- `status` (string): Filter by status
- `fromDate`, `toDate` (date): Date range

**Response:**
```json
{
  "data": [
    {
      "id": "uuid",
      "name": "Company Anniversary",
      "startDate": "2024-06-15T10:00:00Z",
      "endDate": "2024-06-15T18:00:00Z",
      "location": "Convention Center",
      "status": "Planning",
      "budgetId": "uuid",
      "taskCount": 25,
      "completedTaskCount": 10
    }
  ],
  "pagination": {...}
}
```

### Get Event by ID

```http
GET /api/events/{id}
```

**Response:**
```json
{
  "id": "uuid",
  "name": "Company Anniversary",
  "description": "Annual company anniversary celebration",
  "startDate": "2024-06-15T10:00:00Z",
  "endDate": "2024-06-15T18:00:00Z",
  "location": "Convention Center",
  "status": "Planning",
  "budgetId": "uuid",
  "createdBy": "uuid",
  "teamMembers": [
    {
      "userId": "uuid",
      "name": "John Doe",
      "role": "Coordinator"
    }
  ],
  "createdAt": "2024-01-01T00:00:00Z",
  "updatedAt": "2024-01-01T00:00:00Z"
}
```

### Create Event

```http
POST /api/events
```

**Request Body:**
```json
{
  "name": "Company Anniversary",
  "description": "Annual company anniversary celebration",
  "startDate": "2024-06-15T10:00:00Z",
  "endDate": "2024-06-15T18:00:00Z",
  "location": "Convention Center",
  "budgetId": "uuid",
  "teamMembers": ["uuid1", "uuid2"]
}
```

### Update Event

```http
PUT /api/events/{id}
```

### Delete Event

```http
DELETE /api/events/{id}
```

### Get Event Schedule

```http
GET /api/events/{id}/schedule
```

**Response:**
```json
{
  "eventId": "uuid",
  "scheduleItems": [
    {
      "id": "uuid",
      "title": "Setup",
      "startTime": "2024-06-15T08:00:00Z",
      "endTime": "2024-06-15T10:00:00Z",
      "assignedTo": ["uuid1"]
    }
  ]
}
```

### Get Event Tasks

```http
GET /api/events/{id}/tasks
```

**Response:**
```json
{
  "data": [
    {
      "id": "uuid",
      "title": "Order decorations",
      "description": "Order flowers and balloons",
      "status": "InProgress",
      "priority": "High",
      "assignedTo": "uuid",
      "assignedToName": "John Doe",
      "dueDate": "2024-06-01T00:00:00Z"
    }
  ]
}
```

### Create Event Task

```http
POST /api/events/{id}/tasks
```

**Request Body:**
```json
{
  "title": "Order decorations",
  "description": "Order flowers and balloons",
  "priority": "High",
  "assignedTo": "uuid",
  "dueDate": "2024-06-01T00:00:00Z"
}
```

---

## 7. Clients

### List Clients

```http
GET /api/clients
```

### Get Client by ID

```http
GET /api/clients/{id}
```

### Create Client

```http
POST /api/clients
```

**Request Body:**
```json
{
  "name": "Acme Corp",
  "email": "contact@acme.com",
  "phone": "+1234567890",
  "address": "123 Main St, City, Country",
  "contactPerson": "Jane Smith"
}
```

---

## 8. Reports

### Generate Budget Report

```http
GET /api/reports/budgets
```

**Query Parameters:**
- `fromDate`, `toDate`
- `clientId`
- `status`

### Generate Event Report

```http
GET /api/reports/events
```

### Generate Revenue Report

```http
GET /api/reports/revenue
```

---

## Webhooks

### Register Webhook

```http
POST /api/webhooks
```

**Request Body:**
```json
{
  "url": "https://your-app.com/webhook",
  "events": ["budget.approved", "event.created"],
  "secret": "webhook_secret"
}
```

### Webhook Payload Format

```json
{
  "eventType": "budget.approved",
  "timestamp": "2024-01-01T00:00:00Z",
  "data": {
    "budgetId": "uuid",
    "approvedBy": "uuid"
  },
  "signature": "hmac_sha256_signature"
}
```

---

## Rate Limiting

- **Authenticated requests**: 1000 requests per hour
- **Unauthenticated requests**: 100 requests per hour

Rate limit headers:
```
X-RateLimit-Limit: 1000
X-RateLimit-Remaining: 999
X-RateLimit-Reset: 1234567890
```

---

## Versioning

API versioning is done via URL path:

- `/api/v1/insumos`
- `/api/v2/insumos`

Current version: `v1`

---

## Support

For API support, contact: api-support@orsacusto.com
