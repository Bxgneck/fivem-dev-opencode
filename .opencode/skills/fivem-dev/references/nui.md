# FiveM NUI

Official Cfx documentation: https://docs.fivem.net/docs/scripting-manual/nui-development/

NUI has a browser frontend and a Lua client resource. Treat messages from the browser as untrusted client input. Server authority still belongs on the server.

## Lua to NUI

```lua
SendNUIMessage({
    action = 'setVisible',
    visible = true,
})

SetNuiFocus(true, true)
```

Send only the data the UI needs. Avoid frequent large payloads and avoid exposing private server data.

## NUI to Lua

```javascript
const resourceName = GetParentResourceName();

const response = await fetch(`https://${resourceName}/saveSettings`, {
  method: 'POST',
  headers: { 'Content-Type': 'application/json; charset=UTF-8' },
  body: JSON.stringify({ enabled: true }),
});

const result = await response.json();
```

## Lua callback

```lua
RegisterNUICallback('saveSettings', function(data, cb)
    if type(data) ~= 'table' or type(data.enabled) ~= 'boolean' then
        cb({ ok = false, error = 'invalid_payload' })
        return
    end

    -- Store client-side UI preference only, or request a server action
    -- that performs its own authoritative validation.
    cb({ ok = true })
end)
```

A NUI callback runs in the client resource. It is not a secure place to authorize purchases, grant items, change jobs, or perform privileged server operations. Send a request to the server and validate it there.

## DO

- Return a response through the NUI callback on every code path.
- Validate message shape and types before using input.
- Handle rejected fetch requests and malformed responses.
- Clear NUI focus when the interface closes and when the resource stops, where appropriate.
- Keep action names and payload shapes consistent between JS and Lua.
- Escape user-controlled text before inserting it into HTML.

## DON'T

- Do not trust values because they came from your own UI.
- Do not place secrets, database credentials, or privileged server values in the browser bundle.
- Do not directly render untrusted HTML.
- Do not assume a NUI callback validates server-side entitlement.
- Do not send an event for every animation frame unless the design truly requires it.
