---
name: openclaw
description: |
  OpenClaw CLI management for personal AI assistant. Use when queries involve:

  Gateway: "start openclaw", "stop gateway", "gateway status", "restart openclaw",
    "gateway service", "run gateway", "gateway logs", "gateway port", "bind loopback"

  Channels: "whatsapp", "add telegram", "discord setup", "slack", "signal",
    "imessage", "channel status", "channel login", "channel logs", "pairing",
    "whatsapp qr", "linked phone"

  Config: "openclaw config", "config get", "config set", "configure openclaw",
    "openclaw.json", "model config", "agent config", "workspace", "auth"

  Security: "openclaw security", "security audit", "audit --fix", "audit --deep",
    "permissions", "exec approvals"

  Skills: "openclaw skills", "skill list", "skill info", "install skill",
    "skill check", "eligible skills"

  Models: "openclaw models", "model auth", "anthropic", "openai", "ollama",
    "set model", "model status", "scan models", "model aliases", "fallbacks"

  Agents: "openclaw agents", "agent list", "add agent", "delete agent",
    "agent main", "custom agent", "subagents"

  Messaging: "openclaw message", "send message", "message poll", "message thread"

  Diagnostics: "openclaw doctor", "health check", "status", "status --deep",
    "logs", "troubleshoot", "debug", "verbose"

  macOS: "homebrew openclaw", "launchd", "menu bar", "node runtime"

  Full CLI: "openclaw help", "openclaw --help", "all commands", "cli reference"
---

# OpenClaw CLI Skill

## Quick Reference

| Task | Command |
|------|---------|
| Start gateway | `openclaw gateway run` |
| Stop gateway | `openclaw gateway stop` |
| Gateway status | `openclaw gateway status` |
| Service restart | `openclaw gateway restart` |
| Add channel | `openclaw channels add --channel telegram --token $TOKEN` |
| List channels | `openclaw channels list` |
| Channel status | `openclaw channels status --probe` |
| WhatsApp login | `openclaw channels login --channel whatsapp` |
| Config get | `openclaw config get agents.defaults.model.primary` |
| Config set | `openclaw config set channels.whatsapp.enabled true` |
| Security audit | `openclaw security audit --deep --fix` |
| Skills list | `openclaw skills list` |
| Doctor check | `openclaw doctor --yes` |
| View logs | `openclaw logs --follow` |
| Model status | `openclaw models status --probe` |
| Agents list | `openclaw agents list` |
| Send message | `openclaw message send --target <PHONE_NUMBER> --message "Hello"` |
| Cron list | `openclaw cron list` |
| Health check | `openclaw health --verbose` |

## Your OpenClaw Installation

After installing OpenClaw, your config lives at `~/.openclaw/openclaw.json`.

### Check Your Setup

```bash
# Version
openclaw --version

# Gateway mode (local or remote)
openclaw config get gateway.mode

# Gateway port
openclaw config get gateway.port

# Auth mode
openclaw config get gateway.auth.mode

# Your configured agents
openclaw agents list

# Your default model
openclaw config get agents.defaults.model.primary

# Your installed skills
openclaw skills list

# Your configured channels
openclaw channels list

# Your cron jobs
openclaw cron list
```

## macOS Notes

### Installation

```bash
# Via npm (recommended)
npm install -g openclaw@latest

# Or pnpm
pnpm add -g openclaw@latest
```

### Launchd Service

```bash
# Install daemon (runs gateway as user service)
openclaw onboard --install-daemon

# Service management
openclaw gateway status          # probes RPC
openclaw gateway install         # installs launchd service
openclaw gateway uninstall       # removes service
openclaw gateway start/stop/restart

# Check service status
launchctl list | grep openclaw
```

### Runtime

- **Node**: Recommended runtime (`--daemon-runtime node`)
- **Bun**: NOT recommended (WhatsApp/Telegram bugs)
- **Browser**: Chrome/Brave/Edge/Chromium for browser tool

