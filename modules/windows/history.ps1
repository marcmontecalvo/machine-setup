$ErrorActionPreference = 'Stop'

if (-not (Get-Module -ListAvailable -Name PSReadLine)) {
    Install-Module PSReadLine -Scope CurrentUser -Force
}

$ProfileDirectory = Split-Path -Parent $PROFILE.CurrentUserAllHosts
New-Item -ItemType Directory -Force -Path $ProfileDirectory | Out-Null
$ProfilePath = $PROFILE.CurrentUserAllHosts
$Start = '# >>> machine-setup history >>>'
$End = '# <<< machine-setup history <<<'
$Existing = if (Test-Path $ProfilePath) { Get-Content $ProfilePath -Raw } else { '' }
$Pattern = "(?ms)^$([regex]::Escape($Start)).*?^$([regex]::Escape($End))\r?\n?"
$Existing = [regex]::Replace($Existing, $Pattern, '')
$Block = @'
# >>> machine-setup history >>>
Import-Module PSReadLine
Set-PSReadLineKeyHandler -Key UpArrow -Function HistorySearchBackward
Set-PSReadLineKeyHandler -Key DownArrow -Function HistorySearchForward
Set-PSReadLineOption -HistorySearchCursorMovesToEnd
Set-PSReadLineOption -MaximumHistoryCount 50000
# <<< machine-setup history <<<
'@
Set-Content -Path $ProfilePath -Value ($Existing.TrimEnd() + "`r`n" + $Block + "`r`n")
