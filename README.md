# OpenClaw Config Skill

A public, ready-to-fork OpenClaw skill template for managing the OpenClaw CLI tool.

## What's Inside

| File | Purpose |
|------|---------|
| `SKILL.md` | Main skill documentation with quick reference and common workflows |
| `references/commands.md` | Complete CLI command reference from docs.openclaw.ai |
| `references/config.md` | Annotated config structure with examples |
| `references/update-skill.sh` | Auto-update script for syncing with canonical docs |

## Features

- **Discovery-optimized** - Rich keyword triggers for Claude skill matching
- **macOS-focused** - Launchd service, Node runtime, Homebrew notes
- **Sanitized** - No real credentials, tokens, or phone numbers
- **Template-ready** - Replace placeholders with your values
- **Auto-update** - Bi-weekly sync with official docs

## For Users

Copy this skill to your OpenClaw skills directory:

```bash
cp -r public-openclaw-config-skill ~/.openclaw/skills/openclaw
```

Or use the update script:

```bash
~/.openclaw/skills/openclaw/references/update-skill.sh
```

## Cron Job (Optional)

Add bi-weekly auto-update:

```bash
openclaw cron add --name "openclaw-skill-update" \
  --cron "0 3 * * 0" \
  --system-event "OpenClaw Skill Update"
```

## Customizing for Your Setup

All placeholders below are the defaults — search-and-replace them with your own values before deploying:

| Field | Default placeholder |
|-------|---------------------|
| Phone numbers | `+1234567890` |
| Gateway token | `<YOUR_GATEWAY_TOKEN>` |
| API keys | `$TOKEN`, `$API_KEY` |
| User paths | `~/`, `/path/to/` |
| Agent names | `main`, `writer`, `coder` (generic) |

## Updating from Canonical Sources

The `update-skill.sh` script fetches:

1. Latest CLI docs from `https://docs.openclaw.ai/cli`
2. Documentation index from `https://docs.openclaw.ai/llms.txt`
3. Local config state (optional)

## License

Same as OpenClaw (MIT/Apache).
