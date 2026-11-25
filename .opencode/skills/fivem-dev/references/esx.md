# ESX Legacy (`es_extended`)

Official documentation: https://documentation.esx-framework.org/

## Getting the ESX object

The current ESX Legacy shared-object export is:

```lua
local ESX = exports['es_extended']:getSharedObject()
```

The shared imports file is another supported pattern when configured in the manifest:

```lua
shared_script '@es_extended/imports.lua'
```

The older `esx:getSharedObject` event is deprecated for new code. Do not introduce it unless the resource must support a specific older ESX release.

## Client player data

```lua
local ESX = exports['es_extended']:getSharedObject()
local PlayerData = ESX.GetPlayerData()
```

If the resource uses the ESX imports file, `ESX.PlayerData` is kept in sync on the client. Follow the installed version's lifecycle events and clear local state on unload or character switch.

## Server xPlayer

`xPlayer` is a server-side player object. Retrieve it from the trusted event `source`:

```lua
local ESX = exports['es_extended']:getSharedObject()

RegisterNetEvent('myresource:server:example', function()
    local src = source
    local xPlayer = ESX.GetPlayerFromId(src)
    if not xPlayer then return end

    local identifier = xPlayer.getIdentifier()
    local job = xPlayer.getJob()
    print(identifier, job.name)
end)
```

Do not use a client-supplied identifier as authorization.

## Accounts and money

ESX account APIs are distinct from QBCore/QBox APIs. Common methods include `getAccount`, `addAccountMoney`, and `removeAccountMoney`. Verify exact signatures and return behavior in the installed ESX Legacy version. Use server-owned transaction amounts and account names.

## Inventory variations

Inventory behavior depends on ESX version and configuration. Some servers use the default ESX inventory methods, while others integrate ox_inventory or a custom inventory. Inspect `Config.CustomInventory`, imports, dependencies, and the installed inventory resource before writing item operations.

Do not assume default `xPlayer.addInventoryItem` behavior applies when ox_inventory replaces inventory methods.

## Callbacks and usable items

ESX Legacy exposes server callback registration and client triggering patterns, along with `ESX.RegisterUsableItem` in supported versions. Confirm the exact signature and behavior against the project's installed version. Callbacks do not replace server-side validation.

## Don't assume

- Do not use QBCore `Player.Functions` methods on an ESX xPlayer.
- Do not use old shared-object events in new code without a compatibility reason.
- Do not infer the inventory implementation from `es_extended` alone.
- Do not assume player data is ready during early resource startup.
