# OpenClaw Command Reference

## Command Tree

```
openclaw [--dev] [--profile <name>] <command>

  setup                    Initialize config + workspace
  onboard                  Interactive gateway, workspace, skills wizard
  configure                Interactive configuration wizard
  config                   Non-interactive config helpers
    get <path>             Print config value
    set <path> <value>     Set config value (JSON5 or string)
    unset <path>           Remove config value

  doctor                   Health checks + quick fixes
  status                   Show session health + recent recipients
  health                   Fetch gateway health
  sessions                 List stored conversation sessions

  gateway                  Run the WebSocket Gateway
    run                    Run gateway (blocking)
    status                 Probe gateway RPC
    health                 Gateway health
    probe                  Probe endpoint
    discover               Discover gateways
    install                Install launchd/systemd service
    uninstall              Remove service
    start                  Start service
    stop                   Stop service
    restart                Restart service

  logs                     Tail gateway logs

  channels                 Manage chat channels
    list                   Show configured channels
    status                 Check gateway reachability + channel health
    logs                   Show channel logs
    add                    Add channel (wizard or flags)
    remove                 Disable/remove channel
    login                  Interactive channel login (WhatsApp Web)
    logout                 Log out of channel

  skills                   List + inspect skills
    list                   List skills
    info <name>            Show skill details
    check                  Readiness summary

  plugins                  Manage extensions
    list                   Discover plugins
    info <id>              Plugin details
    install <path|tgz|npm> Install plugin
    enable <id>            Enable plugin
    disable <id>           Disable plugin
    doctor                 Report plugin load errors

  memory                   Vector search over memory files
    status                 Index stats
    index                  Reindex memory files
    search "<query>"       Semantic search

  message                  Unified outbound messaging
    send                   Send message
    poll                   Create poll
    react                  Add reaction
    reply                  Reply to message
    thread <create|list|reply>
    channel <info|list>
    member info
    event <list|create>

  agent                    Run single agent turn
    --message <text>       (required)

  agents                   Manage isolated agents
    list                   List agents
    add [name]             Add new agent
    delete <id>            Delete agent

  acp                      ACP bridge (IDE to Gateway)

  models                   Model management
    list                   Available models
    status                 Model status + auth
    set <model>            Set default model
    set-image <model>      Set default image model
    aliases <list|add|remove>
    fallbacks <list|add|remove|clear>
    image-fallbacks <list|add|remove|clear>
    scan                   Scan for models
    auth <add|setup-token|paste-token>
    auth order <get|set|clear>

  cron                     Scheduled jobs
    status                 Cron status
    list                   List jobs
    add                    Create job
    edit <id>              Edit job
    rm <id>                Remove job
    enable <id>            Enable job
    disable <id>           Disable job
    runs --id <id>         Job run history
    run <id>               Trigger job manually

  nodes                    Paired node management
    status                 Node status
    describe --node <id>  Node details
    list                   List nodes
    pending                Pending requests
    approve <requestId>   Approve node
    invoke --node <id> --command <cmd>
    run --node <id>        Run command on node
    notify --node <id>     Send notification

  node                      Node host management
    run --host <gateway>    Run headless node host
    status                  Node status
    install                Install node
    uninstall              Remove node
    start                  Start node
    stop                   Stop node
    restart                Restart node

  browser                  Browser control CLI
    status                 Browser status
    start                  Start browser
    stop                   Stop browser
    reset-profile          Reset profile
    tabs                   List tabs
    open <url>             Navigate
    screenshot            Take screenshot
    snapshot              Get page structure
    click <ref>           Click element
    type <ref> <text>     Type text
    press <key>           Press key
    wait                   Wait for condition
    evaluate --fn <code>  Execute JS
    pdf                    Save as PDF

  system                   System utilities
    event                  Enqueue system event
    heartbeat <last|enable|disable>
    presence               List presence entries

  dns setup                DNS discovery setup (macOS: --apply)

  webhooks gmail           Gmail Pub/Sub
    setup                  Setup webhook
    run                    Run webhook runner

  pairing                  Approve pairing requests
    list <channel>         List requests
    approve <channel> <code> Approve

  docs [query]             Search docs

  tui                      Terminal UI

  security                 Security management
    audit                  Audit config + state
    audit --deep           Live gateway probe
    audit --fix            Auto-fix issues

  reset                    Reset local state
  uninstall                Uninstall gateway + data
  update                   Update openclaw
```

