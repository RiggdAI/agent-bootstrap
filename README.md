# agent-bootstrap

> Configure Hermes agent profiles with skills in one command.

## Quick Start

```bash
# Install default profile (ai-engineer)
curl -fsSL https://raw.githubusercontent.com/RiggdAI/agent-bootstrap/main/install.sh | bash

# Or specify a profile
curl -fsSL https://raw.githubusercontent.com/RiggdAI/agent-bootstrap/main/install.sh | bash -s -- --profile=cto
```

## Requirements

- **Hermes agent** must be installed first
- Git
- Python 3.8+

## Available Profiles

| Profile | Description |
|---------|-------------|
| `ai-engineer` | Software engineer with code review, testing, deployment |
| `cto` | Technical leadership with architecture and team workflow |
| `research-agent` | Research and analysis agent |

## What it does

1. Detects Hermes installation
2. Installs skill plugins (gstack, etc.)
3. Configures profile with SOUL.md and skills
4. Links skills to `~/profiles/{profile}/skills/`

## Manual Installation

```bash
git clone https://github.com/RiggdAI/agent-bootstrap.git
cd agent-bootstrap
./install.sh --profile=ai-engineer
```

## Structure

```
agent-bootstrap/
├── install.sh          # Entry point
├── lib/
│   ├── detect.sh       # Hermes detection
│   ├── skills.sh       # Install skills
│   └── configure.sh    # Configure profile
├── profiles/
│   └── free/           # Free tier profiles
│       └── ai-engineer/
│           ├── SOUL.md
│           ├── profile.yaml
│           └── skills.json
└── plugins/
    └── registry.json   # Available plugins
```

## For Riggd Clients

Pro tier features (requires license):
- Custom profiles
- Sync from gbrain-data
- Riggd private skills
- Priority support

Contact hello@riggd.ai for Pro access.

---

*By [Riggd AI](https://riggd.ai)*
