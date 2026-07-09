# skills

A portable library of skills for Claude Code (and future agents).

## What is a skill?

A skill is a folder with a `SKILL.md` file. Claude Code loads the YAML
frontmatter at startup and reads the full body only when the skill is triggered.

```
skills/
└── <skill-name>/
    ├── SKILL.md          # required
    ├── scripts/          # helper scripts the skill can run
    ├── templates/        # output templates
    ├── references/       # docs, spec extracts, examples
    └── assets/           # images, data files
```

## Repository layout

```
skills/                   ← this repo
├── skills/               ← skill folders (agent-agnostic source of truth)
│   ├── example-skill/
│   └── create-pr-and-merge/
├── agents/               ← per-agent install notes & quirk docs
│   └── claude-code.md
├── install.sh            ← Unix installer (symlinks into ~/.claude/skills/)
├── install.ps1           ← Windows installer (symlinks into %USERPROFILE%\.claude\skills\)
└── README.md
```

## Installing into Claude Code

**Unix / macOS / Git Bash**
```bash
bash install.sh
```

**Windows (PowerShell, run as Administrator for symlinks)**
```powershell
.\install.ps1
```

Both scripts create symlinks from `~/.claude/skills/<name>` → `skills/<name>` in this
repo, so pulling the repo automatically updates every installed skill.

To install a single skill manually:
```bash
ln -s "$PWD/skills/example-skill" ~/.claude/skills/example-skill   # Unix
```
```powershell
New-Item -ItemType SymbolicLink -Path "$env:USERPROFILE\.claude\skills\example-skill" -Target "$PWD\skills\example-skill"
```

## Adding a new skill

1. `mkdir skills/<your-skill-name>`
2. Create `skills/<your-skill-name>/SKILL.md` with the frontmatter below.
3. Run the installer (or symlink manually).

Minimum `SKILL.md`:
```markdown
---
name: your-skill-name
description: One sentence — what this skill does and when to trigger it.
---

# Instructions

...
```

## Extending to other agents

Add a doc under `agents/<agent-name>.md` describing how that agent discovers
and loads skills, then add any agent-specific install steps to the install
scripts.
