#!/bin/bash

# Wait for Vault container to be ready
echo "⏳ Waiting for Vault to start..."
until curl -s http://localhost:8200/v1/sys/health | grep '"initialized":true' > /dev/null; do
  sleep 1
done
echo "✅ Vault is ready."

# Set Vault environment variables
export VAULT_ADDR='http://localhost:8200'
export VAULT_TOKEN='devroot'

# Enable KV secrets engine if not already enabled
if ! vault secrets list -format=json | grep -q '"secret/"'; then
  echo "🔐 Enabling KV secret engine at path 'secret/'..."
  vault secrets enable -path=secret kv
else
  echo "🔐 KV secret engine already enabled at 'secret/'"
fi

# Prompt user for password securely
read -s -p "Enter SiteMinder Password: " SITEMINDER_PASSWORD
echo

# Write password to Vault
vault kv put secret/siteminder/credentials password="$SITEMINDER_PASSWORD"

echo "✅ SiteMinder password stored in Vault at secret/siteminder/credentials"
