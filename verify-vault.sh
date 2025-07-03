#!/bin/bash

# Config
VAULT_ADDR="http://localhost:8200"
VAULT_TOKEN="devroot"
VAULT_PATH="secret/siteminder/credentials"

# Set environment
export VAULT_ADDR
export VAULT_TOKEN

echo "🔍 Checking Vault at $VAULT_PATH ..."

# Query Vault
vault kv get "$VAULT_PATH" 2>/dev/null

# Check result
if [ $? -eq 0 ]; then
  echo "✅ Vault path exists and is accessible."
else
  echo "❌ No data found at $VAULT_PATH. Please run the init-vault script again."
fi
