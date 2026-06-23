# Claude Code — skill integration notes

## Discovery paths

| Scope   | Path                         | Committed? |
|---------|------------------------------|------------|
| Global  | `~/.claude/skills/<name>/`   | No         |
| Project | `.claude/skills/<name>/`     | Yes        |

Claude Code scans both locations at startup. The folder name is the slash-command
trigger (e.g. `~/.claude/skills/pdf/` → `/pdf`).

## SKILL.md frontmatter keys

| Key           | Required | Notes                                                  |
|---------------|----------|--------------------------------------------------------|
| `name`        | Yes      | Must match the folder name                             |
| `description` | Yes      | Shown in `/help`; also used for auto-trigger matching  |

Only the frontmatter block is loaded at startup. The full body is read on demand,
so keep expensive references in `references/` rather than inline.

## Auto-triggering

Claude Code matches the user's intent against skill `description` fields. A good
description starts with the trigger condition:
> "Use when the user asks to generate a PDF report …"

## Scripting

Scripts in `scripts/` are not executed automatically — the skill body must
instruct Claude Code to run them via the Bash tool. Use shebangs and keep scripts
idempotent.

## Updating skills

Because the installer creates symlinks, a `git pull` in this repo is enough to
update all installed skills with no re-install step.
