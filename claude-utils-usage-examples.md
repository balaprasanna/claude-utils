# Claude Utils - Usage Examples

This document provides practical examples for each shell function in the Claude utilities toolkit.

---

## 1. `c` - Main "Ask Claude" Command

The base command for sending questions to Claude. Accepts both direct arguments and piped input.

### Examples

```bash
# Direct question
c "how to install tree in ubuntu"

# Piped input
echo "how to install tree in ubuntu" | c

# Multi-line question via pipe
echo "What are the best practices for:
- Writing shell scripts
- Error handling
- Variable naming" | c

# Using heredoc for complex questions
c <<EOF
I need to create a backup script that:
1. Backs up /home/user/documents
2. Compresses with gzip
3. Stores in /backup with timestamp
4. Keeps only last 7 backups
EOF
```

---

## 2. `cfile` - Ask Questions About a Single File

Send a file as context along with a question.

### Examples

```bash
# Summarize a text file
cfile notes.txt "summarise the main ideas"

# Get specific information from README
cfile README.md "how do I run the dev server?"

# Analyze configuration
cfile nginx.conf "explain what this configuration does"

# Find bugs in code
cfile app.py "are there any potential bugs or security issues?"

# Extract specific data
cfile package.json "what are all the dev dependencies?"

# Get installation instructions
cfile INSTALL.md "what are the prerequisites for Ubuntu 22.04?"
```

---

## 3. `cproj` - Send Multiple Files as Context

Use for analyzing multiple files together in a project context.

### Examples

```bash
# Project overview
cproj "give me a high level summary of this project" -- README.md notes.md

# Find startup command
cproj "what command starts the dev server?" -- README.md package.json

# Architecture analysis
cproj "explain the architecture and how components interact" -- \
  architecture.md \
  design-doc.md \
  api-spec.yaml

# Configuration review
cproj "are there any conflicting settings?" -- \
  .env.example \
  config.yaml \
  settings.json

# Documentation check
cproj "is the installation process documented correctly?" -- \
  README.md \
  INSTALL.md \
  docs/setup.md

# Find discrepancies
cproj "do the API docs match the implementation?" -- \
  api-documentation.md \
  routes.js \
  handlers.py
```

---

## 4. `csum` - Quickly Summarize a File

Fast TL;DR for any file. Focuses on key points and actionable items.

### Examples

```bash
# Summarize error logs
csum error.log

# Meeting notes summary
csum meeting_notes.md

# Long documentation
csum CHANGELOG.md

# Code review
csum pull_request_diff.txt

# System logs
csum /var/log/syslog

# Build output
csum build_output.txt
```

---

## 5. `cpipe` - Process Command Output with Instructions

Pipe any command output to Claude with custom instructions.

### Examples

```bash
# Explain kernel logs
dmesg | tail -50 | cpipe "Explain this kernel log in simple terms."

# Summarize git changes
git diff | cpipe "Summarise this diff and tell me what changed."

# Convert help to guide
mytool --help | cpipe "Convert this help text into a step-by-step usage guide."

# Analyze directory structure
tree -L 3 | cpipe "Explain the purpose of each directory in this project structure."

# Debug network issues
netstat -tuln | cpipe "Are there any unusual ports open or potential security issues?"

# Review recent commits
git log --oneline -20 | cpipe "Summarize the recent development activity."

# Analyze disk usage
du -h --max-depth=2 /var | cpipe "Which directories are taking up the most space?"

# Explain error output
npm run build 2>&1 | cpipe "Explain the errors and how to fix them."

# Parse JSON output
curl -s https://api.example.com/status | cpipe "Extract the key metrics and explain their status."

# Review system processes
ps aux | cpipe "Are there any processes consuming unusual amounts of resources?"
```

---

## Advanced Compositions

Once you have all functions set up, you can compose them for powerful workflows:

```bash
# Find and explain errors in logs
rg "ERROR" app.log | cpipe "explain the root cause and suggest a fix"

# Code review with context
cproj "find potential bugs in this design" -- design.md notes.md implementation.py

# Analyze test failures
pytest -v 2>&1 | cpipe "Explain why these tests failed and suggest fixes."

# Configuration debugging
cat config.yaml | cpipe "Check for syntax errors and validate this configuration."

# Quick code explanation
cat complex_function.py | cpipe "Explain what this function does step by step."

# Security audit
find . -name "*.sh" -exec cat {} \; | cpipe "Review these shell scripts for security issues."
```

---

## Installation Reminder

Add these functions to your shell configuration:

```bash
# Edit your shell config
nano ~/.zshrc    # or ~/.bashrc for bash users

# After adding the functions, reload:
source ~/.zshrc  # or source ~/.bashrc
```

---

## Tips

1. **Use quotes** for multi-word questions: `c "how do I..."`
2. **Double dash separator** is required for `cproj`: `cproj "question" -- file1 file2`
3. **Pipe complex input** using heredocs or echo for multi-line questions
4. **Combine with grep/rg** to filter before sending to Claude
5. **Chain commands** to preprocess data before asking questions

---

## Common Patterns

### Debugging Workflow
```bash
# 1. Check logs
csum error.log

# 2. Analyze specific errors
rg "FATAL" error.log | cpipe "What caused these fatal errors?"

# 3. Review related code
cfile problematic_module.py "where is the error being thrown?"
```

### Documentation Workflow
```bash
# 1. Understand project
cproj "what does this project do?" -- README.md package.json

# 2. Find specific info
cfile API.md "how do I authenticate requests?"

# 3. Get examples
cfile examples/sample.py "explain how this example works"
```

### Code Review Workflow
```bash
# 1. See what changed
git diff main..feature-branch | cpipe "summarize the changes"

# 2. Review specific files
cfile new_feature.js "are there any bugs or improvements needed?"

# 3. Check overall impact
cproj "will these changes break existing functionality?" -- \
  tests/test_suite.js \
  new_feature.js \
  related_module.js
```
