# close-ceremony

A `/close` [Claude Code](https://claude.com/claude-code) slash command for
ending a work session cleanly: capture what changed, update the affected
docs, and commit + push — instead of just walking away from an uncommitted
session.

## What it does

`/close` picks a level based on what happened in the session:

| Situation | Level |
|---|---|
| A decision or rule changed | Full Ceremony |
| Only work output, no decisions/rules changed | Lightweight Log |
| Just questions, no output | Close with no record |

**Full Ceremony** walks through confirming the session's decisions
(Doctrine / Governance / Harnessing / Amendment), updating the affected
files under `memory/` and `wiki/`, filling in a
`sessions/YYYY-MM-DD-topic/YYYY-MM-DD-topic.md` ceremony doc, then commits
and pushes.

**Lightweight Log** just fills in the session doc with a short summary and
commits + pushes.

It runs against whatever directory Claude Code is currently working in —
no path is hardcoded, so it works the same way in any project.

## Requirements

- [Claude Code](https://claude.com/claude-code)
- A project that follows the `sessions/` / `memory/` / `wiki/` /
  `CLAUDE.md` convention (see `commands/close.md` for the exact paths it
  touches)

## Install

```
./install.sh
```

Copies `commands/close.md` to `~/.claude/commands/close.md`. Once
installed, `/close` is available in every Claude Code project on this
machine.

## Uninstall

```
./uninstall.sh
```

## Customize

Edit `~/.claude/commands/close.md` directly (or edit this repo's copy and
re-run `install.sh`) to change the ceremony steps or the paths it commits.
