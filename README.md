# Claude Utils

A collection of shell utility functions for seamless command-line interaction with Claude AI. These utilities make it easy to ask questions, analyze files, and process command output using Claude directly from your terminal.

## Prerequisites

- The `claude` CLI tool must be installed and available in your PATH
- Works with both bash and zsh

## Installation

1. Clone this repository:
```bash
git clone https://github.com/yourusername/claude-utils.git
cd claude-utils
```

2. Source the utilities in your shell configuration:
```bash
# For zsh users
echo "source $(pwd)/claude-utils.sh" >> ~/.zshrc
source ~/.zshrc

# For bash users
echo "source $(pwd)/claude-utils.sh" >> ~/.bashrc
source ~/.bashrc
```

## Functions

### `c` - Ask Claude Anything

The main command for sending questions to Claude. Supports both direct arguments and piped input.

```bash
# Direct question
c "how to install tree in ubuntu"

# Piped input
echo "what are best practices for shell scripting?" | c

# Multi-line with heredoc
c <<EOF
I need help creating a backup script that:
1. Backs up /home/user/documents
2. Compresses with gzip
3. Stores in /backup with timestamp
EOF
```

### `cfile` - Ask About a Single File

Send a file as context and ask questions about it.

**Usage:** `cfile <file> <question...>`

```bash
# Summarize a file
cfile notes.txt "summarise the main ideas"

# Get specific information
cfile README.md "how do I run the dev server?"

# Find bugs in code
cfile app.py "are there any potential bugs or security issues?"

# Analyze configuration
cfile nginx.conf "explain what this configuration does"
```

### `cproj` - Analyze Multiple Files

Query multiple files together for project-wide context.

**Usage:** `cproj <question...> -- <file1> [file2 ...]`

```bash
# Project overview
cproj "give me a high level summary of this project" -- README.md notes.md

# Find startup command
cproj "what command starts the dev server?" -- README.md package.json

# Architecture analysis
cproj "explain the architecture" -- architecture.md design-doc.md api-spec.yaml

# Check for conflicts
cproj "are there any conflicting settings?" -- .env.example config.yaml settings.json
```

### `csum` - Quick File Summary

Get a concise summary of any file, focusing on key points and actionable items.

**Usage:** `csum <file>`

```bash
# Summarize logs
csum error.log

# Meeting notes
csum meeting_notes.md

# Documentation
csum CHANGELOG.md

# Build output
csum build_output.txt
```

### `cpipe` - Process Command Output

Pipe any command output to Claude with custom instructions.

**Usage:** `<command> | cpipe "<instruction>"`

```bash
# Explain kernel logs
dmesg | tail -50 | cpipe "Explain this kernel log in simple terms."

# Summarize git changes
git diff | cpipe "Summarise this diff and tell me what changed."

# Debug network issues
netstat -tuln | cpipe "Are there any unusual ports open?"

# Analyze directory structure
tree -L 3 | cpipe "Explain the purpose of each directory."

# Review system processes
ps aux | cpipe "Are there any processes consuming unusual resources?"

# Explain build errors
npm run build 2>&1 | cpipe "Explain the errors and how to fix them."
```

## Common Workflows

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

## Advanced Examples

```bash
# Find and explain errors in logs
rg "ERROR" app.log | cpipe "explain the root cause and suggest a fix"

# Analyze test failures
pytest -v 2>&1 | cpipe "Explain why these tests failed and suggest fixes."

# Configuration debugging
cat config.yaml | cpipe "Check for syntax errors and validate this configuration."

# Quick code explanation
cat complex_function.py | cpipe "Explain what this function does step by step."

# Parse JSON API responses
curl -s https://api.example.com/status | cpipe "Extract the key metrics and explain their status."
```

## Tips

1. **Use quotes** for multi-word questions: `c "how do I..."`
2. **Double dash separator** is required for `cproj`: `cproj "question" -- file1 file2`
3. **Pipe complex input** using heredocs or echo for multi-line questions
4. **Combine with grep/rg** to filter before sending to Claude
5. **Chain commands** to preprocess data before asking questions

## How It Works

All functions use the `claude -p` command, which enables the prompt-caching feature for efficient API usage. They format your input with clear delimiters to help Claude understand the context and question.

## Additional Resources

See [claude-utils-usage-examples.md](claude-utils-usage-examples.md) for more detailed examples and use cases.

## License

MIT

## Contributing

Contributions are welcome! Feel free to submit issues or pull requests.
