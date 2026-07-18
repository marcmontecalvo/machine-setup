$ErrorActionPreference='Stop'
if (-not (Get-Command winget -ErrorAction SilentlyContinue)) { throw 'winget is required.' }
winget install --id Docker.DockerDesktop --exact --silent --accept-package-agreements --accept-source-agreements
Write-Host 'Start Docker Desktop once to finish initialization. WSL 2 may require a restart.'
