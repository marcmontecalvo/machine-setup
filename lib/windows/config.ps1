function Backup-FileOnce {
    param([Parameter(Mandatory)][string]$Path)
    if (-not (Test-Path -LiteralPath $Path -PathType Leaf)) { return }
    $Backup = "$Path.machine-setup-backup"
    if (-not (Test-Path -LiteralPath $Backup)) {
        Copy-Item -LiteralPath $Path -Destination $Backup
        Write-Host "Backed up $Path to $Backup"
    }
}

function Set-FileIfChanged {
    param(
        [Parameter(Mandatory)][string]$Path,
        [Parameter(Mandatory)][string]$Content
    )
    $Directory = Split-Path -Parent $Path
    if ($Directory) { New-Item -ItemType Directory -Force -Path $Directory | Out-Null }
    $Existing = if (Test-Path -LiteralPath $Path) { Get-Content -LiteralPath $Path -Raw } else { $null }
    if ($Existing -eq $Content) {
        Write-Host "Unchanged: $Path"
        return
    }
    Backup-FileOnce -Path $Path
    $Temp = Join-Path $Directory ('.machine-setup-' + [guid]::NewGuid().ToString('N') + '.tmp')
    [IO.File]::WriteAllText($Temp, $Content, [Text.UTF8Encoding]::new($false))
    Move-Item -LiteralPath $Temp -Destination $Path -Force
    Write-Host "Updated: $Path"
}

function Set-ManagedBlock {
    param(
        [Parameter(Mandatory)][string]$Path,
        [Parameter(Mandatory)][string]$Name,
        [Parameter(Mandatory)][string]$Content
    )
    $Start = "# >>> machine-setup: $Name >>>"
    $End = "# <<< machine-setup: $Name <<<"
    $Existing = if (Test-Path -LiteralPath $Path) { Get-Content -LiteralPath $Path -Raw } else { '' }
    $Pattern = '(?ms)^' + [regex]::Escape($Start) + '.*?^' + [regex]::Escape($End) + '\r?\n?'
    $Base = [regex]::Replace($Existing, $Pattern, '').TrimEnd("`r", "`n")
    $Block = "$Start`r`n$Content`r`n$End`r`n"
    $Result = if ($Base) { "$Base`r`n`r`n$Block" } else { $Block }
    Set-FileIfChanged -Path $Path -Content $Result
}
