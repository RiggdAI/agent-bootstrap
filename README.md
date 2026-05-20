# agent-bootstrap

> Configure Hermes agent profiles with curated skills. Detects profiles → recommends → installs.

Built by [Riggd](https://riggd.ai) for Hermes agent users. Installs 22 curated gstack skills based on your profile type.

## Install

**Recommended: download first, verify, then run**

```bash
# 1. Download
curl -fsSL https://raw.githubusercontent.com/RiggdAI/agent-bootstrap/main/install.sh -o install.sh

# 2. Verify (optional but recommended)
cat install.sh

# 3. Run
chmod +x install.sh
./install.sh
```

**Alternative: clone the repo**

```bash
git clone https://github.com/RiggdAI/agent-bootstrap.git
cd agent-bootstrap
./install.sh
```

**Prerequisites:** [Hermes](https://hermes-agent.dev) must be installed first.

## Flow

```
1. Detect Hermes ✓
2. Detect existing profiles
   ├── ai-gary-tan (15 skills)
   ├── chief-technology-officer-2 (8 skills)
   └── research-agent (3 skills)
3. User selects profile
4. Recommend skills based on profile name
5. User selects which to install
   ├── 1. Install recommended
   ├── 2. Select manually
   └── 3. Install all
6. Skills are appended (never overwrite)
```

## Available Skills

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

## Profile Templates

| Template | Recommended Skills |
|----------|-------------------|
| ai-engineer | office-hours, plan-eng-review, review, qa, ship, investigate, health |
| chief-technology-officer | + plan-ceo-review, retro, cso |
| research-agent | office-hours, investigate, learn, browse, scrape |
| competitive-intel-agent | office-hours, investigate, browse, scrape, learn, review, qa |
| instagram-agent | office-hours, browse, scrape, skillify, design-review, qa |
| product-manager | office-hours, plan-eng-review, review, qa, ship, design-review |
| founder | office-hours, plan-ceo-review, ship, review, qa, investigate, health |

## Manual Install

```bash
git clone https://github.com/RiggdAI/agent-bootstrap.git
cd agent-bootstrap

# Interactive (select skills manually)
./install.sh --profile=ai-engineer

# Non-interactive (auto-install recommended)
./install.sh --profile=competitive-intel-agent --auto
```

## Directory Structure

```
agent-bootstrap/
├── install.sh           # Main entry point
├── lib/
│   ├── detect.sh        # Hermes + profile detection
│   ├── skills.sh        # Skill selection + installation
│   └── configure.sh     # Profile creation + linking
├── profiles/
│   └── free/            # Free tier templates
│       └── ai-engineer/
│           ├── SOUL.md
│           ├── profile.yaml
│           └── skills.json
├── plugins/
│   └── registry.json    # Plugin registry
├── AGENTS.md            # Agent entry point
└── llms.txt             # Documentation index
```

## Tiers

| Tier | Features |
|------|----------|
| Free | Basic profiles + community skills |
| Pro | Riggd custom skills + support + gbrain-data sync |

**Pro tier:** Contact hello@riggd.ai

## Documentation

- [AGENTS.md](./AGENTS.md) — Agent entry point (start here for AI agents)
- [llms.txt](./llms.txt) — Documentation index

---

*By [Riggd AI](https://riggd.ai)*
