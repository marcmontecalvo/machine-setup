$ErrorActionPreference='Stop'
winget install --id Tailscale.Tailscale --exact --silent --accept-package-agreements --accept-source-agreements
Write-Host 'Open Tailscale to authenticate this computer.'
