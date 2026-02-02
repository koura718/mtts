#!/bin/sh
set -eu

MAIN_BRANCH="${MAIN_BRANCH:-main}"
BRANCH="${CF_PAGES_BRANCH:-}"
PAGES_URL="${CF_PAGES_URL:-}"

# ★本番の正規URL（独自ドメイン）を環境変数で渡せるようにする
PROD_BASEURL="${PROD_BASEURL:-https://mizuki-tts.com/}"

# local fallback
if [ -z "$PAGES_URL" ]; then
  PAGES_URL="${HUGO_BASEURL:-http://localhost/}"
fi

CONFIG_FILES="config.toml"
ENVIRONMENT="development"

# branch判定
if [ "$BRANCH" = "$MAIN_BRANCH" ]; then
  if [ -f "config.production.toml" ]; then
    CONFIG_FILES="config.toml,config.production.toml"
  fi
  ENVIRONMENT="production"
  BASEURL="$PROD_BASEURL"
else
  BASEURL="$PAGES_URL"
fi

# Ensure trailing slash
case "$BASEURL" in
  */) : ;;
  *) BASEURL="$BASEURL/" ;;
esac

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
