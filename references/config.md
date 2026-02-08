# OpenClaw Configuration Reference

## Config File Location

```
~/.openclaw/openclaw.json
```

## Full Config Structure

```json
{
  "meta": {
    "lastTouchedVersion": "2026.2.2-3",
    "lastTouchedAt": "2026-02-08T04:38:19.589Z"
  },

  "auth": {
    "profiles": {
      "<provider>:<profile-id>": {
        "provider": "anthropic|openai|openrouter|...",
        "mode": "api_key|oauth|setup-token"
      }
    }
  },

  "models": {
    "mode": "merge|override",
    "providers": {
      "<provider>": {
        "baseUrl": "https://...",
        "api": "anthropic-messages|openai-completions|...",
        "models": [
          {
            "id": "model-id",
            "name": "Display Name",
            "reasoning": true|false,
            "input": ["text", "image"],
            "cost": {
              "input": 0,
              "output": 0,
              "cacheRead": 0,
              "cacheWrite": 0
            },
            "contextWindow": 200000,
            "maxTokens": 8192
          }
        ]
      }
    }
  },

  "agents": {
    "defaults": {
      "model": {
        "primary": "provider/model-id",
        "fallbacks": ["provider/model-id"]
      },
      "models": {
        "provider/model-id": {
          "alias": "ShortName",
          "enabled": true
        }
      },
      "workspace": "/path/to/workspace",
      "contextPruning": {
        "tools": {
          "allow": [],
          "deny": []
        }
      },
      "compaction": {
        "mode": "safeguard|aggressive|disabled"
      },
      "maxConcurrent": 4,
      "subagents": {
        "maxConcurrent": 8,
        "allowAgents": ["name"] | "all" | "none"
      }
    },
    "list": [
      {
        "id": "agent-id",
        "workspace": "/path/to/agent-workspace",
        "model": {
          "primary": "provider/model-id"
        },
        "identity": {
          "name": "Display Name",
          "emoji": "🤖"
        },
        "tools": {
          "allow": ["group:fs", "read", "write"],
          "deny": ["group:runtime", "exec"]
        },
        "subagents": {
          "allowAgents": ["writer", "coder"]
        }
      }
    ]
  },

  "channels": {
    "<channel>": {
      "accounts": {
        "default": {
          "id": "account-id"
        }
      },
      "capabilities": [],
      "markdown": {
        "tables": "bullets|markdown",
        "codeBlocks": "fenced|indented"
      },
      "dmPolicy": "allowlist|blocklist|all",
      "selfChatMode": true|false,
      "allowFrom": ["+1234567890"],
      "blockFrom": ["+1234567890"],
      "groupPolicy": "allowlist|blocklist|all",
      "mediaMaxMb": 50,
      "blockStreaming": true,
      "actions": {
        "reactions": true,
        "polls": true
      },
      "ackReaction": {
        "emoji": "🐧",
        "direct": true,
        "group": "mentions|none|all"
      },
      "debounceMs": 0,
      "heartbeat": {
        "showAlerts": true,
        "useIndicator": true
      }
    }
  },

  "gateway": {
    "port": 18789,
    "mode": "local|remote",
    "bind": "loopback|lan|tailnet|auto|custom",
    "auth": {
      "mode": "token|password",
      "token": "<YOUR_GATEWAY_TOKEN>",
      "password": "<YOUR_GATEWAY_PASSWORD>"
    },
    "tailscale": {
      "mode": "off|serve|funnel",
      "resetOnExit": false
    }
  },

  "tools": {
    "web": {
      "search": {
        "enabled": true|false,
        "provider": "ddgr|..."
      },
      "fetch": {
        "enabled": true|false,
        "userAgent": "..."
      }
    },
    "exec": {
      "security": "allowlist|denylist|disabled",
      "allowedCommands": ["echo", "ls"]
    },
    "browser": {
      "defaultProfile": "..."
    }
  },

  "messages": {
    "ackReaction": "emoji",
    "ackReactionScope": "all|group-mentions|none"
  },

  "commands": {
    "native": "auto|on|off",
    "nativeSkills": "auto|on|off",
    "restart": true|false
  },

  "session": {
    "dmScope": "per-channel-peer|all"
  },

  "hooks": {
    "enabled": true|false,
    "token": "<YOUR_HOOKS_TOKEN>",
    "internal": {
      "enabled": true|false,
      "entries": {
        "boot-md": { "enabled": true|false },
        "command-logger": { "enabled": true|false },
        "session-memory": { "enabled": true|false }
      }
    }
  },

  "skills": {
    "install": {
      "nodeManager": "npm|pnpm|bun"
    }
  },

  "plugins": {
    "entries": {
      "<plugin-id>": {
        "enabled": true|false
      }
    }
  }
}
```

## Example Configurations

### Basic Setup (Anthropic)

