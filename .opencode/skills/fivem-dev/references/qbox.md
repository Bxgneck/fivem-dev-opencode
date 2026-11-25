# QBox (`qbx_core`)

Official docs: https://docs.qbox.re/

Migration guide: https://docs.qbox.re/migrating/converting-resources

FAQ: https://docs.qbox.re/faq

## Critical distinction

Native QBox does not expose a core object. This is incorrect for native QBox development:

```lua
-- WRONG: qbx_core does not expose GetCoreObject.
local QBX = exports.qbx_core:GetCoreObject()
```

QBox exposes direct exports and modules. The following is a separate compatibility path for legacy QBCore resources running through QBox's `qb-core` bridge:

```lua
-- Compatibility bridge, not a native QBox core object.
local QBCore = exports['qb-core']:GetCoreObject()
```

Do not replace working bridge code automatically. Convert only when the user asks for native QBox code or when the resource is already written in that style.

## Native QBox manifest pattern

Use the modules and dependencies the resource needs. The official conversion guide currently shows this pattern:

```lua
lua54 'yes'

shared_scripts {
    '@ox_lib/init.lua',
    '@qbx_core/modules/lib.lua',
}

client_scripts {
    '@qbx_core/modules/playerdata.lua',
    'client/*.lua',
}

server_scripts {
    '@oxmysql/lib/MySQL.lua', -- only if this resource uses oxmysql
    'server/*.lua',
}

dependencies {
    'qbx_core',
    'ox_lib',
}
```

Do not copy the oxmysql line or add dependencies unless the project uses them. Confirm current manifest guidance for the installed QBox release.

## Player data

The official playerdata module maintains `QBX.PlayerData` on the client. Prefer this maintained data object rather than repeatedly calling a getter when the project uses the module.

```lua
-- Requires @qbx_core/modules/playerdata.lua in client_scripts.
local jobName = QBX.PlayerData.job and QBX.PlayerData.job.name
```

Guard against data not being initialized during loading or character changes.

## Server-side player and money operations

Native QBox exports replace many QBCore core-object methods. The official conversion table includes:

```lua
local Player = exports.qbx_core:GetPlayer(source)

local cash = exports.qbx_core:GetMoney(source, 'cash')
local removed = exports.qbx_core:RemoveMoney(source, 'cash', 100, 'shop-purchase')
local added = exports.qbx_core:AddMoney(source, 'cash', 100, 'shop-refund')
```

The exact export return values and behavior must be checked against the installed QBox version before relying on them. Check for a missing player and validate all transaction facts server-side.

Other documented replacements include `GetPlayerByCitizenId`, `GetOfflinePlayer`, `GetQBPlayers`, `GetDutyCountJob`, `SetJob`, `SetGang`, `SetJobDuty`, `SetMetadata`, `GetMetadata`, and `GetJobs`. Confirm argument types and return behavior from the server exports reference.

## Client notifications and utilities

The official conversion guide maps notifications to `exports.qbx_core:Notify(...)` and QBCore progress bars to `lib.progressBar(...)`. Many utility patterns use ox_lib. Confirm the exact side and signature in current docs.

## Inventory

Do not assume QBox owns item APIs through a player object. QBox documentation maps shared items to `exports.ox_inventory:Items()` and inventory operations to ox_inventory when that inventory is installed. Inspect the configured inventory and follow its current server API.

## Compatibility rules

- QBox can run many QBCore resources through its compatibility bridge.
- QBox-native code should use documented `qbx_core` exports/modules.
- Do not depend on private QBox database tables or internal files.
- Do not add `dependency 'qb-core'` to a resource converted to native QBox unless it genuinely uses the bridge.
- Do not write `QBX.Functions.*` unless the project defines its own adapter with that shape.