## Common Workflows

### 1. Gateway Management

```bash
# Start gateway manually
openclaw gateway run --port 18789 --bind loopback

# Start with verbose logging
openclaw gateway run --verbose

# Check if gateway is responding
openclaw health --verbose
openclaw status --deep

# Restart gateway (after config changes)
openclaw gateway restart

# View real-time logs
openclaw logs --follow
openclaw logs --limit 200 --plain
```

### 2. Channel Management

```bash
# List all configured channels
openclaw channels list

# Check channel status
openclaw channels status
openclaw channels status --probe

# Add a new channel
openclaw channels add --channel telegram --account alerts --name "Alerts Bot" --token $TELEGRAM_BOT_TOKEN
openclaw channels add --channel discord --account work --token $DISCORD_BOT_TOKEN

# WhatsApp login (shows QR code)
openclaw channels login --channel whatsapp

# View channel logs
openclaw channels logs --channel whatsapp --lines 200

# Pairing requests
openclaw pairing list whatsapp
openclaw pairing approve whatsapp <code>
```

### 3. Configuration

```bash
# Get a config value
openclaw config get gateway.port
openclaw config get agents.defaults.model.primary
openclaw config get channels.whatsapp.allowFrom

# Set a config value
openclaw config set agents.defaults.model.primary "anthropic/claude-sonnet-4-20250514"
openclaw config set channels.whatsapp.enabled true

# Unset a config value
openclaw config unset channels.whatsapp.customOption

# Run configure wizard
openclaw configure
openclaw configure --section models

# View full config
cat ~/.openclaw/openclaw.json
```

### 4. Agent Management

```bash
# List agents
openclaw agents list

# Get agent details
openclaw agents list --bindings

# Add new agent
openclaw agents add myagent --workspace ~/.openclaw/agents/myagent/workspace --model anthropic/claude-sonnet-4-20250514
openclaw agents add --non-interactive --workspace /path/to/workspace --bind whatsapp:default

# Delete agent
openclaw agents delete myagent --force

# Run agent manually
openclaw agent --message "Summarize recent work"
openclaw agent --message "Check cron job status" --session-id <id>

# With thinking mode (if supported)
openclaw agent --message "Analyze this" --thinking high
```

### 5. Model Configuration

```bash
# List available models
openclaw models list
openclaw models list --provider anthropic

# Check model status
openclaw models status
openclaw models status --probe

# Setup auth (preferred: setup-token)
openclaw models auth setup-token --provider anthropic
openclaw models auth paste-token --provider anthropic --profile-id anthropic:manual --expires-in 365d

# Scan for new models
openclaw models scan --provider ollama
openclaw models scan --yes --set-default

# Model aliases
openclaw models aliases list
openclaw models aliases add "sonnet" "anthropic/claude-sonnet-4-20250514"
openclaw models aliases remove "sonnet"

# Fallback models
openclaw models fallbacks list
openclaw models fallbacks add "ollama/llama3.2:3b"
```

### 6. Skills Management

```bash
# List installed skills
openclaw skills list
openclaw skills list --eligible

# Get skill info
openclaw skills info <skill-name>

# Check skill requirements
openclaw skills check
openclaw skills check --eligible -v

# Search for skills (via ClawHub)
npx clawhub search "github"
```

### 7. Cron Jobs

```bash
# List cron jobs
openclaw cron list
openclaw cron list --all

# View job details
openclaw cron list | grep my-job

# Get job runs
openclaw cron runs --id <job-id> --limit 5

# Manually trigger job
openclaw cron run <job-id>

# Add new job (requires gateway RPC)
openclaw cron add --name "my-task" --every 1h --system-event "Task reminder"
```

### 8. Security

```bash
# Basic audit
openclaw security audit

# Deep audit (probes gateway)
openclaw security audit --deep

# Auto-fix issues
openclaw security audit --deep --fix

# View exec approvals
openclaw config get tools.exec.security
cat ~/.openclaw/exec-approvals.json
```

