# Dotfiles

Managed with [chezmoi](https://www.chezmoi.io/) and [1Password](https://1password.com/) for secrets.

## Prerequisites

- [chezmoi](https://www.chezmoi.io/install/) (`brew install chezmoi`)
- [1Password CLI](https://developer.1password.com/docs/cli/) (`brew install --cask 1password-cli`)
- 1Password service account token stored in macOS Keychain (account: `sa-claude-code`, service: `1password-service-account`)

## New machine setup

```bash
# 1. Store the service account token in Keychain
security add-generic-password -a "sa-claude-code" -s "1password-service-account" -w "<token>"

# 2. Export it for the initial chezmoi run
export OP_SERVICE_ACCOUNT_TOKEN=$(security find-generic-password -a "sa-claude-code" -s "1password-service-account" -w)

# 3. Init and apply
chezmoi init --apply https://github.com/nicolasrouanne/dotfiles.git
```

This will:
1. Clone the repo into `~/dev/dotfiles` (configured via `.chezmoi.toml.tmpl`)
2. Generate `~/.config/chezmoi/chezmoi.toml` with 1Password in service mode
3. Apply all dotfiles, reading secrets via the service account

## Daily usage

### Check what would change

```bash
chezmoi diff
```

### Apply changes

```bash
chezmoi apply
```

### Edit a managed file

```bash
chezmoi edit ~/.zshrc
```

This opens the **template** in your editor. After saving, run `chezmoi apply` to write the resolved file.

### Add a new file

```bash
chezmoi add ~/.gitconfig
```

This copies the file into `~/dev/dotfiles/`. If the file contains secrets, rename it to `.tmpl` and replace secrets with 1Password references (see below).

### Add a secret

1. Create an item in 1Password (`AI Agents` vault) named `chezmoi_<service>`
2. Rename the source file to `.tmpl` if not already (e.g. `dot_gitconfig` -> `dot_gitconfig.tmpl`)
3. Replace the hardcoded secret with:

```
{{ onepasswordRead "op://AI Agents/chezmoi_<service>/<field>" }}
```

### Commit and push changes

```bash
cd ~/dev/dotfiles
git add -A
git commit -m "Add/update <what changed>"
git push
```

### Pull changes from another machine

```bash
chezmoi update
```

## Detect drift

Over time, this machine can drift from the repo: a formula installed manually, an app's settings tweaked in its UI, etc. The `dotfiles-doctor` script (installed at `~/.local/bin/dotfiles-doctor`) reports both directions of drift.

```bash
dotfiles-doctor
```

It checks:

- **chezmoi**: files under `~` that differ from the source state (a `chezmoi diff` summary)
- **Brewfile**: formulas/casks installed top-level but missing from `Brewfile`, and the reverse

Exit code is `1` on drift, `0` if clean — usable in scripts.

### Weekly check via launchd

A LaunchAgent (`com.nicolasrouanne.dotfiles-doctor`) is included to run the doctor every Monday at 09:00 and show a macOS notification if drift is found. Load it once per machine:

```bash
launchctl load ~/Library/LaunchAgents/com.nicolasrouanne.dotfiles-doctor.plist
```

Run it manually to test:

```bash
launchctl start com.nicolasrouanne.dotfiles-doctor
```

Stop / unload:

```bash
launchctl unload ~/Library/LaunchAgents/com.nicolasrouanne.dotfiles-doctor.plist
```

Logs are at `/tmp/dotfiles-doctor.log` and `/tmp/dotfiles-doctor.err`.

### Reconciling drift

Once the doctor reports drift, decide direction per item:

- **Source repo → machine** (the repo is authoritative): `chezmoi apply`, or for missing brew packages `brew bundle --file ~/dev/dotfiles/Brewfile`.
- **Machine → source repo** (the machine is authoritative): `chezmoi re-add <path>` for files, or edit `Brewfile` by hand and commit.

## 1Password naming convention

Items are stored in the `AI Agents` vault with the prefix `chezmoi_`:

| Item | Field | Usage |
|------|-------|-------|
| `chezmoi_notion_personal` | `api_key` | Notion API key (personal workspace) |
| `chezmoi_notion_work` | `api_key` | Notion API key (work workspace) |
| `chezmoi_slack-qraft` | `user_token` | Slack Qraft workspace |
| `chezmoi_slack-episto` | `user_token` | Slack Episto workspace |
| `chezmoi_toggl` | `api_token` | Toggl time tracking |
| `chezmoi_langfuse` | `public_key`, `secret_key` | Langfuse observability |

## File naming

chezmoi uses a naming convention for source files:

| Source file | Target |
|-------------|--------|
| `dot_zshrc.tmpl` | `~/.zshrc` (templated) |
| `dot_gitconfig` | `~/.gitconfig` (plain copy) |
| `private_dot_ssh/config` | `~/.ssh/config` (private permissions) |
