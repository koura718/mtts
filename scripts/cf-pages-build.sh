#!/bin/sh
set -eu

# Cloudflare Pages build script
# - Production (main branch): use config.production.toml (GA enabled)
# - Preview (other branches): use config.toml only (GA disabled)

MAIN_BRANCH="${MAIN_BRANCH:-main}"
BRANCH="${CF_PAGES_BRANCH:-}"
PAGES_URL="${CF_PAGES_URL:-}"

if [ -z "$PAGES_URL" ]; then
  # Fallback for local runs
  PAGES_URL="${HUGO_BASEURL:-http://localhost/}"
fi

# Ensure trailing slash for Hugo baseURL
case "$PAGES_URL" in
  */) BASEURL="$PAGES_URL" ;;
  *) BASEURL="$PAGES_URL/" ;;
esac

CONFIG_FILES="config.toml"
ENVIRONMENT="development"

if [ "$BRANCH" = "$MAIN_BRANCH" ]; then
  if [ -f "config.production.toml" ]; then
    CONFIG_FILES="config.toml,config.production.toml"
  fi
  ENVIRONMENT="production"
fi

echo "CF_PAGES_BRANCH=${BRANCH:-<unset>} (main=${MAIN_BRANCH})"
echo "Hugo environment: $ENVIRONMENT"
echo "BaseURL: $BASEURL"
echo "Config: $CONFIG_FILES"

hugo \
  --config "$CONFIG_FILES" \
  --environment "$ENVIRONMENT" \
  --baseURL "$BASEURL" \
  --gc \
  --minify
