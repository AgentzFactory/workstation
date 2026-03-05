# Contributing to Workstation

Thank you for your interest in contributing! This document explains how to contribute effectively.

## 🔄 Development Workflow (Trunk-Based)

We use **trunk-based development** with a focus on cost efficiency:

- **`main`** (also called `trunk`): The stable branch
- **Short-lived feature branches**: `feat/*`, `fix/*`, `docs/*`
- **No long-running branches**: Everything merges to trunk quickly

## 🍴 Fork-Based Contributions (Cost Efficient)

To optimize costs for the organization, **external contributors must use forks**:

### For External Contributors (Fork Workflow)

1. **Fork** the repository to your personal GitHub account
2. **Clone your fork** locally:
   ```bash
   git clone https://github.com/YOUR_USERNAME/workstation.git
   cd workstation
   ```
3. **Add upstream remote**:
   ```bash
   git remote add upstream https://github.com/AgentzFactory/workstation.git
   ```
4. **Create a feature branch**:
   ```bash
   git checkout -b feat/your-feature-name
   ```
5. **Make changes** and commit
6. **Push to your fork**:
   ```bash
   git push origin feat/your-feature-name
   ```
7. **Open a Pull Request** from your fork to `AgentzFactory/workstation:main`

### For Maintainers (Direct Workflow)

Maintainers with write access can create branches directly:

```bash
# Create feature branch
git checkout -b feat/new-feature

# Work, commit, push
git push origin feat/new-feature

# Open PR to main
```

## 🌿 Branch Naming Conventions

| Prefix | Purpose | Example |
|--------|---------|---------|
| `feat/` | New feature | `feat/cli-onboard` |
| `feature/` | Alternative for features | `feature/seat-templates` |
| `fix/` | Bug fix | `fix/submodule-path` |
| `hotfix/` | Urgent fix | `hotfix/security-patch` |
| `docs/` | Documentation | `docs/architecture-update` |

## ✅ Before Submitting a PR

1. **Run tests locally**:
   ```bash
   bash tests/test-workstation.sh
   ```

2. **Check shell script syntax**:
   ```bash
   bash -n bin/workstation
   bash -n install-cli.sh
   ```

3. **Update documentation** if needed:
   - README.md for user-facing changes
   - docs/*.md for detailed documentation
   - This file for contribution process changes

4. **Write a clear PR description**:
   - What changed?
   - Why?
   - Testing done?

## 🧪 Testing Guidelines

### Unit Tests
- Add tests to `tests/test-workstation.sh`
- Tests should be independent and idempotent
- Use descriptive test names

### Integration Tests
- Test the full workflow when possible
- Use temporary directories (`/tmp/workstation-test-*`)
- Clean up after tests

### Manual Testing
For changes to the CLI:
```bash
# Install locally
bash install-cli.sh

# Test commands
workstation help
workstation status
```

## 📝 Code Style

### Shell Scripts
- Use `#!/usr/bin/env bash`
- Use `set -euo pipefail` for safety
- Quote all variables: `"${var}"`
- Use meaningful function names
- Add comments for complex logic

### Documentation
- Use clear, concise language
- Include examples
- Keep line length under 100 characters

## 🔒 Security

- **Never commit secrets** (tokens, passwords)
- Use `.gitignore` for sensitive files
- Report security issues privately to maintainers

## 📋 PR Review Process

1. **Automated checks** run on your PR:
   - Shell script validation
   - Tests
   - Security scan
   - Trunk-ready check

2. **For fork PRs**: Integration tests are skipped (forks don't have repo permissions). A maintainer will verify integration manually.

3. **Maintainer review**: At least one approval required

4. **Merge to trunk**: Squash and merge to `main`

## 🎯 What to Contribute

### Good First Issues
- Documentation improvements
- Bug fixes
- Test coverage
- Example scenarios

### Feature Requests
Open an issue first to discuss:
- New commands
- Architecture changes
- Breaking changes

### Current Priorities
See [Roadmap](../README.md#roadmap) for current focus areas.

## 🆘 Getting Help

- **Discussions**: Use GitHub Discussions for questions
- **Issues**: Report bugs via GitHub Issues
- **Discord**: [Join our community](https://discord.gg/clawd) (if available)

## 📜 License

By contributing, you agree that your contributions will be licensed under the [MIT License](../LICENSE).

---

Thank you for helping make Workstation better! 🎉
