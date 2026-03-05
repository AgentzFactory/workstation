# Contributing to Workstation

Thank you for your interest in contributing to Workstation! This document provides guidelines and instructions for contributing.

## Code of Conduct

This project and everyone participating in it is governed by our commitment to respectful collaboration. Be kind, be constructive, be professional.

## How Can I Contribute?

### Reporting Bugs

- Check if the bug has already been reported
- Open an issue with a clear title and description
- Include steps to reproduce, expected vs actual behavior
- Add environment details (OS, git version, shell)

### Suggesting Enhancements

- Open an issue with the `enhancement` label
- Describe the use case and expected behavior
- Discuss implementation approach if you have ideas

### Pull Requests

1. Fork the repository
2. Create a feature branch (`git checkout -b feature/amazing-feature`)
3. Make your changes
4. Test your changes
5. Commit with clear messages (`git commit -m 'Add amazing feature'`)
6. Push to your fork (`git push origin feature/amazing-feature`)
7. Open a Pull Request

### Documentation

Documentation improvements are always welcome:
- Fix typos or unclear explanations
- Add examples
- Translate to other languages
- Improve diagrams or visuals

## Development Setup

```bash
git clone https://github.com/yourorg/workstation.git
cd workstation
# No dependencies needed - Workstation is shell-based
```

## Project Structure

```
.
├── blueprint/          # Template files for new SSOT workspaces
├── docs/              # Extended documentation
├── scripts/           # Utility scripts
├── tests/             # Test suites
├── README.md          # Main documentation
└── CHANGELOG.md       # Version history
```

## Style Guidelines

### Shell Scripts

- Use `#!/usr/bin/env bash`
- Quote all variables: `"${var}"`
- Use `set -euo pipefail` for safety
- Add comments for complex logic
- Follow [Google Shell Style Guide](https://google.github.io/styleguide/shellguide.html)

### Documentation

- Use clear, concise language
- Include examples for every feature
- Keep line length under 100 characters
- Use code blocks with language tags

## Testing

Before submitting:
- Test scripts on clean environments
- Verify template generation works
- Check git operations complete successfully
- Validate documentation renders correctly

## Questions?

- Open a [Discussion](https://github.com/yourorg/workstation/discussions)
- Join our community chat (coming soon)

Thank you for contributing! 🚀
