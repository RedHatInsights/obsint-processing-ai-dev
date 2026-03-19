# Dev Bot

**Status: Proof of Concept**

An autonomous developer bot that picks Jira tickets from the RHCLOUD board and implements them using Claude CLI. It searches for tickets with specific labels, clones the target repo, implements the change, pushes a branch, opens a PR, and reports back on Jira.

## How it works

1. Polls Jira for unassigned tickets with `platform-experience-services` + `hcc-ai-framework` labels
2. Matches the ticket's `repo:<name>` label to a repo in `project-repos.json`
3. Clones/checks out the repo, creates a `bot/<TICKET-KEY>` branch
4. Loads the persona (e.g. `frontend`) for repo-specific guidelines and MCP tools
5. Runs Claude CLI to implement the ticket
6. Pushes the branch, opens a PR via `gh`, comments on the Jira ticket with the PR link

## Structure

```
dev-bot/
  run.sh                 # Main polling loop — launches Claude CLI
  init.sh                # Clones all repos, installs LSP dependencies
  config.json            # Jira board, model, polling interval
  project-repos.json     # repo label -> git URL + persona mapping
  CLAUDE.md              # Agent instructions (full workflow)
  prompts/
    default.md           # Default coding guidelines
  personas/
    frontend/
      prompt.md          # React/TS/PatternFly guidelines
      mcp.json           # PatternFly MCP server config
    backend/
      prompt.md          # Backend guidelines
```

## Prerequisites

- [Claude CLI](https://docs.anthropic.com/en/docs/claude-code) installed and authenticated
- `gh` CLI authenticated with GitHub
- SSH access to target repos
- Jira MCP server configured globally (`mcp-atlassian`)
- Node.js + npm (for TypeScript LSP and frontend repos)
- `jq`

## Setup

```bash
# Clone this repo
git clone git@github.com:<org>/dev-bot.git
cd dev-bot

# Clone all target repos and install LSP deps
./init.sh

# Run the bot (polls every 5 minutes)
./run.sh
```

## Adding a new repo

1. Add an entry to `project-repos.json`:
   ```json
   "my-repo": {
     "url": "git@github.com:RedHatInsights/my-repo.git",
     "persona": "frontend"
   }
   ```
2. Add a `repo:my-repo` label to the Jira ticket
3. Run `./init.sh` to clone it

## Creating tickets for the bot

Tickets must have these labels:
- `platform-experience-services`
- `hcc-ai-framework`
- `repo:<repo-name>` (must match a key in `project-repos.json`)

The bot picks the highest priority unassigned ticket first.

## Next steps

- **Containerize**: Create a container image with all dependencies (Claude CLI, gh, Node.js, LSP servers, jq) pre-installed and verify the full workflow runs inside it
- **Claude service account**: Set up a dedicated Claude API account for the bot instead of using personal credentials
- **Deployment**: Deploy the container to a persistent environment (OpenShift, Kubernetes, etc.) with cron-based scheduling
- **PR check monitoring**: Before picking new tickets, check existing bot PRs for failing CI checks and prioritize fixing them
- **Expand personas**: Create specialized instruction sets for different task types (CVE remediation, dependency updates, test migration, etc.) beyond the current frontend/backend split
