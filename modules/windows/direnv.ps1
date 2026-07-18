$ErrorActionPreference='Stop'
winget install --id direnv.direnv --exact --silent --accept-package-agreements --accept-source-agreements
Write-Host 'direnv is installed. PowerShell hook behavior varies by shell version; run direnv hook pwsh for the current recommended profile snippet.'