### 9. Messaging

```bash
# Send message
openclaw message send --channel whatsapp --target <PHONE_NUMBER> --message "Hello!"
openclaw message send --target <ANOTHER_NUMBER> --message "Test message"

# Create poll
openclaw message poll --channel whatsapp --target <PHONE_NUMBER> \
  --poll-question "Lunch?" \
  --poll-option "Pizza" \
  --poll-option "Sushi"

# Message thread operations
openclaw message thread create --channel whatsapp --target <PHONE_NUMBER> --message "New thread"
openclaw message thread reply --thread-id <id> --message "Reply"

# Search messages
openclaw message search --channel whatsapp --query "important"
```

### 10. Diagnostics

```bash
# Doctor check (auto-fix common issues)
openclaw doctor
openclaw doctor --yes
openclaw doctor --deep

# Full status
openclaw status
openclaw status --deep
openclaw status --all
openclaw status --usage

# Health check
openclaw health
openclaw health --verbose

# View logs
openclaw logs
openclaw logs --follow
openclaw logs --json --limit 100

# Session management
openclaw sessions
openclaw sessions --active 60
```

## Troubleshooting Guide

### Gateway Won't Start

```bash
# Check port availability
lsof -i :18789

# Kill existing process
kill $(lsof -t -i :18789)

# Try with --force
openclaw gateway run --force

# Check logs
openclaw logs --limit 50
cat ~/.openclaw/logs/gateway.log
```

### Channel Not Responding

```bash
# Check channel status
openclaw channels status --probe

# View channel logs
openclaw channels logs --channel whatsapp --lines 200

# Re-login to channel
openclaw channels logout --channel whatsapp
openclaw channels login --channel whatsapp

# Run doctor
openclaw doctor
```

### Model Auth Issues

```bash
# Check model status
openclaw models status --probe

# Re-setup auth
openclaw models auth setup-token --provider anthropic

# Check config
openclaw config get models.providers.anthropic
```

### Config Issues

```bash
# Validate config
openclaw doctor --non-interactive

# View config backup
cat ~/.openclaw/openclaw.json.bak

# Reset config (keeps CLI)
openclaw reset --scope config --yes

# Full reset (everything)
openclaw reset --scope full --yes
```

### General Debugging

```bash
# Verbose output
openclaw status --verbose --debug

# JSON output for parsing
openclaw status --json
openclaw health --json

# Check all services
openclaw status --deep

# System scan
openclaw doctor --deep
```

## File Locations

| Path | Purpose |
|------|---------|
| `~/.openclaw/openclaw.json` | Main config |
| `~/.openclaw/credentials/` | Auth credentials |
| `~/.openclaw/agents/<id>/` | Agent workspaces + sessions |
| `~/.openclaw/skills/` | Installed skills |
| `~/.openclaw/logs/` | Gateway logs |
| `~/.openclaw/cron/jobs.json` | Cron job definitions |
| `~/.openclaw/browser/` | Browser profiles |
| `~/.openclaw/media/` | Media cache |
| `~/.openclaw/shared/` | Shared data between agents |
| `~/.openclaw/workspace/` | Default workspace |

## Global Flags

| Flag | Description |
|------|-------------|
| `--dev` | Dev mode: `~/.openclaw-dev`, shifted ports |
| `--profile <name>` | Profile mode: `~/.openclaw-<name>` |
| `--no-color` | Disable ANSI colors |
| `--json` | JSON output (when supported) |
| `-V`, `--version` | Print version |
| `-h`, `--help` | Show help |

## For More Information

- Full CLI reference: https://docs.openclaw.ai/cli
- Documentation: https://docs.openclaw.ai/
- GitHub: https://github.com/openclaw/openclaw
- Skills (ClawHub): npx clawhub
