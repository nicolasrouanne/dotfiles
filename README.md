# Dotfiles

Managed with [chezmoi](https://www.chezmoi.io/) and [1Password](https://1password.com/) for secrets.

## Prerequisites

- [chezmoi](https://www.chezmoi.io/install/) (`brew install chezmoi`)
- [1Password CLI](https://developer.1password.com/docs/cli/) (`brew install --cask 1password-cli`)
- 1Password app with CLI integration enabled (Settings > Developer > "Integrate with 1Password CLI")
- Access to the `Qraft` vault on `my.1password.eu`

## New machine setup

```bash
# Clone and apply dotfiles
chezmoi init --source ~/dev/dotfiles --apply https://github.com/nicolasrouanne/dotfiles.git

# Set the custom source directory in chezmoi config
mkdir -p ~/.config/chezmoi
cat > ~/.config/chezmoi/chezmoi.toml << 'EOF'
sourceDir = "/Users/nicolasrouanne/dev/dotfiles"

[onepassword]
  account = "my.1password.eu"
EOF
```

1Password will prompt for biometric auth on first `chezmoi apply`.

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

1. Create an item in 1Password (Qraft vault) named `chezmoi_<service>`
2. Rename the source file to `.tmpl` if not already (e.g. `dot_gitconfig` -> `dot_gitconfig.tmpl`)
3. Replace the hardcoded secret with:

```
{{ onepasswordRead "op://Qraft/chezmoi_<service>/<field>" "my.1password.eu" }}
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

Items are stored in the `Qraft` vault with the prefix `chezmoi_`:

| Item | Field | Usage |
|------|-------|-------|
| `chezmoi_notion` | `api_key` | Notion API key |
| `chezmoi_slack-qraft` | `user_token` | Slack Qraft workspace |
| `chezmoi_slack-episto` | `user_token` | Slack Episto workspace |

## File naming

chezmoi uses a naming convention for source files:

| Source file | Target |
|-------------|--------|
| `dot_zshrc.tmpl` | `~/.zshrc` (templated) |
| `dot_gitconfig` | `~/.gitconfig` (plain copy) |
| `private_dot_ssh/config` | `~/.ssh/config` (private permissions) |
