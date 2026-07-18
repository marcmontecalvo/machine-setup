$ErrorActionPreference='Stop'
$cap=Get-WindowsCapability -Online | Where-Object Name -like 'OpenSSH.Server*'
if ($cap.State -ne 'Installed') { Add-WindowsCapability -Online -Name $cap.Name | Out-Null }
$Config="$env:ProgramData\ssh\sshd_config"
if (Test-Path $Config) { Copy-Item $Config "$Config.machine-setup-backup" -Force }
@"
Port $($Settings.ssh.port)
PermitRootLogin no
PasswordAuthentication no
PubkeyAuthentication yes
KbdInteractiveAuthentication no
AllowTcpForwarding yes
"@ | Set-Content $Config
& "$env:WINDIR\System32\OpenSSH\sshd.exe" -t
Set-Service sshd -StartupType Automatic
Restart-Service sshd
if (-not (Get-NetFirewallRule -Name 'OpenSSH-Server-In-TCP' -ErrorAction SilentlyContinue)) {
    New-NetFirewallRule -Name 'OpenSSH-Server-In-TCP' -DisplayName 'OpenSSH Server' -Enabled True -Direction Inbound -Protocol TCP -Action Allow -LocalPort $Settings.ssh.port | Out-Null
}
