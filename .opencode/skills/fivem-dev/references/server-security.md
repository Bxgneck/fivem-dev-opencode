# FiveM server security

Official Cfx guide: https://docs.fivem.net/docs/developers/server-security/

Treat the network boundary as hostile. Cheats can trigger client-to-server events and client resources can be manipulated.

## Event choice

- Use `AddEventHandler` for events that remain inside the same execution context and do not need network access.
- Use `RegisterNetEvent` only when a client/server context boundary needs to be crossed.
- A registered network event is reachable from an untrusted client. Registration does not authorize the caller.
- A callback is another request/response mechanism, not a security boundary.

## Validate on the server

For each client-originated request, decide which checks apply:

- The server's `source` identifies the requesting connection.
- Player/character exists and is fully loaded.
- Player is entitled to perform the action, based on server-owned framework/ACE state.
- Item, job, grade, account, vehicle, target, recipe, and price exist in server-owned configuration or state.
- Quantity and numeric values are finite, integral where needed, and within sensible bounds.
- Player location is derived from server-visible entity state, not trusted client coordinates.
- Entity/network IDs resolve to expected entities and ownership/scope rules.
- Cooldown/rate limit and duplicate request behavior are handled.
- Inventory capacity, funds, and transaction result are checked before finalizing.

Do not accept client-supplied item definitions, reward amounts, product prices, permissions, balances, job grades, or authoritative coordinates.

## Transaction pattern

Use a server-owned definition and server-computed total:

```lua
local PRODUCTS = {
    water = { price = 5, maxPerPurchase = 10 },
}

RegisterNetEvent('shop:server:purchase', function(itemName, amount)
    local src = source
    if type(itemName) ~= 'string' or type(amount) ~= 'number' then return end
    if amount ~= math.floor(amount) or amount < 1 then return end

    local product = PRODUCTS[itemName]
    if not product or amount > product.maxPerPurchase then return end

    local total = product.price * amount -- price is server-owned
    -- Retrieve the player from the active framework.
    -- Validate balance, inventory capacity, permissions, and transaction result.
    -- Remove funds and grant the item using the installed inventory API.
end)
```

This is a validation outline, not a drop-in resource. Framework and inventory operations must be filled in from the installed project.

## Rate limiting and lifecycle

- Apply per-player cooldowns to spam-prone requests.
- Clean cooldown and job/session state on `playerDropped`.
- Avoid permanent tables keyed by player source without cleanup.
- Consider retries and duplicate requests for purchases, crafting, rewards, and other one-time actions.
- Log suspicious validation failures without logging secrets or excessive personal data.

## Database safety

- Use parameterized queries/placeholders supported by the installed database wrapper.
- Never concatenate client input into SQL.
- Validate identifiers and allowed column/order names separately. SQL placeholders do not safely parameterize arbitrary SQL identifiers.
- Use transactions where related changes must succeed or fail together.

## Server-originated events

When an event should only be triggered by the server but is registered as networked on the receiving side, follow the current Cfx guidance for validating its origin. Do not use an origin check as a substitute for validating payloads and server-side state.
