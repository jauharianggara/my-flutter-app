# GitHub Actions Workflows

This repository uses GitHub Actions for CI/CD automation. Here's what each workflow does:

## 🔄 CI/CD Pipeline (`ci.yml`)

**Triggers:** Push to `main`/`develop`, Pull Requests to `main`

**What it does:**
- **Test Job**: Runs on Ubuntu
  - Checks code formatting with `dart format`
  - Analyzes code with `flutter analyze`
  - Generates model files with `build_runner`
  - Runs all tests with `flutter test`

- **Build Jobs** (only on `main` branch):
  - **Android**: Builds APK and uploads as artifact
  - **Windows**: Builds Windows executable and uploads as artifact
  - **Web**: Builds web app and uploads as artifact

## 🚀 Release (`release.yml`)

**Triggers:** Git tags starting with `v*` (e.g., `v1.0.0`)

**What it does:**
- Runs tests to ensure quality
- Builds Android APK and App Bundle
- Creates GitHub release with built artifacts
- Uploads APK and AAB files to the release

## 🔍 Code Quality (`quality.yml`)

**Triggers:** Push to `main`/`develop`, Pull Requests to `main`

**What it does:**
- **Static Analysis**: 
  - Code formatting checks
  - Dart analyzer with fatal infos
  - Dependency validation
  - Outdated packages check

- **Test Coverage**:
  - Runs tests with coverage
  - Generates LCOV report
  - Uploads coverage to Codecov

## 📦 Dependency Updates (`dependencies.yml`)

**Triggers:** 
- Schedule: Every Monday at 9 AM UTC
- Manual trigger via workflow_dispatch

**What it does:**
- Checks for outdated dependencies
- Updates to latest versions
- Runs tests to ensure compatibility
- Creates automated PR if changes detected

## 🌐 Deploy to GitHub Pages (`deploy.yml`)

**Triggers:** 
- Push to `main` branch
- Manual trigger via workflow_dispatch

**What it does:**
- Builds Flutter web app
- Configures for GitHub Pages deployment
- Deploys to GitHub Pages
- Makes app available at: `https://jauharianggara.github.io/my-flutter-app/`

## 🛠️ Setup Instructions

### 1. Enable GitHub Actions
1. Go to your repository settings
2. Navigate to "Actions" → "General"
3. Ensure "Allow all actions and reusable workflows" is selected

### 2. Enable GitHub Pages
1. Go to repository "Settings" → "Pages"
2. Source: "Deploy from a branch" or "GitHub Actions"
3. If using branch: select `gh-pages` branch
4. If using GitHub Actions: workflows will handle deployment

### 3. Add Secrets (if needed)
For private repositories or additional features:

1. Go to "Settings" → "Secrets and variables" → "Actions"
2. Add repository secrets:
   - `CODECOV_TOKEN` (for private repos coverage)
   - `ANDROID_KEYSTORE_*` (for signed Android builds)

### 4. Configure Permissions
For GitHub Pages deployment:
1. Go to "Settings" → "Actions" → "General"
2. Workflow permissions: "Read and write permissions"
3. Check "Allow GitHub Actions to create and approve pull requests"

## 📊 Status Badges

Add these badges to your README:

```markdown
[![CI/CD Pipeline](https://github.com/jauharianggara/my-flutter-app/actions/workflows/ci.yml/badge.svg)](https://github.com/jauharianggara/my-flutter-app/actions/workflows/ci.yml)
[![Code Quality](https://github.com/jauharianggara/my-flutter-app/actions/workflows/quality.yml/badge.svg)](https://github.com/jauharianggara/my-flutter-app/actions/workflows/quality.yml)
[![Deploy to GitHub Pages](https://github.com/jauharianggara/my-flutter-app/actions/workflows/deploy.yml/badge.svg)](https://github.com/jauharianggara/my-flutter-app/actions/workflows/deploy.yml)
[![codecov](https://codecov.io/gh/jauharianggara/my-flutter-app/branch/main/graph/badge.svg)](https://codecov.io/gh/jauharianggara/my-flutter-app)
```

## 🎯 Workflow Benefits

1. **Automated Testing**: Every push and PR is tested
2. **Multi-Platform Builds**: Android, Windows, and Web builds
3. **Code Quality**: Consistent formatting and analysis
4. **Automated Releases**: Tag-based releases with artifacts
5. **Dependency Management**: Automated dependency updates
6. **Live Demo**: Web app deployed to GitHub Pages
7. **Coverage Tracking**: Test coverage reports
8. **PR Automation**: Templates and checks for contributors

## 🔧 Customization

### Adding New Platforms
To add iOS builds, add this job to `ci.yml`:

```yaml
build-ios:
  name: Build iOS
  runs-on: macos-latest
  needs: test
  if: github.ref == 'refs/heads/main'
  
  steps:
  - name: Checkout code
    uses: actions/checkout@v4
    
  - name: Setup Flutter
    uses: subosito/flutter-action@v2
    with:
      flutter-version: '3.24.3'
      channel: 'stable'
      
  - name: Install dependencies
    run: flutter pub get
    
  - name: Generate model files
    run: flutter packages pub run build_runner build --delete-conflicting-outputs
    
  - name: Build iOS app
    run: flutter build ios --release --no-codesign
```

### Modifying Triggers
Change workflow triggers by editing the `on:` section:

```yaml
on:
  push:
    branches: [ main, develop, staging ]
  pull_request:
    branches: [ main ]
  schedule:
    - cron: '0 2 * * *'  # Daily at 2 AM
  workflow_dispatch:     # Manual trigger
```

### Environment-Specific Builds
Add environment-specific configurations:

```yaml
strategy:
  matrix:
    environment: [dev, staging, prod]
include:
  - environment: dev
    base_href: "/my-flutter-app-dev/"
  - environment: prod
    base_href: "/my-flutter-app/"
```

## 📋 Monitoring Workflows

1. **View workflow runs**: Go to "Actions" tab in your repository
2. **Check logs**: Click on any workflow run to see detailed logs
3. **Download artifacts**: Built files are available as downloadable artifacts
4. **Monitor status**: Use status badges to see current state
5. **Email notifications**: GitHub sends emails for failed workflows

## 🚨 Troubleshooting

### Common Issues

1. **Build Failures**: Check Flutter version compatibility
2. **Test Failures**: Ensure all tests pass locally first
3. **Permission Errors**: Verify workflow permissions in settings
4. **Artifact Upload Issues**: Check file paths and artifact names
5. **Pages Deployment**: Ensure proper base-href configuration

### Debug Tips

1. Add debug steps to workflows:
   ```yaml
   - name: Debug Environment
     run: |
       flutter --version
       flutter doctor
       env
   ```

2. Use workflow_dispatch for manual testing:
   ```yaml
   on:
     workflow_dispatch:
       inputs:
         debug:
           description: 'Enable debug mode'
           required: false
           default: 'false'
   ```

## 📝 Next Steps

1. Push your code to trigger workflows
2. Create a release tag to test release workflow
3. Monitor workflow runs and optimize as needed
4. Set up branch protection rules for main branch
5. Configure automatic dependency updates review process