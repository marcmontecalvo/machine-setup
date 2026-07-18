# machine-setup

Repeatable workstation and server setup for Linux, macOS, and Windows.

The repository is organized into small modules so features can be added, removed, or run independently without turning the main setup scripts into one large file.

## Configure your identity first

Edit `config/settings.json` before running anything:

```json
{
  "user": {
    "name": "Your Name",
    "email": "you@example.com",
    "github_username": "your-github-username"
  },
  "git": {
    "default_branch": "main"
  }
}
```

These values are used to configure Git and retrieve the GitHub account's public SSH keys. The setup scripts refuse to run while the placeholder values are still present.

## Linux and macOS

```bash
git clone https://github.com/marcmontecalvo/machine-setup.git
cd machine-setup
nano config/settings.json
bash setup.sh
```

Run selected modules only:

```bash
bash setup.sh git history tools shell
```

## Windows

Run PowerShell as your normal user:

```powershell
git clone https://github.com/marcmontecalvo/machine-setup.git
Set-Location machine-setup
notepad .\config\settings.json
Set-ExecutionPolicy -Scope Process Bypass
.\setup.ps1
```

Run selected modules only:

```powershell
.\setup.ps1 -Modules git,history,tools
```

## Included modules

| Module | Platforms | Purpose |
|---|---|---|
| `git` | Linux, macOS, Windows | Installs Git, configures the identity and defaults from `settings.json`, and adds the GitHub account's public SSH keys to `authorized_keys`. |
| `history` | Linux, macOS, Windows | Enables prefix-based Up/Down history search and improves shell-history behavior. |
| `tools` | Linux, macOS, Windows | Installs a compact set of useful command-line tools when supported by the operating system. |
| `shell` | Linux, macOS | Adds restrained aliases and shell quality-of-life defaults. |

The current Unix tools baseline includes packages such as `jq`, `ripgrep`, `fd`, `fzf`, `bat`, `tree`, `tmux`, and `htop`, depending on package-manager availability.

## Suggested but not yet included

These were discussed but are not currently installed or configured by the repository:

- Starship prompt
- direnv
- zoxide
- eza
- dmux
- opinionated tmux configuration

`tmux` itself is installed by the Unix `tools` module, but a custom tmux configuration has not yet been added. dmux is a separate developer-focused tool that uses tmux for parallel coding-agent and worktree sessions.

## SSH-key behavior

The Git module downloads public keys from:

```text
https://github.com/<github_username>.keys
```

It adds missing keys to `~/.ssh/authorized_keys` and does not download, create, copy, or expose private keys. This authorizes SSH access to the machine using keys already published on that GitHub account; it does not create a local key for pushing to GitHub.

## Safety and behavior

- Scripts are intended to be idempotent.
- Existing configuration files are preserved where practical.
- Managed sections are clearly marked and replaced on later runs.
- Modules can be run independently.
- User-specific values live in one shared JSON settings file.
