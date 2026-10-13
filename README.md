# PLARO for Claude Code

Your project's agreed requirements and what changed, from [PLARO](https://plaro.kr), inside Claude Code.

- **Tools (read-only)** — `get_requirements`, `get_changes`, `get_open_questions`, `get_verification_gaps`, `search_requirements`, and `get_notices` (the change notice).
- **Change notices** — when you send a message, Claude learns what changed in the requirements since the last notice (a few lines, or nothing).
- **Commands** — `plan_changes` (plan the work for what changed), `plan_project` (plan the whole current version), `check_acceptance` (compare acceptance criteria with the code before the PM's check).

## Install and sign in

Your PM connects you in PLARO with your email address (requirements tab → Export → Developer AI connection), and PLARO mails you these steps. In Claude Code:

```
/plugin marketplace add plaro-kr/plaro-ai
/plugin install plaro@plaro-ai
```

Then open `/mcp`, pick `plaro` and sign in. The browser opens PLARO's sign-in page: enter the address your PM connected, the 6-digit code mailed to it, and pick the project. You need no PLARO account, and there is no key to copy: Claude Code keeps the sign-in in your computer's secure storage and renews it by itself. A sign-in lasts 30 days; then the browser asks for a code again.

Until you sign in, Claude Code marks the server as needing authentication, and the message hook reports an error on each message — sign in from `/mcp`. On a computer without a browser, copy the address Claude Code shows; if the redirect fails, paste the full address from the browser's bar into Claude Code.

Add two lines to the repository's instruction file (`CLAUDE.md`, or `AGENTS.md`) so every session checks PLARO before building — the PM's connection guide has them with your project's name.

One sign-in reads one project. To switch projects, use **Clear authentication** on `plaro` in `/mcp` and sign in again.

## What is sent

- To `https://plaro.kr/mcp/v1`: the tool calls Claude makes, with the token from your sign-in.
- On every message, the hook calls `get_notices` through that same signed-in connection. **What you type is never sent.** The hook waits five seconds at most and never blocks your work.
- PLARO sends back only what the PM put into a requirements version or processed. No meeting or chat text, no amounts, no client names or contacts.

PLARO keeps a record of each sign-in step and call (which connection, which tool, the outcome, how long, from which address) for one year — never the content.

## Remove

```
/plugin uninstall plaro@plaro-ai
```

The PM can revoke your connection in PLARO at any time; a connection nobody uses for 90 days stops by itself.

## License and trademarks

The files in this repository are released under the MIT License (`LICENSE`). It covers these files only: using PLARO is governed by its [Terms of Service](https://plaro.kr/terms), and the PLARO name and logo are not licensed.

Claude Code is a product of Anthropic. This plugin is made by PLARO and is not affiliated with, endorsed by or sponsored by Anthropic.

## Layout

- `.claude-plugin/marketplace.json` — this repository as a plugin marketplace (`plaro-ai`).
- `plugins/plaro/.claude-plugin/plugin.json` — the plugin.
- `plugins/plaro/.mcp.json` — the MCP server (OAuth sign-in, no key).
- `plugins/plaro/hooks/hooks.json` — the message hook (`type: "mcp_tool"`, calling `get_notices`).
- `LICENSE` — MIT.

This folder is kept in PLARO's main repository (`integrations/claude-plugin`) and copied to the public repository when it changes.
