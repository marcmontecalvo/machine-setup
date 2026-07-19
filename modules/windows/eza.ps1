$ErrorActionPreference='Stop'
winget install --id eza-community.eza --exact --silent --accept-package-agreements --accept-source-agreements
$Block = @'
function ll { eza -lah --group-directories-first --git @args }
function tree { eza --tree @args }
'@
Set-ManagedBlock -Path $PROFILE -Name 'eza' -Content $Block.TrimEnd()
