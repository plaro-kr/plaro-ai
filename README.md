# PLARO for Claude Code

Your project's agreed requirements and what changed, from [PLARO](https://plaro.kr), inside Claude Code.

- **Tools to read** — `get_requirements`, `get_changes`, `get_open_questions`, `get_verification_gaps`, `search_requirements`, and `get_notices` (the change notice).
- **Change notices** — when you send a message, Claude learns what changed in the requirements since the last notice (a few lines, or nothing).
- **Commands** — `plan_changes` (plan the work for what changed), `plan_project` (plan the whole current version), `check_acceptance` (compare acceptance criteria with the code before the acceptance check).
- **What Claude may leave in PLARO — you approve each call** — `ask_pm` (a question the requirements do not answer), `report_built` (which requirements were built, with the commit), and on your own PLARO account `mark_checks` (acceptance checks you confirmed as passing). Claude Code asks you every time, in every permission mode, with no "don't ask again"; a run that cannot ask (`claude -p`) refuses them. Nothing else can be changed from here: requirements, versions, the client's confirmation, amounts and dates stay in PLARO.

## Install and sign in

In Claude Code:

```
/plugin marketplace add plaro-kr/plaro-ai
/plugin install plaro@plaro-ai
```

Then open `/mcp`, pick `plaro` and sign in. The browser opens PLARO's sign-in page:

- **Your own PLARO account** (you build the project yourself, or you are on the team): if the browser is signed in to PLARO, press **Allow**. That is all — one sign-in reads every project your account can see.
- **Invited by a PM** (no PLARO account): enter the address your PM connected and the 6-digit code mailed to it, and pick the project.

There is no key to copy: Claude Code keeps the sign-in in your computer's secure storage and renews it by itself. A sign-in lasts 30 days; then the browser asks again.

Until you sign in, Claude Code marks the server as needing authentication, and the message hook reports an error on each message — sign in from `/mcp`. On a computer without a browser, copy the address Claude Code shows; if the redirect fails, paste the full address from the browser's bar into Claude Code.

Use the plugin or a server added by hand (`claude mcp add … plaro https://plaro.kr/mcp/v1`), not both. With both, Claude Code keeps the one added by hand and hides the plugin's server, so the plugin's message hook reports an error on each message. If you added it by hand before, remove it first:

```
claude mcp remove plaro -s user
```

## Which project

Add the two lines PLARO gives you (project → Export → Developer AI connection) to the repository's instruction file (`CLAUDE.md`, or `AGENTS.md`) so every session checks PLARO before building. On your own account the first line carries the project's code (`plaro:7f3c9a12`): Claude names the project with it, and after that PLARO knows the folder you work in. Another repository of another project gets that project's two lines — no new sign-in. Without the lines, Claude asks you which project once.

An invited developer's sign-in reads the one project the PM connected; to switch, use **Clear authentication** on `plaro` in `/mcp` and sign in again.

## What is sent

- To `https://plaro.kr/mcp/v1`: the tool calls Claude makes, with the token from your sign-in, and what you approved Claude to leave.
- On every message, the hook calls `get_notices` through that same signed-in connection, with the folder Claude Code works in (PLARO keeps only a keyed fingerprint of it, to know its project). **What you type is never sent.** The hook waits five seconds at most and never blocks your work.
- PLARO sends back only what the PM put into a requirements version or processed. No meeting or chat text, no amounts, no client names or contacts.

PLARO keeps a record of each sign-in step and call (which connection or account, which tool, the outcome, how long, from which address) for one year — never the content.

## Remove

```
/plugin uninstall plaro@plaro-ai
```

Your own account's tools are listed in PLARO under account settings → Connections, where you can disconnect each. The PM can revoke an invited developer's connection at any time; one nobody uses for 90 days stops by itself.

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
