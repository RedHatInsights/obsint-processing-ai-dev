# Quick Setup Guide

## Prerequisites Check

Make sure you have these installed:
```bash
uv --version          # ✓ Already installed
docker --version      # ✓ Already installed
node --version        # ✓ Already installed
npm --version         # ✓ Already installed
gh --version          # ✓ Already installed
jq --version          # ✓ Already installed
```

Optional (for GitLab repos):
```bash
glab --version        # Install: brew install glab
```

## Setup Steps

### 1. Install Dependencies (Already Done ✓)
```bash
make install          # Installs Python deps with uv
```

### 2. Create .env File

Copy the example and fill in your credentials:
```bash
cp .env.example .env
```

Then edit `.env` with your values:
```bash
# Required:
JIRA_URL=https://your-instance.atlassian.net
JIRA_USERNAME=your-email@company.com
JIRA_API_TOKEN=<get from https://id.atlassian.com/manage-profile/security/api-tokens>

# Required for API access:
# Place service account key as sa-key.json in project root

# Required for GitHub:
GH_TOKEN=<get from https://github.com/settings/tokens - needs 'repo' scope>

# Optional for GitLab:
GITLAB_TOKEN=<your-gitlab-token>
```

### 3. Start Memory Server

```bash
make memory-server
```

This starts PostgreSQL + memory server in Docker. Dashboard will be at http://localhost:8080

### 4. Run the Bot

In a new terminal:
```bash
make run LABEL=obsint-processing-ai
```

## What Just Happened

The initial setup (`make install`) already:
- ✓ Created Python virtual environment (`.venv/`)
- ✓ Installed all Python packages
- ✓ Installed TypeScript Language Server
- ✓ Downloaded BrowserMCP extension

## Common Commands

```bash
make run LABEL=<label>     # Run bot with specific label
make stop                  # Stop running bot
make logs                  # View bot logs
make memory-server         # Start memory server
make memory-server-stop    # Stop memory server
make help                  # See all commands
```

## Next Steps

1. **Configure credentials** in `.env` (see step 2 above)
2. **Start memory server**: `make memory-server`
3. **Run the bot**: `make run LABEL=<your-label>`
4. **Prepare Jira tickets** - see [README.md](README.md#preparing-tickets-for-the-bot) for ticket requirements

## Troubleshooting

**Docker not running?**
```bash
open -a Docker    # Start Docker Desktop on macOS
```

**Missing dependencies?**
```bash
make init         # Re-run full setup
```

**Auth issues?**
```bash
gh auth login     # GitHub CLI auth
glab auth login   # GitLab CLI auth (if needed)
```

## Full Documentation

- [README.md](README.md) - Complete overview
- [SETUP.md](SETUP.md) - Detailed bot identity setup (SSH, GPG)
- [ARCHITECTURE.md](ARCHITECTURE.md) - System architecture
- [OPERATIONS.md](OPERATIONS.md) - Operations guide
