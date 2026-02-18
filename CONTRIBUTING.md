# Contributing to OrsaCusto

First off, thank you for considering contributing to OrsaCusto! It's people like you that make OrsaCusto such a great tool.

## Code of Conduct

This project and everyone participating in it is governed by our Code of Conduct. By participating, you are expected to uphold this code.

## How Can I Contribute?

### Reporting Bugs

Before creating bug reports, please check the existing issues to avoid duplicates. When you create a bug report, include as many details as possible:

- **Use a clear and descriptive title**
- **Describe the exact steps to reproduce the problem**
- **Provide specific examples to demonstrate the steps**
- **Describe the behavior you observed and what you expected**
- **Include screenshots if applicable**
- **Include your environment details** (OS, browser, .NET version, Node.js version)

### Suggesting Enhancements

Enhancement suggestions are tracked as GitHub issues. When creating an enhancement suggestion:

- **Use a clear and descriptive title**
- **Provide a detailed description of the suggested enhancement**
- **Explain why this enhancement would be useful**
- **List any similar features in other applications**

### Pull Requests

1. **Fork the repository** and create your branch from `develop`
2. **Make your changes** following our coding standards
3. **Add tests** if you've added code that should be tested
4. **Ensure all tests pass**
5. **Update documentation** as needed
6. **Write a clear commit message**

## Development Process

### Branch Naming Convention

- `feature/feature-name` - New features
- `bugfix/bug-description` - Bug fixes
- `hotfix/critical-issue` - Critical production fixes
- `refactor/component-name` - Code refactoring
- `docs/documentation-update` - Documentation changes

### Commit Messages

Follow the [Conventional Commits](https://www.conventionalcommits.org/) specification:

```
<type>(<scope>): <subject>

<body>

<footer>
```

Types:
- `feat`: New feature
- `fix`: Bug fix
- `docs`: Documentation changes
- `style`: Code style changes (formatting, etc.)
- `refactor`: Code refactoring
- `test`: Adding or updating tests
- `chore`: Maintenance tasks

Examples:
```
feat(insumos): add bulk import functionality

Added CSV import feature for insumos with validation
and error handling.

Closes #123
```

```
fix(budget): correct total calculation

Fixed an issue where tax was not included in the
total budget calculation.

Fixes #456
```

### Coding Standards

#### Backend (.NET/C#)

- Follow [C# Coding Conventions](https://docs.microsoft.com/en-us/dotnet/csharp/fundamentals/coding-style/coding-conventions)
- Use meaningful variable and method names
- Write XML documentation comments for public APIs
- Keep methods small and focused
- Use async/await for I/O operations
- Follow SOLID principles
- Write unit tests for business logic

Example:
```csharp
/// <summary>
/// Calculates the total cost of a service including all insumos.
/// </summary>
/// <param name="serviceId">The unique identifier of the service.</param>
/// <returns>The total cost as a decimal value.</returns>
public async Task<decimal> CalculateServiceCost(Guid serviceId)
{
    var service = await _repository.GetByIdAsync(serviceId);
    return service.Insumos.Sum(i => i.Quantity * i.UnitCost);
}
```

#### Frontend (TypeScript/React)

- Follow [Airbnb JavaScript Style Guide](https://github.com/airbnb/javascript)
- Use TypeScript for type safety
- Use functional components with hooks
- Keep components small and reusable
- Use meaningful component and prop names
- Write PropTypes or TypeScript interfaces
- Use CSS modules or styled-components
- Write unit tests for components

Example:
```typescript
interface InsumoCardProps {
  insumo: Insumo;
  onEdit: (id: string) => void;
  onDelete: (id: string) => void;
}

export const InsumoCard: React.FC<InsumoCardProps> = ({ 
  insumo, 
  onEdit, 
  onDelete 
}) => {
  return (
    <Card>
      <CardHeader>{insumo.name}</CardHeader>
      <CardBody>
        <p>{insumo.description}</p>
        <p>Price: ${insumo.currentPrice}</p>
      </CardBody>
      <CardFooter>
        <Button onClick={() => onEdit(insumo.id)}>Edit</Button>
        <Button onClick={() => onDelete(insumo.id)}>Delete</Button>
      </CardFooter>
    </Card>
  );
};
```

### Testing

#### Backend Tests

```bash
# Run all tests
dotnet test

# Run with coverage
dotnet test /p:CollectCoverage=true

# Run specific test
dotnet test --filter "FullyQualifiedName~InsumoServiceTests"
```

Write tests for:
- Business logic
- API endpoints
- Database operations
- Validation logic

#### Frontend Tests

```bash
# Run all tests
npm test

# Run with coverage
npm test -- --coverage

# Run specific test
npm test -- InsumoCard.test.tsx
```

Write tests for:
- Component rendering
- User interactions
- API calls
- State management

### Documentation

- Update README.md if you change functionality
- Add JSDoc/XML comments to public APIs
- Update API documentation for endpoint changes
- Add examples for complex features

## Project Structure

### Backend Structure

```
backend/
├── OrsaCusto.Api/              # Web API layer
├── OrsaCusto.Application/      # Business logic
├── OrsaCusto.Domain/           # Domain models
├── OrsaCusto.Infrastructure/   # Data access
└── OrsaCusto.Tests/            # Tests
```

### Frontend Structure

```
frontend/
├── src/
│   ├── components/    # Reusable components
│   ├── pages/         # Page components
│   ├── services/      # API services
│   ├── store/         # State management
│   ├── types/         # TypeScript types
│   └── utils/         # Utility functions
```

## Getting Help

- Check the [Documentation](docs/)
- Search [existing issues](https://github.com/JoaoManoel-prog/OrsaCusto/issues)
- Ask in [Discussions](https://github.com/JoaoManoel-prog/OrsaCusto/discussions)
- Email: support@orsacusto.com

## Recognition

Contributors will be recognized in:
- CONTRIBUTORS.md file
- Release notes
- Project documentation

Thank you for contributing to OrsaCusto! 🎉
