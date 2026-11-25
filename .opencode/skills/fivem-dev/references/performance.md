# FiveM Lua performance and threads

Official `Citizen.Wait` documentation: https://docs.fivem.net/docs/scripting-reference/runtimes/lua/functions/Citizen.Wait/

## Wait behavior

`Wait(0)` yields until the next game tick. Its timing is frame-bound and therefore varies with the client's frame rate.

Use `Wait(0)` when work must happen every frame, for example drawing a marker, text, or other per-frame UI. Do not replace it with `Wait(5)` or `Wait(10)` when every-frame behavior is required, because ticks can be skipped.

For periodic checks, use a non-zero adaptive wait that fits the required responsiveness. Do not run expensive natives or large table/database work every frame.

## Adaptive wait example

```lua
CreateThread(function()
    while true do
        local sleep = 1000
        local coords = GetEntityCoords(PlayerPedId())

        for i = 1, #locations do
            local distance = #(coords - locations[i].coords)
            if distance < 15.0 then
                sleep = 250
                if distance < 2.0 then
                    sleep = 0
                    -- Only keep the per-frame portion here if UI/drawing needs it.
                end
            end
        end

        Wait(sleep)
    end
end)
```

This pattern is illustrative. Use the project's target/zone library when one already exists and fits the interaction.

## DO

- Keep per-frame work small and predictable.
- Cache values that are stable enough to cache, with clear refresh/invalidation rules.
- Reuse existing lifecycle events instead of polling for a player state change.
- Bound loops and avoid repeated full-table scans when an indexed structure is appropriate.
- Avoid repeated SQL queries from client ticks or UI rendering.
- Clean threads, timers, zones, state handlers, and references on resource stop.
- Profile before making speculative micro-optimizations.

## DON'T

- Do not use `while true do ... end` without yielding.
- Do not put database queries, long loops, large serialization, or expensive shape tests in every-frame work.
- Do not use `Wait(0)` for a check that only needs to run once per second.
- Do not cache an entity/player handle forever when respawn, entity deletion, or player lifecycle can invalidate it.
- Do not spam state bags or network events for data that rarely changes.
- Do not send large NUI payloads every frame.

## State bags

Use state bags for small replicated state where entity/player/global scope is appropriate. Keep authoritative decisions on the server. A replicated value writable by a client is not proof of authorization. Review the current state-bag semantics and serialization limits before designing a large or frequently changing payload.
