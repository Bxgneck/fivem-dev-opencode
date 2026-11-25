# FiveM Development Skill for OpenCode

An OpenCode-native FiveM development skill for QBox, QBCore, and ESX Legacy. It gives the coding agent a repeatable way to inspect a server, identify the actual framework and installed dependencies, verify APIs, and follow security and performance rules.

This is an independent OpenCode adaptation inspired by the structure and goals of [melihbozkurt10/fivem-dev-plugin](https://github.com/melihbozkurt10/fivem-dev-plugin). The upstream repository's package metadata declares MIT, but the reviewed snapshot did not include a root LICENSE file. This project includes attribution and links to upstream without reproducing its original files wholesale.

## What changed

- Uses OpenCode's native Agent Skills layout: `.opencode/skills/fivem-dev/SKILL.md`.
- Removes Claude Code plugin metadata, npm post-install assumptions, and Claude-only `WebFetch` instructions.
- Requires project inspection before selecting a framework or dependency API.
- Corrects the QBox core-object misconception. Native QBox has no `qbx_core:GetCoreObject()` export. Use documented `qbx_core` exports and modules. The `qb-core` compatibility bridge is a separate legacy-compatibility path.
- Replaces broad anti-`Wait(0)` advice with the correct rule: use `Wait(0)` for work that must run every frame, and avoid expensive per-frame work.
- Clarifies that callbacks do not provide authorization. Server-side validation is mandatory.
- Avoids assuming all QBCore servers use the same inventory, target, database, or UI resources.
- Includes focused reference documents and global install scripts for Windows and macOS/Linux.

## Install globally on Windows

1. Download or clone this repository.
2. Open PowerShell in the repository folder.
3. Run:

```powershell
.\scripts\install-global.ps1
```

The script copies the skill to:

```text
%USERPROFILE%\.config\opencode\skills\fivem-dev\
```

Restart OpenCode. Invoke the skill with `@fivem-dev`, or ask a FiveM development question and let OpenCode discover it.

Example:

```text
@fivem-dev Review this resource and identify its framework, inventory, target, and database dependencies before changing anything.
```

## Install globally on macOS/Linux

```bash
chmod +x ./scripts/install-global.sh
./scripts/install-global.sh
```

The skill installs to:

```text
~/.config/opencode/skills/fivem-dev/
```

## Install for one project only

Copy this repository's `.opencode/skills/fivem-dev` directory into your FiveM server or resource repository:

```text
your-project/
└── .opencode/
    └── skills/
        └── fivem-dev/
            ├── SKILL.md
            └── references/
```

OpenCode discovers project skills in `.opencode/skills/<skill-id>/SKILL.md`.

## What the skill does

1. Inspects `fxmanifest.lua`, `server.cfg`, resource directories, imports, exports, and existing code.
2. Identifies the primary framework and compatibility bridges separately.
3. Identifies the actual inventory, target, database, UI, and utility resources.
4. Reads only relevant reference documents.
5. Verifies uncertain or version-sensitive APIs against official documentation or installed source.
6. Plans changes before editing and preserves existing project conventions.
7. Validates server-side authority, input checks, event direction, and cleanup.
8. Reports assumptions, evidence, compatibility risks, and tests.

## Supported frameworks

| Framework | Reference |
|---|---|
| QBox (`qbx_core`) | `references/qbox.md` |
| QBCore (`qb-core`) | `references/qbcore.md` |
| ESX Legacy (`es_extended`) | `references/esx.md` |

The skill also includes general references for framework detection, server security, performance, ox_lib, resource manifests, and NUI.

## Documentation sources

- FiveM docs: https://docs.fivem.net/
- FiveM server security: https://docs.fivem.net/docs/developers/server-security/
- FiveM Lua `Wait`: https://docs.fivem.net/docs/scripting-reference/runtimes/lua/functions/Citizen.Wait
- QBox docs: https://docs.qbox.re/
- QBox resource conversion: https://docs.qbox.re/migrating/converting-resources
- QBox FAQ: https://docs.qbox.re/faq
- QBCore docs: https://docs.qbcore.org/
- ESX Legacy docs: https://documentation.esx-framework.org/
- ox_lib docs: https://overextended.dev/docs/ox_lib
- OpenCode Agent Skills: https://opencode.ai/docs/skills/

## Important limitation

The reference files are a starting point, not a substitute for checking exact versions installed on a server. Framework forks and server-specific resources often change APIs. The agent must inspect the project and verify version-sensitive details before writing code.

## Upstream attribution

Starting point reviewed: https://github.com/melihbozkurt10/fivem-dev-plugin

This project retains the broad FiveM framework coverage concept while changing the instructions, structure, and examples for OpenCode and correcting guidance that conflicts with current documentation.
