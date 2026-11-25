---
name: FiveM Development
description: Develop, debug, review, and optimize FiveM resources. Use for FiveM natives, Lua, fxmanifest, NUI, QBox, QBCore, ESX Legacy, ox_lib, inventory, targeting, server events, and resource compatibility.
---

# FiveM Development

Use this skill whenever the task involves FiveM server resources, GTA V natives, Lua runtime behavior, framework APIs, or FiveM NUI.

## Non-negotiable rules

1. Never invent a native, export, event, callback, parameter, return value, config key, or resource dependency.
2. Inspect the user's actual project before choosing APIs. A framework name alone does not identify its version, inventory, target, database, or compatibility layer.
3. Keep client and server responsibilities separate. The server owns economy, inventory entitlement, permissions, job changes, rewards, persistent data, and validation.
4. Treat every client-originated event, callback argument, NUI message, and client state value as untrusted input.
5. Do not treat callbacks as a security boundary. Callbacks are request/response transport. Apply the same server-side authorization and validation as for events.
6. Preserve existing architecture and naming unless the user asks for a redesign. Do not replace dependencies or migrate frameworks without approval.
7. Avoid unrelated edits. Explain any schema, config, dependency, or behavior changes before applying them.
8. If documentation or the installed code does not confirm an API, say so. Ask for the installed resource/version or source rather than guessing.

## Required workflow

### 1. Inspect before coding

For a new project or the first FiveM task in a project:

- Locate `fxmanifest.lua` files and identify resource boundaries.
- Inspect relevant `server.cfg` entries when available. Do not expose secrets or copy license keys, tokens, database credentials, or private endpoints into output.
- Check dependencies, `provide`, `shared_scripts`, `client_scripts`, `server_scripts` ordering, exports, imports, and resource start order.
- Search code for framework APIs and event names actually used.
- Identify the framework and its version/revision when evidence is available.
- Identify inventory, target, database, utility, phone, banking, dispatch, and UI resources separately.
- Note whether a compatibility bridge is present.

Do not infer QBCore only because `qb-core` compatibility exports appear in a QBox server. See `references/framework-detection.md`.

### 2. Load relevant references

Read only the files needed for the task:

| Topic | Reference |
|---|---|
| Framework identification | `references/framework-detection.md` |
| QBox | `references/qbox.md` |
| QBCore | `references/qbcore.md` |
| ESX Legacy | `references/esx.md` |
| Network event security | `references/server-security.md` |
| Lua threads and performance | `references/performance.md` |
| ox_lib | `references/ox-lib.md` |
| Resource manifest | `references/fxmanifest.md` |
| NUI | `references/nui.md` |

Resolve the reference paths relative to this `SKILL.md` file.

### 3. Verify APIs

Before using an API that is unfamiliar, version-sensitive, security-sensitive, or not already used in the project:

- Check the official documentation for the relevant resource.
- Check the installed resource source or version when documentation is incomplete.
- Confirm exact spelling, capitalization, argument order, types, return behavior, and execution side (client/server/shared).
- Confirm that the resource is a declared and started dependency.
- Confirm whether the API is current, deprecated, or a compatibility-bridge API.

Preferred sources:

- FiveM: https://docs.fivem.net/
- Cfx server security: https://docs.fivem.net/docs/developers/server-security/
- QBox: https://docs.qbox.re/
- QBCore: https://docs.qbcore.org/
- ESX Legacy: https://documentation.esx-framework.org/
- ox_lib: https://overextended.dev/docs/ox_lib

Use the web, browser, documentation, or MCP tools available in the current OpenCode configuration. Do not assume a Claude-only `WebFetch` tool exists. If online lookup is unavailable, inspect installed source or ask the user to provide the relevant documentation. Clearly label unverified assumptions.

### 4. Plan and implement

Before a multi-file or risky change:

- State the relevant existing architecture and dependencies.
- Identify files to change and the reason for each change.
- Flag database migrations, config changes, event contract changes, and dependency additions.
- Ask before destructive changes, migrations, framework conversion, or changing established public exports/events.

Then implement the smallest complete change. Keep code consistent with neighboring resources.

### 5. Validate

After editing:

- Review the final diff for unrelated changes, missing files, casing errors, and accidental secrets.
- Check Lua syntax with the project's available Lua/Cfx tooling when installed.
- Check JS/TS and NUI builds with the project's package scripts when available.
- Check manifest paths and dependency names against the actual resource folders.
- Check server-side validation and cleanup paths.
- Run tests or validation commands that exist in the repository. Do not claim tests passed when they were not run.
- Report what was verified, what was not run, and any server-side test still needed.

## Framework isolation

- Never mix framework APIs in a resource without an explicit compatibility abstraction already present or requested by the user.
- A shared API name does not imply identical behavior between framework versions.
- Do not create a universal bridge just to avoid identifying the active framework.
- Do not assume inventory or target APIs belong to the framework. Inspect the installed resource that owns them.
- If the project intentionally supports multiple frameworks, follow its existing bridge and test each supported path.

## FiveM-specific DOs

- Use `AddEventHandler` for same-context handlers that do not need network access.
- Use `RegisterNetEvent` only when a cross-context network event is required.
- Validate client requests on the server using server-owned facts.
- Use a server-owned price, reward amount, item definition, location, and permission decision.
- Validate entity existence, player state, distance, quantity bounds, cooldowns, and resource state as relevant.
- Handle missing player objects and missing exports safely.
- Clean up player-scoped state on `playerDropped` and resource-scoped state on resource stop.
- Use parameterized SQL through the installed database resource.
- Use `Wait(0)` for genuinely per-frame work, such as drawing. Reduce expensive per-frame work and use adaptive waits for periodic proximity checks.
- Cache stable values only when invalidation and lifecycle updates are clear.
- Use state bags for small replicated state when suitable. Do not treat client-writable replicated state as trusted server authority.
- Use the installed interaction/target resource instead of adding a competing system without a reason.
- Keep event names resource-scoped, for example `resourceName:server:action`.

## FiveM-specific DON'Ts

- Do not trust money, inventory, job, gang, permission, reward, or price values supplied by a client.
- Do not assume `RegisterNetEvent` makes an event safe from malicious callers.
- Do not assume a callback is private or authorized.
- Do not expose internal server-only actions as client-callable events.
- Do not use raw SQL string concatenation with user-controlled values.
- Do not add `Wait(0)` to loops that only need periodic checks.
- Do not replace `Wait(0)` with `Wait(5)` or `Wait(10)` for work that must execute every frame. FiveM documents `Wait(0)` as the next game tick.
- Do not use framework APIs from a different framework because a tutorial uses them.
- Do not assume a QBox core object exists.
- Do not assume `Player.Functions.AddItem` exists across QBCore versions or inventory implementations.
- Do not assume ox_inventory, qb-inventory, ox_target, qb-target, oxmysql, or ox_lib is installed until project evidence confirms it.
- Do not place secrets, tokens, database passwords, or private identifiers in generated files, logs, or example code.

## Response format for development tasks

Keep the report practical:

1. Framework and resource dependencies found, with file evidence.
2. Proposed or completed changes.
3. API and documentation verification performed.
4. Security/performance considerations.
5. Tests run and tests not run.
6. Remaining assumptions or required server testing.

If the user asks only a conceptual question, answer directly without forcing the full workflow.
