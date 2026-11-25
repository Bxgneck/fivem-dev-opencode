# fxmanifest.lua and resource layout

Official manifest reference: https://docs.fivem.net/docs/scripting-reference/resource-manifest/resource-manifest/

## Inspect existing manifests first

Confirm:

- `fx_version` and `game` declarations.
- Script lists and their execution side.
- `shared_scripts`, `client_scripts`, and `server_scripts` ordering.
- `dependencies`, `provide`, `files`, `ui_page`, `data_file`, and declared exports.
- Paths exist with the exact case used in the manifest. Case mistakes often surface on Linux hosts.
- Referenced resource names match the installed resource folder names.

## Minimal structural example

```lua
fx_version 'cerulean'
game 'gta5'

author 'Your Name'
description 'Resource description'
version '1.0.0'

shared_scripts {
    'shared/config.lua',
}

client_scripts {
    'client/main.lua',
}

server_scripts {
    'server/main.lua',
}
```

This is a structural example only. Add library initialization, dependencies, NUI files, database imports, or data files only when this resource uses them and the installed versions support them.

## Common mistakes

- Referencing a file that is not included in the correct script or `files` declaration.
- Declaring a dependency that does not match the actual resource name.
- Relying on implicit startup order instead of declaring required dependencies.
- Putting server-only code in a client script or exposing server internals through a shared script.
- Adding unrelated dependencies copied from another framework's template.
- Changing the manifest without checking how the resource is started in `server.cfg`.

## Resource layout

Follow the project's existing convention. A typical layout may use `client/`, `server/`, `shared/`, and `web/` or `html/`; no single folder layout is mandatory for every resource.
