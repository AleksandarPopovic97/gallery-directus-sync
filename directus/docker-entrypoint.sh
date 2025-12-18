#!/bin/sh
set -e

EXT_DIR="/directus/extensions"

echo "=> Installing + building Directus extensions in: $EXT_DIR"

if [ -d "$EXT_DIR" ]; then
  for ext in "$EXT_DIR"/*; do
    [ -d "$ext" ] || continue
    [ -f "$ext/package.json" ] || continue

    echo "-> Extension: $(basename "$ext")"

    (
      cd "$ext"

      # Clean, predictable installs (avoid npm cache weirdness)
      npm config set fund false >/dev/null 2>&1 || true
      npm config set audit false >/dev/null 2>&1 || true

      # Install deps
      if [ -d node_modules ]; then
        echo "   deps already installed, skipping"
      else
        if [ -f package-lock.json ]; then
            npm ci --include=dev || npm install --include=dev
        else
            npm install --include=dev
        fi
      fi

      # Build
      npm run build
    )
  done
else
  echo "=> No extensions directory found, skipping build"
fi

echo "=> Running Directus core DB migrations..."
npx directus database migrate:latest

SCHEMA_FILE="/directus/schema/schema.json"
if [ -f "$SCHEMA_FILE" ]; then
  echo "=> Applying Directus schema from $SCHEMA_FILE..."
  npx directus schema apply "$SCHEMA_FILE" --yes || echo "!!! Schema apply failed, continuing"
fi

echo "=> Starting Directus..."
exec npx directus start
