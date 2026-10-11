# PLARO for Claude Code

Your project's agreed requirements and what changed, from [PLARO](https://plaro.kr), inside Claude Code.

- **Tools (read-only)** — `get_requirements`, `get_changes`, `get_open_questions`, `get_verification_gaps`, `search_requirements`.
- **Change notices** — when a session opens and when you send a message, Claude learns what changed in the requirements since your key last heard (a few lines, or nothing).
- **Commands** — `plan_changes` (plan the work for what changed), `plan_project` (plan the whole current version), `check_acceptance` (compare acceptance criteria with the code before the PM's check).

## Install

Your PM makes a connection key in PLARO (requirements tab → Export → Developer AI connection) and sends you a connection guide. In Claude Code:

```
/plugin marketplace add plaro-kr/plaro-ai
/plugin install plaro@plaro-ai
```

Paste the key when it asks. Claude Code keeps it in your computer's secure storage (macOS Keychain), not in a file.

Add two lines to the repository's instruction file (`CLAUDE.md`, or `AGENTS.md`) so every session checks PLARO before building — the connection guide has them with your project's name.

## What is sent

- To `https://plaro.kr/mcp/v1`: the tool calls Claude makes, with your key.
- To `https://plaro.kr/api/dev-ai/v1/changes`: your key only, when a session opens and when you send a message. **What you type is never read or sent.** The hook waits two seconds at most and never blocks your work.
- PLARO sends back only what the PM put into a requirements version or processed. No meeting or chat text, no amounts, no client names or contacts.

PLARO keeps a record of each call (which key, which tool, the outcome, how long) — never the content.

## Remove

```
/plugin uninstall plaro@plaro-ai
```

The PM can revoke your key in PLARO at any time; a key nobody uses for 90 days stops by itself.

## Layout

- `.claude-plugin/marketplace.json` — this repository as a plugin marketplace (`plaro-ai`).
- `plugins/plaro/.claude-plugin/plugin.json` — the plugin, with the key asked at install (`userConfig`, sensitive).
- `plugins/plaro/.mcp.json` — the MCP server, the key in the `Authorization` header.
- `plugins/plaro/hooks/` — the session-start and message hooks (`notice.sh`, POSIX `sh` and `curl`).

This folder is kept in PLARO's main repository (`integrations/claude-plugin`) and copied to the public repository when it changes.
