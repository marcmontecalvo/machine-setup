$ErrorActionPreference='Stop'
winget install --id Insecure.Nmap --exact --silent --accept-package-agreements --accept-source-agreements
Write-Host 'Windows already includes Test-NetConnection, Resolve-DnsName, Get-NetTCPConnection, tracert, pathping, netstat, and pktmon. Nmap was added.'
