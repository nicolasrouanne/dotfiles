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
