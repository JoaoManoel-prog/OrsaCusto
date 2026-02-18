# Quick Start Guide - OrsaCusto

This guide will help you get OrsaCusto running on your local machine in under 10 minutes.

## Prerequisites Checklist

Before starting, ensure you have:
- [ ] Docker Desktop installed (version 24.0+)
- [ ] Docker Compose installed (version 2.0+)
- [ ] Git installed (version 2.40+)
- [ ] 8GB RAM available
- [ ] 10GB disk space available

## Step 1: Clone the Repository

```bash
git clone https://github.com/JoaoManoel-prog/OrsaCusto.git
cd OrsaCusto
```

## Step 2: Review the Configuration

The default configuration is ready for development. Key files:
- `infrastructure/docker/docker-compose.yml` - Service definitions
- `database-schema.sql` - Database schema (auto-loaded)

## Step 3: Start the Application

```bash
cd infrastructure/docker
docker-compose up -d
```

This will start:
- PostgreSQL (port 5432)
- Redis (port 6379)
- Backend API (port 5000) - *When implemented*
- Frontend (port 3000) - *When implemented*
- Nginx (port 80) - *When implemented*

## Step 4: Verify Services Are Running

```bash
# Check all services
docker-compose ps

# Check logs
docker-compose logs -f

# Check specific service
docker-compose logs postgres
```

## Step 5: Access the Database

```bash
# Connect to PostgreSQL
docker-compose exec postgres psql -U orsacusto -d orsacusto

# List tables
\dt

# Exit
\q
```

## Step 6: Access the Application (After Implementation)

Once the backend and frontend are implemented:

- **Frontend**: http://localhost:3000
- **Backend API**: http://localhost:5000
- **API Docs**: http://localhost:5000/swagger
- **Nginx**: http://localhost

## Step 7: Stop the Application

```bash
# Stop all services
docker-compose down

# Stop and remove volumes (CAUTION: deletes data)
docker-compose down -v
```

## Default Credentials (After Implementation)

**Admin User**:
- Email: `admin@orsacusto.com`
- Password: `Admin@123`

**Regular User**:
- Email: `user@orsacusto.com`
- Password: `User@123`

## Troubleshooting

### Port Already in Use

If you get a "port already in use" error:

```bash
# Check what's using the port
lsof -i :5432  # For PostgreSQL
lsof -i :3000  # For Frontend

# Kill the process or change the port in docker-compose.yml
```

### Docker Daemon Not Running

```bash
# On macOS/Windows: Start Docker Desktop
# On Linux:
sudo systemctl start docker
```

### Database Connection Issues

```bash
# Check PostgreSQL logs
docker-compose logs postgres

# Restart PostgreSQL
docker-compose restart postgres

# Check if PostgreSQL is accepting connections
docker-compose exec postgres pg_isready -U orsacusto
```

### Out of Memory

```bash
# Check Docker memory allocation
docker stats

# Increase Docker Desktop memory:
# Docker Desktop → Settings → Resources → Memory → Increase
```

### Services Won't Start

```bash
# Remove all containers and start fresh
docker-compose down -v
docker-compose up -d

# Rebuild images
docker-compose build --no-cache
docker-compose up -d
```

## Development Workflow

### Making Backend Changes

1. Modify code in `backend/` directory
2. Backend will auto-reload (when implemented with hot reload)
3. If changes don't reflect, restart the service:
   ```bash
   docker-compose restart backend
   ```

### Making Frontend Changes

1. Modify code in `frontend/` directory
2. Frontend will hot-reload automatically
3. Changes reflect immediately in browser

### Database Changes

1. Create a new migration:
   ```bash
   cd backend/OrsaCusto.Infrastructure
   dotnet ef migrations add MigrationName --startup-project ../OrsaCusto.Api
   ```

2. Apply migration:
   ```bash
   dotnet ef database update --startup-project ../OrsaCusto.Api
   ```

3. Or restart with fresh database:
   ```bash
   docker-compose down -v
   docker-compose up -d
   ```

## Next Steps

Now that your environment is running:

1. **Review the Documentation**
   - Read [PROJECT_PLAN.md](PROJECT_PLAN.md) for the roadmap
   - Review [ARCHITECTURE.md](ARCHITECTURE.md) for technical details
   - Check [API_DOCUMENTATION.md](API_DOCUMENTATION.md) for API specs

2. **Start Development**
   - See [IMPLEMENTATION_SUMMARY.md](IMPLEMENTATION_SUMMARY.md) for next steps
   - Review [CONTRIBUTING.md](CONTRIBUTING.md) for guidelines
   - Create your feature branch and start coding!

3. **Run Tests**
   - Backend: `dotnet test` (once tests are implemented)
   - Frontend: `npm test` (once tests are implemented)

## Useful Commands

### Docker Compose

```bash
# Start services
docker-compose up -d

# Stop services
docker-compose stop

# View logs
docker-compose logs -f [service-name]

# Execute command in service
docker-compose exec [service-name] [command]

# Rebuild service
docker-compose build [service-name]

# Remove everything
docker-compose down -v
```

### Database

```bash
# Backup database
docker-compose exec postgres pg_dump -U orsacusto orsacusto > backup.sql

# Restore database
docker-compose exec -T postgres psql -U orsacusto orsacusto < backup.sql

# Access PostgreSQL CLI
docker-compose exec postgres psql -U orsacusto -d orsacusto
```

### Redis

```bash
# Access Redis CLI
docker-compose exec redis redis-cli

# Check Redis keys
docker-compose exec redis redis-cli keys '*'

# Flush Redis
docker-compose exec redis redis-cli FLUSHALL
```

## Environment Variables

Create a `.env` file in the root directory for custom configuration:

```env
# Database
POSTGRES_PASSWORD=your_secure_password
POSTGRES_DB=orsacusto
POSTGRES_USER=orsacusto

# Backend
JWT_SECRET=your_super_secret_jwt_key_change_this
ASPNETCORE_ENVIRONMENT=Development

# Frontend
REACT_APP_API_URL=http://localhost:5000/api
```

## Common Issues and Solutions

| Issue | Solution |
|-------|----------|
| Services won't start | Run `docker-compose down -v && docker-compose up -d` |
| Can't connect to database | Check port 5432 is not in use: `lsof -i :5432` |
| Frontend not loading | Clear browser cache, check console for errors |
| API returning 500 errors | Check backend logs: `docker-compose logs backend` |
| Out of disk space | Run `docker system prune -a` to clean up |

## Getting Help

- **Documentation**: Check the `/docs` directory
- **Issues**: https://github.com/JoaoManoel-prog/OrsaCusto/issues
- **Email**: support@orsacusto.com

## Success Checklist

After completing this guide, you should have:
- [ ] All Docker containers running
- [ ] Database initialized with schema
- [ ] Redis cache running
- [ ] Able to access the application (after implementation)
- [ ] Familiar with basic Docker Compose commands

---

**Congratulations!** 🎉 Your OrsaCusto development environment is ready.

Now you can start building the event budget planning platform!
