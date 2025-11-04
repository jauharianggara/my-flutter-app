# Contributing to Employee Management Flutter App

We're excited that you're interested in contributing to this project! This document provides guidelines and information for contributors.

## Table of Contents

- [Getting Started](#getting-started)
- [Development Setup](#development-setup)
- [Code Style](#code-style)
- [Submitting Changes](#submitting-changes)
- [Reporting Issues](#reporting-issues)
- [Pull Request Process](#pull-request-process)
- [Testing](#testing)
- [Community Guidelines](#community-guidelines)

## Getting Started

1. **Fork the repository** on GitHub
2. **Clone your fork** locally:
   ```bash
   git clone https://github.com/YOUR_USERNAME/my-flutter-app.git
   cd my-flutter-app
   ```
3. **Add the upstream repository**:
   ```bash
   git remote add upstream https://github.com/jauharianggara/my-flutter-app.git
   ```

## Development Setup

### Prerequisites

- Flutter SDK 3.24.3 or higher
- Dart SDK
- Android Studio or VS Code with Flutter extension
- Git

### Setup Steps

1. **Install dependencies**:
   ```bash
   flutter pub get
   ```

2. **Generate model files**:
   ```bash
   flutter packages pub run build_runner build --delete-conflicting-outputs
   ```

3. **Run tests to ensure everything works**:
   ```bash
   flutter test
   ```

4. **Start the development server**:
   ```bash
   flutter run -d windows --observatory-port=58295
   ```

## Code Style

### Dart/Flutter Guidelines

- Follow the [Dart Style Guide](https://dart.dev/guides/language/effective-dart/style)
- Use `flutter format` to format your code
- Ensure `flutter analyze` passes without warnings
- Use meaningful variable and function names
- Add comments for complex logic

### File Structure

- Place models in `lib/models/`
- Place services in `lib/services/`
- Place providers in `lib/providers/`
- Place screens in `lib/screens/`
- Place reusable widgets in `lib/widgets/`
- Place utilities in `lib/utils/`

### Naming Conventions

- Use `snake_case` for file names
- Use `camelCase` for variable and function names
- Use `PascalCase` for class names
- Use descriptive names for API endpoints and methods

## Submitting Changes

### Before You Start

1. **Check existing issues** to see if your idea is already being worked on
2. **Open an issue** to discuss major changes before starting work
3. **Keep changes focused** - one feature or fix per pull request

### Workflow

1. **Create a feature branch**:
   ```bash
   git checkout -b feature/your-feature-name
   ```

2. **Make your changes** following the code style guidelines

3. **Test your changes**:
   ```bash
   flutter test
   flutter analyze
   flutter format --set-exit-if-changed .
   ```

4. **Generate model files if needed**:
   ```bash
   flutter packages pub run build_runner build --delete-conflicting-outputs
   ```

5. **Commit your changes** with a descriptive message:
   ```bash
   git commit -m "feat: add employee photo upload feature"
   ```

6. **Push to your fork**:
   ```bash
   git push origin feature/your-feature-name
   ```

7. **Create a Pull Request** using our PR template

### Commit Message Format

We use [Conventional Commits](https://www.conventionalcommits.org/):

```
type(scope): description

[optional body]

[optional footer]
```

Types:
- `feat`: A new feature
- `fix`: A bug fix
- `docs`: Documentation only changes
- `style`: Code style changes (formatting, etc.)
- `refactor`: Code refactoring
- `test`: Adding or updating tests
- `chore`: Maintenance tasks

Examples:
```
feat(auth): add JWT token refresh functionality
fix(ui): resolve responsive layout issues on mobile
docs: update API documentation
test(services): add unit tests for auth service
```

## Reporting Issues

### Bug Reports

Use the bug report template and include:

- **Clear description** of the issue
- **Steps to reproduce** the problem
- **Expected vs actual behavior**
- **Environment details** (OS, Flutter version, device)
- **Screenshots** if applicable
- **Error logs** or stack traces

### Feature Requests

Use the feature request template and include:

- **Problem description** you're trying to solve
- **Proposed solution** or feature
- **Alternative solutions** considered
- **Additional context** or examples

## Pull Request Process

### Before Submitting

- [ ] Code follows the style guidelines
- [ ] Self-review completed
- [ ] Tests added/updated and passing
- [ ] Documentation updated if needed
- [ ] No merge conflicts with main branch

### PR Requirements

1. **Fill out the PR template** completely
2. **Link related issues** using "Closes #123"
3. **Add screenshots** for UI changes
4. **Update documentation** if needed
5. **Ensure CI checks pass**

### Review Process

1. **Automated checks** must pass (CI/CD pipeline)
2. **Code review** by maintainers
3. **Address feedback** promptly
4. **Approval** by at least one maintainer
5. **Merge** by maintainers

## Testing

### Running Tests

```bash
# Run all tests
flutter test

# Run tests with coverage
flutter test --coverage

# Run specific test file
flutter test test/services/auth_service_test.dart
```

### Writing Tests

- Write unit tests for all new services and utilities
- Write widget tests for new UI components
- Add integration tests for new user flows
- Mock external dependencies in tests
- Aim for high test coverage

### Test Structure

```dart
group('AuthService', () {
  late AuthService authService;
  
  setUp(() {
    authService = AuthService();
  });
  
  test('should login successfully with valid credentials', () async {
    // Arrange
    // Act
    // Assert
  });
});
```

## Community Guidelines

### Code of Conduct

- Be respectful and inclusive
- Provide constructive feedback
- Help others learn and grow
- Focus on what's best for the community

### Getting Help

- Check existing documentation and issues first
- Ask questions in GitHub Discussions
- Provide context when asking for help
- Be patient and respectful

### Recognition

Contributors will be recognized in:
- GitHub contributors list
- Release notes for significant contributions
- Project documentation

## Development Tips

### Hot Reload and Debug

```bash
# Run with hot reload
flutter run -d windows --observatory-port=58295

# Debug with DevTools
flutter run -d windows --observatory-port=58295
# Then open: http://localhost:9100
```

### Common Commands

```bash
# Clean and rebuild
flutter clean && flutter pub get

# Update dependencies
flutter pub upgrade

# Check for outdated packages
flutter pub outdated

# Analyze code
flutter analyze

# Format code
flutter format .
```

### VS Code Tasks

Use these VS Code tasks for efficient development:
- "Flutter Run (Windows - Port 58295)"
- "Flutter Clean & Run"
- "Kill Flutter App Process"

## Questions?

If you have questions that aren't covered here:

1. Check the [README.md](README.md) for setup instructions
2. Look through existing [issues](https://github.com/jauharianggara/my-flutter-app/issues)
3. Create a new issue with the "question" label

Thank you for contributing! 🚀