[CmdletBinding()]
param(
    [string[]]$Modules = @('git', 'history', 'tools')
)

$ErrorActionPreference = 'Stop'
$Root = Split-Path -Parent $MyInvocation.MyCommand.Path
. "$Root\config\settings.ps1"

foreach ($Module in $Modules) {
    $Path = Join-Path $Root "modules\windows\$Module.ps1"
    if (-not (Test-Path $Path)) {
        throw "Unknown module '$Module'. Available: git, history, tools"
    }

    Write-Host "==> Running $Module"
    & $Path
}

Write-Host 'Setup complete. Open a new PowerShell session to load all changes.'
