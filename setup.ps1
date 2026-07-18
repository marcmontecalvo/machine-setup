[CmdletBinding()]
param(
    [string[]]$Modules = @('git', 'history', 'tools')
)

$ErrorActionPreference = 'Stop'
$Root = Split-Path -Parent $MyInvocation.MyCommand.Path
$SettingsPath = Join-Path $Root 'config\settings.json'

if (-not (Test-Path $SettingsPath)) {
    throw "Missing settings file: $SettingsPath"
}

$Settings = Get-Content -Raw $SettingsPath | ConvertFrom-Json
$GitName = [string]$Settings.user.name
$GitEmail = [string]$Settings.user.email
$GitHubUsername = [string]$Settings.user.github_username
$GitDefaultBranch = if ($Settings.git.default_branch) { [string]$Settings.git.default_branch } else { 'main' }

if (-not $GitName -or -not $GitEmail -or -not $GitHubUsername) {
    throw 'Complete config/settings.json before running setup.'
}

if ($GitName -eq 'Your Name' -or $GitEmail -eq 'you@example.com' -or $GitHubUsername -eq 'your-github-username') {
    throw 'Replace the placeholder values in config/settings.json before running setup.'
}

foreach ($Module in $Modules) {
    $Path = Join-Path $Root "modules\windows\$Module.ps1"
    if (-not (Test-Path $Path)) {
        throw "Unknown module '$Module'. Available: git, history, tools"
    }

    Write-Host "==> Running $Module"
    & $Path
}

Write-Host 'Setup complete. Open a new PowerShell session to load all changes.'