## Global Flags

```
--dev                    Dev mode (~/.openclaw-dev, shifted ports)
--profile <name>         Profile mode (~/.openclaw-<name>)
--no-color               Disable ANSI colors
--json                   JSON output (when supported)
--plain                  Plain text output (no styling)
-V, --version, -v        Print version
-h, --help               Show help
--update                 Update (source installs only)
```

## Output Styling

- ANSI colors only render in TTY sessions
- OSC-8 hyperlinks render as clickable links in supported terminals
- `--json` and `--plain` disable styling
- Progress indicators show for long-running commands

## Color Palette

```
accent       #FF5A2D   Headings, labels, primary highlights
accentBright #FF7A3D   Command names, emphasis
accentDim    #D14A22   Secondary highlight
info         #FF8A5B   Informational values
success      #2FBF71   Success states
warn         #FFB020   Warnings, fallbacks
error        #E23D2D   Errors, failures
muted        #8B7F7F   De-emphasis, metadata
```

## Channel Reference

```
whatsapp     WhatsApp Web
telegram     Telegram Bot
discord      Discord Bot
googlechat   Google Chat
slack        Slack Bot
mattermost   Mattermost (plugin)
signal       Signal Bot
imessage     iMessage (plugin)
msteams      Microsoft Teams
```

## Auth Providers

```
anthropic          Anthropic API (Claude)
openai             OpenAI API
openrouter         OpenRouter
ai-gateway         AI Gateway
moonshot           Moonshot (Kimi)
kimi-code          Kimi Code
gemini             Gemini
zai                ZAI
minimax            MiniMax
opencode-zen       OpenCode Zen
```

## Model Scanning

```bash
# Scan all providers
openclaw models scan

# Scan specific provider
openclaw models scan --provider ollama
openclaw models scan --provider minimax

# Auto-set defaults
openclaw models scan --yes --set-default

# Probe live endpoints
openclaw models scan --probe
```

## Browser Profiles

```bash
# Manage profiles
openclaw browser profiles
openclaw browser create-profile --name work --color #FF5A2D
openclaw browser delete-profile --name work

# Use profile
openclaw browser --browser-profile work status
```

## Gateway Service Options

```bash
# Port
--port <port>

# Bind mode
--bind loopback    Local only (default)
--bind lan         Local network
--bind tailnet     Tailscale
--bind auto        Auto-detect
--bind custom      Custom address

# Auth
--auth token|password
--token <token>
--password <password>

# Tailscale
--tailscale off|serve|funnel
--tailscale-reset-on-exit

# Options
--allow-unconfigured
--force           Kill existing on port
--verbose
--claude-cli-logs
--ws-log auto|full|compact
--raw-stream
```

## Cron Job Schedule Formats

```bash
# Interval (milliseconds)
--every 3600000          # 1 hour
--every 1800000          # 30 minutes
--every 600000           # 10 minutes

# Cron expression
--cron "0 9 * * *"       # 9am daily
--cron "0 9 1 * *"       # 9am 1st of month
--cron "*/15 * * * *"    # Every 15 minutes
--cron "0 0 * * 0"       # Midnight Sunday

# Timezone
--tz America/New_York
--tz Asia/Singapore
```

## Common Patterns

### Non-interactive Setup

```bash
# Onboard with all options
openclaw onboard --non-interactive \
  --mode local \
  --auth-choice setup-token \
  --anthropic-api-key $KEY \
  --gateway-port 18789 \
  --install-daemon

# Add channel non-interactively
openclaw channels add --channel telegram --token $TOKEN --non-interactive

# Doctor with auto-fix
openclaw doctor --yes
```

### JSON Output Parsing

```bash
# Get specific config value
openclaw config get gateway.port --json
# → {"value":"18789"}

# Status as JSON
openclaw status --json | jq '.gateway'

# Models list
openclaw models list --json | jq '.providers[].models[].id'
```

### Remote Gateway

```bash
# Connect to remote gateway
openclaw --url https://gateway.example.com:18789 \
  --token <token> \
  status

# Override config credentials
openclaw --url <url> --token <token> health

# Multiple profiles
openclaw --profile work status
openclaw --profile personal channels list
```

### Development Mode

```bash
# Dev mode (separate state)
openclaw --dev gateway run --port 18790

# Different state directory
openclaw --profile testing gateway run --port 18791
```
