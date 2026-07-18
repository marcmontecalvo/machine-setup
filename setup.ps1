[CmdletBinding()]
param([string[]]$Modules)

$ErrorActionPreference = 'Stop'
$Root = Split-Path -Parent $MyInvocation.MyCommand.Path
$SettingsPath = Join-Path $Root 'config\settings.json'
if (-not (Test-Path $SettingsPath)) { throw "Missing settings file: $SettingsPath" }
$Settings = Get-Content -Raw $SettingsPath | ConvertFrom-Json
$GitName = [string]$Settings.user.name
$GitEmail = [string]$Settings.user.email
$GitHubUsername = [string]$Settings.user.github_username
$GitDefaultBranch = if ($Settings.git.default_branch) { [string]$Settings.git.default_branch } else { 'main' }
$ConfigHostname = [string]$Settings.system.hostname
$ConfigTimezone = [string]$Settings.system.timezone

if ($GitName -eq 'Your Name' -or $GitEmail -eq 'you@example.com' -or $GitHubUsername -eq 'your-github-username') {
    throw 'Replace the placeholder identity values in config/settings.json before running setup.'
}

$Available = [ordered]@{
    git='Git, identity, defaults, and GitHub public SSH keys'; history='PowerShell history search'; tools='Core command-line tools';
    docker='Docker Desktop and Compose'; 'ssh-hardening'='OpenSSH server with conservative hardening'; tailscale='Tailscale client';
    'github-cli'='GitHub CLI installation and authentication'; starship='Starship prompt'; direnv='Per-directory environments';
    zoxide='Smart directory jumping'; eza='Modern directory listings'; tmux='tmux through WSL'; networking='Common networking tools';
    system='Interactive hostname and timezone configuration'
}

if (-not $PSBoundParameters.ContainsKey('Modules')) {
    $Enabled = @{}; foreach ($Name in $Available.Keys) { $Enabled[$Name] = $true }
    $Enabled['ssh-hardening']=$false
    $Enabled['system']=$false
    while ($true) {
        Clear-Host
        Write-Host 'Machine Setup'
        Write-Host 'Toggle by number. A=all, N=none, R=run, Q=quit.'
        Write-Host 'SSH hardening and system identity changes are off by default.'
        $Names = @($Available.Keys)
        for ($i=0; $i -lt $Names.Count; $i++) {
            $mark = if ($Enabled[$Names[$i]]) { 'x' } else { ' ' }
            '{0,2}. [{1}] {2,-15} {3}' -f ($i+1),$mark,$Names[$i],$Available[$Names[$i]] | Write-Host
        }
        $Choice = Read-Host '>'
        switch -Regex ($Choice) {
            '^[Aa]$' { foreach ($Name in $Names) { $Enabled[$Name]=$true } }
            '^[Nn]$' { foreach ($Name in $Names) { $Enabled[$Name]=$false } }
            '^([Rr]|)$' { $Modules=@($Names | Where-Object { $Enabled[$_] }); break }
            '^[Qq]$' { return }
            '^\d+$' { $n=[int]$Choice; if ($n -ge 1 -and $n -le $Names.Count) { $Enabled[$Names[$n-1]] = -not $Enabled[$Names[$n-1]] } }
        }
        if ($null -ne $Modules) { break }
    }
}

foreach ($Module in $Modules) {
    if (-not $Available.Contains($Module)) { throw "Unknown module '$Module'." }
    $Path = Join-Path $Root "modules\windows\$Module.ps1"
    if (-not (Test-Path $Path)) { Write-Warning "$Module is not implemented on Windows; skipping."; continue }
    Write-Host "==> Running $Module"
    & $Path
}
Write-Host 'Setup complete. Open a new PowerShell session to load shell changes.'
