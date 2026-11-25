# QBCore (`qb-core`)

Official documentation: https://docs.qbcore.org/

Official documentation repository: https://github.com/qbcore-framework/qb-docs

## Core access

The standard current pattern is:

```lua
local QBCore = exports['qb-core']:GetCoreObject()
```

QBCore also documents requesting only the parts needed, for example:

```lua
local QBCore = exports['qb-core']:GetCoreObject({ 'Functions' })
```

Check the installed qb-core version and docs. Older event-based object retrieval patterns should not be introduced into new code without a compatibility requirement.

## Client player data

```lua
local QBCore = exports['qb-core']:GetCoreObject({ 'Functions' })

RegisterNetEvent('QBCore:Client:OnPlayerLoaded', function()
    local PlayerData = QBCore.Functions.GetPlayerData()
    if not PlayerData or not PlayerData.job then return end

    print(PlayerData.job.name)
end)
```

Do not assume player data is populated before the load lifecycle completes. Clear resource-local player state on unload/character switch where relevant.

## Server player access

```lua
local QBCore = exports['qb-core']:GetCoreObject({ 'Functions' })

RegisterNetEvent('myresource:server:example', function()
    local src = source
    local Player = QBCore.Functions.GetPlayer(src)
    if not Player then return end

    local citizenid = Player.PlayerData.citizenid
    print(citizenid)
end)
```

`source` is the current server connection ID, not a persistent character identifier. Do not accept a client-provided source or citizen ID as proof of identity.

## Money

QBCore player methods include `GetMoney`, `AddMoney`, and `RemoveMoney` on supported versions. Check their current signatures and results in the installed code/docs. Use a server-owned amount and reason. Handle failed transactions. Never trust a UI-supplied price or balance.

## Inventory

Do not assume inventory methods exist on `Player.Functions` in every QBCore version or setup. Inventory is frequently implemented by a separate resource. Inspect `qb-inventory`, `ox_inventory`, or the server's custom inventory and use its documented exports. The server must validate item identity, count, capacity, entitlement, and transaction order.

## Callbacks

QBCore offers `QBCore.Functions.CreateCallback` on the server and `QBCore.Functions.TriggerCallback` on the client. A callback is still callable by the client. Apply server-side checks to sensitive values and operations exactly as you would in a network event.

## Useable items

QBCore documentation uses the spelling `CreateUseableItem` in current examples. Do not silently change item handling to a guessed function name. Confirm the installed version and the inventory's expected workflow before editing usable-item registration.

## Don't assume

- Inventory APIs are not uniform across all QBCore servers.
- `qb-target`, `qb-menu`, `qb-input`, or `qb-inventory` are not guaranteed to be installed.
- A QBox server may expose a `qb-core` compatibility bridge. Check `qbx_core` before classifying the primary framework.
- Callback registration does not validate permissions.