```json
{
  "auth": {
    "profiles": {
      "anthropic:default": {
        "provider": "anthropic",
        "mode": "setup-token"
      }
    }
  },
  "models": {
    "providers": {
      "anthropic": {
        "api": "anthropic-messages",
        "models": [
          {
            "id": "claude-sonnet-4-20250514",
            "name": "Claude Sonnet 4",
            "reasoning": true,
            "contextWindow": 200000
          }
        ]
      }
    }
  },
  "agents": {
    "defaults": {
      "model": {
        "primary": "anthropic/claude-sonnet-4-20250514"
      }
    }
  },
  "gateway": {
    "port": 18789,
    "mode": "local",
    "bind": "loopback",
    "auth": {
      "mode": "token",
      "token": "<GENERATE_WITH: openclaw gateway call config.generateToken>"
    }
  }
}
```

### Multiple Agents

```json
{
  "agents": {
    "list": [
      {
        "id": "main",
        "identity": { "name": "Assistant", "emoji": "🤖" },
        "model": { "primary": "anthropic/claude-sonnet-4-20250514" },
        "subagents": { "allowAgents": ["writer", "coder"] }
      },
      {
        "id": "writer",
        "identity": { "name": "Writer", "emoji": "✍️" },
        "workspace": "~/.openclaw/agents/writer",
        "tools": {
          "allow": ["read", "write", "edit"],
          "deny": ["exec", "bash"]
        }
      },
      {
        "id": "coder",
        "identity": { "name": "Coder", "emoji": "👨‍💻" },
        "workspace": "~/.openclaw/agents/coder",
        "tools": {
          "allow": ["group:fs", "group:runtime", "github"],
          "deny": ["message"]
        }
      }
    ]
  }
}
```

### Channel with Allowlist

```json
{
  "channels": {
    "whatsapp": {
      "dmPolicy": "allowlist",
      "allowFrom": ["+1234567890", "+0987654321"],
      "groupPolicy": "allowlist",
      "ackReaction": {
        "emoji": "✅",
        "direct": true,
        "group": "mentions"
      }
    }
  }
}
```

### Security Settings (Allowlist Mode)

```json
{
  "tools": {
    "exec": {
      "security": "allowlist",
      "allowedCommands": ["echo", "ls", "cat", "head", "tail"]
    }
  }
}
```

### Tailscale Remote Access

```json
{
  "gateway": {
    "port": 18789,
    "mode": "local",
    "bind": "tailnet",
    "auth": {
      "mode": "token"
    },
    "tailscale": {
      "mode": "serve",
      "resetOnExit": true
    }
  }
}
```

### Ollama Local Models

```json
{
  "models": {
    "providers": {
      "ollama": {
        "baseUrl": "http://localhost:11434/v1",
        "api": "openai-completions",
        "models": [
          {
            "id": "llama3.2:3b",
            "name": "Llama 3.2 3B",
            "reasoning": false,
            "input": ["text"],
            "cost": {
              "input": 0,
              "output": 0
            },
            "contextWindow": 8192,
            "maxTokens": 2048
          }
        ]
      }
    }
  }
}
```

### Small Model with Restricted Tools (Security Best Practice)

```json
{
  "agents": {
    "list": [
      {
        "id": "watcher",
        "model": {
          "primary": "ollama/llama3.2:3b"
        },
        "identity": {
          "name": "Watcher",
          "emoji": "👁️"
        },
        "tools": {
          "deny": [
            "web_fetch",
            "browser",
            "web_search"
          ]
        }
      }
    ]
  }
}
```

## Config Paths for `config get/set`

| Path | Description |
|------|-------------|
| `gateway.port` | Gateway port number |
| `gateway.mode` | `local` or `remote` |
| `gateway.bind` | Bind mode |
| `gateway.auth.mode` | Auth mode (`token` or `password`) |
| `agents.defaults.model.primary` | Default model |
| `agents.list` | Array of agent configs |
| `channels.whatsapp.enabled` | WhatsApp enabled |
| `channels.whatsapp.allowFrom` | Allowed phone numbers |
| `models.providers.<provider>.api` | API type |
| `skills.install.nodeManager` | Node package manager |
| `tools.exec.security` | Exec security mode |
| `hooks.enabled` | Hooks enabled |
| `hooks.internal.entries.boot-md.enabled` | Boot hook |
| `hooks.internal.entries.command-logger.enabled` | Command logging |
| `hooks.internal.entries.session-memory.enabled` | Session memory |

## Reset Commands

```bash
# Reset config only (keeps CLI)
openclaw reset --scope config --yes

# Reset config + credentials + sessions
openclaw reset --scope config+creds+sessions --yes

# Full reset (everything)
openclaw reset --scope full --yes
```

## Security Notes

### Never Commit These to Version Control

- `~/.openclaw/openclaw.json` (contains tokens and API keys)
- `~/.openclaw/credentials/` directory
- Any file containing `api_key`, `token`, `client_secret`, `password`

### Recommended `.gitignore` Pattern

```
# OpenClaw
.openclaw/
.openclaw-*/
credentials/
**/openclaw.json
```

### Generate Safe Gateway Token

```bash
# Generate a new gateway token
openclaw gateway call config.generateToken
```

### Rotate Tokens Regularly

```bash
# After generating new token
openclaw config set gateway.auth.token "<NEW_TOKEN>"

# Restart gateway to apply
openclaw gateway restart
```
