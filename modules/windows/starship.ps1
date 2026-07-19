$ErrorActionPreference='Stop'
winget install --id Starship.Starship --exact --silent --accept-package-agreements --accept-source-agreements
Set-ManagedBlock -Path $PROFILE -Name 'starship' -Content 'Invoke-Expression (&starship init powershell)'
