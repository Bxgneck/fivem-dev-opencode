# Framework and dependency detection

## Evidence order

Use multiple forms of project evidence. Do not classify a server from one string in isolation.

1. `fxmanifest.lua` dependency and import declarations.
2. Actual exports/events used by scripts.
3. `server.cfg` ensure/start statements and resource names.
4. Installed resource folders and versions/commits.
5. Project documentation and configuration.

## Framework indicators

| Evidence | Likely framework | Important qualification |
|---|---|---|
| `qbx_core` dependency, QBox imports, or `exports.qbx_core:*` | QBox | Treat as native QBox unless code deliberately uses its QB compatibility bridge. |
| `qb-core` dependency and `exports['qb-core']:GetCoreObject()` | QBCore | On QBox, `qb-core` may be the bridge resource rather than the server's primary framework. |
| `es_extended` dependency and `exports['es_extended']:getSharedObject()` | ESX Legacy | Check version and configured inventory. |

## Do not conflate framework and ecosystem resources

Identify these independently:

- Inventory: `ox_inventory`, `qb-inventory`, ESX default inventory, or custom.
- Target/interactions: `ox_target`, `qb-target`, or custom.
- Utility library: `ox_lib` or another library.
- Database: `oxmysql`, `mysql-async`, `ghmattimysql`, or custom wrapper.
- Phone, banking, dispatch, garages, clothing, multicharacter, housing, and notification resources.

Never infer the inventory API from the framework name alone.

## QBox with a QB compatibility bridge

QBox supports many QBCore resources through a compatibility layer. If both `qbx_core` and a `qb-core` bridge are present, classify the project as QBox with QB compatibility, unless its own configuration proves another arrangement. Do not tell the user that the project is pure QBCore solely because a resource calls `exports['qb-core']:GetCoreObject()`.

## Ambiguous or mixed repositories

For monorepos, inspect the specific resource being edited. Different resources might use different framework adapters. If evidence conflicts, report the conflict and ask which runtime/server configuration is authoritative before writing framework-specific code.

## Safe inventory of a project

Useful searches include:

```bash
rg -n "qbx_core|qb-core|es_extended|ox_inventory|qb-inventory|ox_target|qb-target|oxmysql|mysql-async|ghmattimysql" .
rg -n "GetCoreObject|getSharedObject|lib\.callback|RegisterNetEvent|RegisterNUICallback" .
```

PowerShell equivalents:

```powershell
Get-ChildItem -Recurse -File -Filter fxmanifest.lua
Get-ChildItem -Recurse -File | Select-String -Pattern 'qbx_core|qb-core|es_extended|ox_inventory|qb-inventory|ox_target|qb-target|oxmysql'
```

Exclude build output, caches, generated bundles, and vendor directories from broad searches when possible.
