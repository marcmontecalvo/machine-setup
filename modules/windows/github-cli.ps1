$ErrorActionPreference='Stop'
if (-not (Get-Command gh -ErrorAction SilentlyContinue)) {
    winget install --id GitHub.cli --exact --silent --accept-package-agreements --accept-source-agreements
    $env:Path=[Environment]::GetEnvironmentVariable('Path','Machine')+';'+[Environment]::GetEnvironmentVariable('Path','User')
}
try { gh auth status | Out-Null } catch { gh auth login --web --git-protocol ssh }
