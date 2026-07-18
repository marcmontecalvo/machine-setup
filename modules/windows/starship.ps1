$ErrorActionPreference='Stop'
winget install --id Starship.Starship --exact --silent --accept-package-agreements --accept-source-agreements
$ProfileDir=Split-Path -Parent $PROFILE
New-Item -ItemType Directory -Force -Path $ProfileDir | Out-Null
if (-not (Test-Path $PROFILE)) { New-Item -ItemType File -Path $PROFILE | Out-Null }
if (-not (Select-String -Path $PROFILE -SimpleMatch 'starship init powershell' -Quiet)) { Add-Content $PROFILE "`n# machine-setup: starship`nInvoke-Expression (&starship init powershell)" }
