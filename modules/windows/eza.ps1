$ErrorActionPreference='Stop'
winget install --id eza-community.eza --exact --silent --accept-package-agreements --accept-source-agreements
$ProfileDir=Split-Path -Parent $PROFILE
New-Item -ItemType Directory -Force -Path $ProfileDir | Out-Null
if (-not (Test-Path $PROFILE)) { New-Item -ItemType File -Path $PROFILE | Out-Null }
if (-not (Select-String -Path $PROFILE -SimpleMatch 'function ll { eza' -Quiet)) { Add-Content $PROFILE "`n# machine-setup: eza`nfunction ll { eza -lah --group-directories-first --git @args }`nfunction tree { eza --tree @args }" }
