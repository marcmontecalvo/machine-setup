$ErrorActionPreference = 'Stop'

if (-not (Get-Command winget -ErrorAction SilentlyContinue)) {
    throw 'winget is required to install CLI tools automatically.'
}

$Packages = @(
    'GitHub.cli',
    'jqlang.jq',
    'BurntSushi.ripgrep.MSVC',
    'sharkdp.fd',
    'junegunn.fzf',
    'sharkdp.bat'
)

foreach ($Package in $Packages) {
    winget install --id $Package --exact --silent --accept-package-agreements --accept-source-agreements
}
