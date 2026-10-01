# The variables every shell, CLI and agent reads, as 1Password secret references resolved by `op inject`.
# Laptop: chezmoi writes them to ~/.config/env.sh, which .zshrc sources. orca-host: ENV_TEMPLATE points at this
# file. No secret here: one export per variable, its value a secret reference.
# Not a chezmoi template: chezmoi's double braces would clash with op's.

# Default 1Password vault for secret references (e.g. project Makefiles)
export OP_VAULT="AI Agents"

# Notion API keys for Claude Code MCP integration
export NOTION_TOKEN_PERSONAL="{{ op://AI Agents/chezmoi_notion_personal/api_key }}"
export NOTION_TOKEN_WORK="{{ op://AI Agents/chezmoi_notion_work/api_key }}"

# Slack MCP tokens
export SLACK_QRAFT_USER_TOKEN="{{ op://AI Agents/chezmoi_slack-qraft/user_token }}"
export SLACK_EPISTO_USER_TOKEN="{{ op://AI Agents/chezmoi_slack-episto/user_token }}"

# Toggl
export TOGGL_API_TOKEN="{{ op://AI Agents/chezmoi_toggl/api_token }}"

# Langfuse API keys
export LANGFUSE_PUBLIC_KEY="{{ op://AI Agents/chezmoi_langfuse/public_key }}"
export LANGFUSE_SECRET_KEY="{{ op://AI Agents/chezmoi_langfuse/secret_key }}"

# Qonto (qraft) — used by the Qonto MCP server
export QONTO_QRAFT_API_KEY="{{ op://AI Agents/chezmoi_qonto_qraft/api_key }}"
export QONTO_QRAFT_ORGANIZATION_ID="{{ op://AI Agents/chezmoi_qonto_qraft/organization_id }}"

# Qonto (gybe) — scoped to avoid mixing with the Qraft org
export QONTO_GYBE_API_KEY="{{ op://AI Agents/chezmoi_qonto_gybe/api_key }}"
export QONTO_GYBE_ORGANIZATION_ID="{{ op://AI Agents/chezmoi_qonto_gybe/organization_id }}"

# Cloudflare (episto) — scoped to avoid leaking into other CF accounts
export CLOUDFLARE_EPISTO_API_TOKEN="{{ op://AI Agents/chezmoi_cloudflare-episto/api_token }}"
export CLOUDFLARE_EPISTO_ACCOUNT_ID="{{ op://AI Agents/chezmoi_cloudflare-episto/account_id }}"

# Cloudflare (qraft, dedicated agents account) — R2 bucket qraft-routines
export CLOUDFLARE_QRAFT_ACCOUNT_ID="{{ op://AI Agents/chezmoi_cloudflare-qraft/account_id }}"
export CLOUDFLARE_QRAFT_R2_TOKEN="{{ op://AI Agents/chezmoi_cloudflare-qraft/api_token }}"

# Cloudflare (jacanda) — R2 bucket jacanda, zone jacanda.ai
export CLOUDFLARE_JACANDA_ACCOUNT_ID="{{ op://AI Agents/chezmoi_cloudflare-jacanda/account_id }}"
export CLOUDFLARE_JACANDA_API_TOKEN="{{ op://AI Agents/chezmoi_cloudflare-jacanda/api_token }}"

# Post-bridge MCP credentials
export POST_BRIDGE_API_KEY="{{ op://AI Agents/chezmoi_postbridge/API key }}"

# PostHog
export POSTHOG_API_KEY="{{ op://AI Agents/chezmoi_posthog/API key }}"
