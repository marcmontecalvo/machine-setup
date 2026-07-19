$ErrorActionPreference='Stop'
winget install --id ajeetdsouza.zoxide --exact --silent --accept-package-agreements --accept-source-agreements
Set-ManagedBlock -Path $PROFILE -Name 'zoxide' -Content 'Invoke-Expression (& { (zoxide init powershell | Out-String) })'
