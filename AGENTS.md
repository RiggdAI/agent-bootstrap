# Agents working with agent-bootstrap

This is your install + operating protocol. agent-bootstrap configures Hermes agent profiles with curated skills.

## What it does

Riggd's agent-bootstrap installs curated skill sets into existing Hermes agent profiles. It detects your profiles, recommends skills based on profile name, and lets you select which to install.

## Install (2 min)

**Prerequisites:** Hermes must already be installed. If Hermes is not found, the script will exit with installation instructions.

```bash
# Quick install
curl -fsSL https://get.riggd.ai | bash

# Or clone and run
git clone https://github.com/RiggdAI/agent-bootstrap.git
cd agent-bootstrap
./install.sh
```

## Flow

```
1. Detect Hermes installation
2. Detect existing profiles in ~/profiles/
3. User selects profile (or creates new)
4. Recommend skills based on profile name
5. User selects which skills to install
6. Skills are appended to profile (never overwrite)
```

## Profile templates

| Template | Recommended Skills |
|----------|-------------------|
| ai-engineer | office-hours, plan-eng-review, review, qa, ship, investigate, health |
| chief-technology-officer | + plan-ceo-review, retro, cso |
| research-agent | office-hours, investigate, learn, browse, scrape |
| instagram-agent | office-hours, browse, scrape, skillify, design-review, qa |

## Available skills

22 curated gstack skills available for installation:

| Skill | Purpose |
|-------|---------|
| office-hours | YC Office Hours — reframe before coding |
| plan-eng-review | Eng manager-mode plan review |
| plan-ceo-review | CEO/founder-mode plan review |
| review | Pre-landing PR review |
| qa | Systematic QA testing |
| ship | Ship workflow with tests + review |
| investigate | Systematic debugging |
| health | Code quality dashboard |
| cso | Security audit mode |
| retro | Weekly engineering retrospective |
| learn | Manage project learnings |
| browse | Headless browser for QA |
| scrape | Pull data from web pages |
| skillify | Codify scrape flows as skills |
| design-review | Visual QA |
| context-save | Save working context |
| context-restore | Restore saved context |
| careful | Safety guardrails |
| freeze | Restrict file edits |
| guard | Full safety mode |
| canary | Post-deploy monitoring |
| benchmark | Performance regression detection |

## Directory structure

```
agent-bootstrap/
├── install.sh           # Main entry point
├── lib/
│   ├── detect.sh        # Hermes + profile detection
│   ├── skills.sh        # Skill selection + installation
│   └── configure.sh     # Profile creation + linking
├── profiles/
│   └── free/            # Free tier templates
│       └── ai-engineer/ # Example template
├── plugins/
│   └── registry.json    # Plugin registry
├── AGENTS.md            # This file
├── llms.txt             # Documentation index
└── README.md            # Project overview
```

## Key functions

### lib/detect.sh

- `detect_hermes()` — Check if Hermes is installed
- `detect_profiles()` — List profiles in ~/profiles/
- `get_profile_skills(profile)` — List skills in a profile
- `count_profile_skills(profile)` — Count skills

### lib/skills.sh

- `install_gstack()` — Install gstack plugin to profile
- `get_recommended_skills(profile)` — Get recommended skills by template
- `select_skills(profile, recommended)` — Interactive skill selection
- `install_skills(profile, skills)` — Install selected skills

### lib/configure.sh

- `create_profile(name)` — Create new profile from template
- `link_skill(profile, skill)` — Symlink skill to profile

## Tiers

| Tier | Features |
|------|----------|
| Free | Basic profiles + community skills |
| Pro | Riggd custom skills + support + gbrain-data sync |

## Read order

1. `AGENTS.md` (this file) — Install + operating protocol
2. `llms.txt` — Documentation index
3. `README.md` — Project overview
4. `lib/*.sh` — Implementation details

## After installation

```bash
# Start your agent
hermes chat

# Verify skills are loaded
# Your agent will show available skills in the system prompt
```

## Troubleshooting

| Problem | Solution |
|---------|----------|
| Hermes not found | Install: `pip install hermes-agent` |
| No profiles found | Script will prompt to create one |
| Skills not loading | Check ~/profiles/<name>/skills/ directory |
| Permission denied | Run with appropriate permissions |

## License

MIT. Built by Riggd for Hermes agent users.
