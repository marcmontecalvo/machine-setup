$ErrorActionPreference = 'Stop'

if (-not (Get-Command git -ErrorAction SilentlyContinue)) {
    if (-not (Get-Command winget -ErrorAction SilentlyContinue)) {
        throw 'winget is required to install Git automatically.'
    }
    winget install --id Git.Git --exact --silent --accept-package-agreements --accept-source-agreements
    $env:Path = [System.Environment]::GetEnvironmentVariable('Path', 'Machine') + ';' + [System.Environment]::GetEnvironmentVariable('Path', 'User')
}

git config --global user.name $GitName
git config --global user.email $GitEmail
git config --global init.defaultBranch main
git config --global pull.ff only
git config --global fetch.prune true
git config --global rebase.autoStash true
git config --global rerere.enabled true
git config --global core.autocrlf true

$SshDirectory = Join-Path $HOME '.ssh'
$AuthorizedKeys = Join-Path $SshDirectory 'authorized_keys'
New-Item -ItemType Directory -Force -Path $SshDirectory | Out-Null
$Keys = (Invoke-WebRequest -UseBasicParsing "https://github.com/$GitHubUsername.keys").Content -split "`n" | Where-Object { $_.Trim() }
$Existing = if (Test-Path $AuthorizedKeys) { Get-Content $AuthorizedKeys } else { @() }
$Combined = @($Existing + $Keys) | Select-Object -Unique
Set-Content -Path $AuthorizedKeys -Value $Combined
