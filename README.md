# machine-setup

Repeatable workstation and server setup for Linux, macOS, and Windows.

Each feature is kept in a separate module. Running the main script without arguments opens a small terminal menu where modules can be enabled or disabled before anything changes.

## Quick install for Linux and macOS

```bash
curl -fsSL https://raw.githubusercontent.com/marcmontecalvo/machine-setup/main/install.sh | bash
```

The installer downloads the current repository into `~/.local/share/machine-setup`, prompts for the Git name, email, GitHub username, and default branch on the first run, then opens the module selector. Existing `config/settings.json` values and locally added files are preserved when the command is run again.

Do **not** run the entire installer with `sudo`. The setup contains user-level Git, SSH, shell, and prompt configuration that must be written to the normal user's home directory. Individual modules request `sudo` only when system-level changes require it.

A different install location or branch can be selected through environment variables:

```bash
MACHINE_SETUP_HOME="$HOME/machine-setup" \
MACHINE_SETUP_BRANCH="main" \
curl -fsSL https://raw.githubusercontent.com/marcmontecalvo/machine-setup/main/install.sh | bash
```

## Configuration

The quick installer creates this file interactively on the first run. For a manual clone, edit `config/settings.json` before running setup:

```json
{
  "user": {
    "name": "Your Name",
    "email": "you@example.com",
    "github_username": "your-github-username"
  },
  "git": {
    "default_branch": "main"
  },
  "ssh": {
    "port": 22,
    "permit_root_login": false,
    "password_authentication": false
  },
  "system": {
    "hostname": "",
    "timezone": ""
  }
}
```

The scripts refuse to run while the identity placeholders remain. Blank hostname and timezone values are allowed because the `system` module can prompt for them interactively.

## Manual Linux and macOS setup

```bash
git clone https://github.com/marcmontecalvo/machine-setup.git
cd machine-setup
nano config/settings.json
bash setup.sh
```

Running `setup.sh` opens the module selector. Toggle an item by entering its number, then press Enter or `R` to run the selected modules.

Modules can also be supplied directly:

```bash
bash setup.sh git history starship zoxide eza
```

## Windows

Run PowerShell as your normal user. Modules that configure Windows services or system identity may trigger an elevation prompt.

```powershell
git clone https://github.com/marcmontecalvo/machine-setup.git
Set-Location machine-setup
notepad .\config\settings.json
Set-ExecutionPolicy -Scope Process Bypass
.\setup.ps1
```

Run specific modules without the menu:

```powershell
.\setup.ps1 -Modules git,history,starship,zoxide,eza
```

## Modules

| Module | Platforms | Purpose |
|---|---|---|
| `git` | Linux, macOS, Windows | Installs Git, configures identity and defaults, and adds the GitHub account's public SSH keys to `authorized_keys`. |
| `history` | Linux, macOS, Windows | Enables prefix-based Up/Down shell-history search and improved history behavior. |
| `tools` | Linux, macOS, Windows | Installs the existing baseline of useful command-line utilities. |
| `shell` | Linux, macOS | Adds restrained aliases and shell quality-of-life defaults. |
| `docker` | Linux, macOS, Windows | Installs Docker Engine or Docker Desktop and Docker Compose. |
| `ssh-hardening` | Linux, Windows | Installs OpenSSH Server and applies settings from `settings.json`. |
| `tailscale` | Linux, macOS, Windows | Installs Tailscale; interactive account authentication remains required. |
| `github-cli` | Linux, macOS, Windows | Installs `gh` and starts GitHub's interactive browser authentication when needed. |
| `starship` | Linux, macOS, Windows | Installs and enables the Starship prompt. |
| `direnv` | Linux, macOS, Windows | Installs per-directory environment handling. |
| `zoxide` | Linux, macOS, Windows | Installs and enables smart directory jumping. |
| `eza` | Linux, macOS, Windows | Installs modern directory listings and useful aliases/functions. |
| `tmux` | Linux, macOS, Windows through WSL | Installs tmux and writes a practical mouse-enabled configuration. |
| `networking` | Linux, macOS, Windows | Installs common DNS, routing, socket, throughput, and packet-analysis tools. |
| `system` | Linux, macOS, Windows | Prompts to keep, configure, or enter hostname and timezone values. |

## Menu defaults

Most modules are selected by default. These are intentionally disabled until explicitly selected:

- `ssh-hardening`, because disabling passwords or changing the SSH port can lock out a remote user.
- `system`, because hostname changes can require a restart and may affect other services.

Use `A` in the menu to select everything or `N` to clear everything.

## SSH-key behavior

The Git module downloads public keys from:

```text
https://github.com/<github_username>.keys
```

It adds missing keys to `authorized_keys`. It never downloads or creates private keys. This authorizes keys already published on the GitHub account to connect to the computer; it does not give the computer a private key for pushing to GitHub.

The SSH hardening module validates the generated server configuration before restarting SSH. Review `config/settings.json` and confirm key-based access works before enabling it on a remote-only server.

## Rerun safety

- Shell and PowerShell profile changes are stored in named `machine-setup` blocks. Rerunning a module replaces its existing block instead of appending another copy.
- Before the first managed change to an existing file, the original is saved beside it as `<filename>.machine-setup-backup`. That backup is not overwritten by later runs.
- Files are generated into temporary files and moved into place only when their content changed.
- Existing content outside managed blocks is retained, including custom tmux settings.
- The curl updater overlays repository files without deleting locally added files and always preserves `config/settings.json`.
- GitHub public SSH keys are added only when the exact key is not already present.

## Notes

- The curl bootstrap requires `curl`, `tar`, and Python 3.
- Package managers and third-party installers may still display their own prompts or perform normal upgrades on repeat runs.
- Docker Desktop, Tailscale, and GitHub CLI still require their normal first-run authentication or initialization.
- Windows tmux support uses the default WSL distribution.
- `dmux` is not included yet; it is a specialized developer tool built on top of tmux.
