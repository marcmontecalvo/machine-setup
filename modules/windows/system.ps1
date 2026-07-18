$ErrorActionPreference='Stop'
$currentHost=$env:COMPUTERNAME
Write-Host "Hostname:`n  1) Keep current ($currentHost)`n  2) Use settings.json ($ConfigHostname)`n  3) Enter a custom hostname"
$choice=Read-Host '>'
$newHost=''
if ($choice -eq '2') { $newHost=$ConfigHostname }
elseif ($choice -eq '3') { $newHost=Read-Host 'New hostname' }
if ($newHost -and $newHost -ne $currentHost) { Rename-Computer -NewName $newHost -Force; Write-Host 'A restart is required for the hostname change.' }

$currentTz=(Get-TimeZone).Id
Write-Host "Timezone:`n  1) Keep current ($currentTz)`n  2) Eastern Standard Time`n  3) UTC`n  4) Use settings.json ($ConfigTimezone)`n  5) Enter a Windows timezone ID"
$tzChoice=Read-Host '>'
$newTz=''
switch ($tzChoice) { '2' {$newTz='Eastern Standard Time'}; '3' {$newTz='UTC'}; '4' {$newTz=$ConfigTimezone}; '5' {$newTz=Read-Host 'Timezone ID'} }
if ($newTz) { Set-TimeZone -Id $newTz }
