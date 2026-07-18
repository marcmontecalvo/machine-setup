$ErrorActionPreference='Stop'
winget install --id ajeetdsouza.zoxide --exact --silent --accept-package-agreements --accept-source-agreements
$ProfileDir=Split-Path -Parent $PROFILE
New-Item -ItemType Directory -Force -Path $ProfileDir | Out-Null
if (-not (Test-Path $PROFILE)) { New-Item -ItemType File -Path $PROFILE | Out-Null }
if (-not (Select-String -Path $PROFILE -SimpleMatch 'zoxide init powershell' -Quiet)) { Add-Content $PROFILE "`n# machine-setup: zoxide`nInvoke-Expression (& { (zoxide init powershell | Out-String) })" }
