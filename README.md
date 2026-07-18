# machine-setup

Repeatable workstation and server setup for Linux, macOS, and Windows.

## Linux and macOS

```bash
git clone https://github.com/marcmontecalvo/machine-setup.git
cd machine-setup
bash setup.sh
```

Run selected modules:

```bash
bash setup.sh git history tools
```

Available modules:

- `git` — installs Git, configures identity and sensible defaults, and imports the GitHub account's public SSH keys into `~/.ssh/authorized_keys`.
- `history` — enables prefix-based Up/Down shell-history search.
- `tools` — installs a compact baseline of useful CLI tools when available.
- `shell` — adds safe shell quality-of-life defaults and aliases.

## Windows

Run PowerShell as your normal user:

```powershell
Set-ExecutionPolicy -Scope Process Bypass
.\setup.ps1
```

Or select modules:

```powershell
.\setup.ps1 -Modules git,history,tools
```

## Configuration

Defaults are stored in `config/settings.env` and `config/settings.ps1`. Forks can change the Git name, email, and GitHub username there.

## Safety and behavior

- Scripts are intended to be idempotent.
- Existing configuration files are preserved.
- Managed sections are clearly marked and replaced on later runs.
- The SSH module downloads **public** keys from `https://github.com/<username>.keys`; it never downloads or creates private keys.
