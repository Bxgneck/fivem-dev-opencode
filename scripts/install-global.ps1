$ErrorActionPreference = 'Stop'

$repoRoot = Split-Path -Parent $PSScriptRoot
$source = Join-Path $repoRoot '.opencode\skills\fivem-dev'
$destinationRoot = Join-Path $HOME '.config\opencode\skills'
$destination = Join-Path $destinationRoot 'fivem-dev'

if (-not (Test-Path (Join-Path $source 'SKILL.md'))) {
    throw "Could not find the skill at: $source"
}

New-Item -ItemType Directory -Path $destinationRoot -Force | Out-Null
if (Test-Path $destination) {
    $backup = "$destination.backup-$(Get-Date -Format 'yyyyMMdd-HHmmss')"
    Rename-Item -LiteralPath $destination -NewName (Split-Path -Leaf $backup)
    Write-Host "Existing installation backed up to: $backup"
}
Copy-Item -LiteralPath $source -Destination $destination -Recurse -Force

Write-Host "Installed FiveM skill to: $destination"
Write-Host 'Restart OpenCode, then invoke it with @fivem-dev.'
