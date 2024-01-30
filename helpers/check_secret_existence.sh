#!/usr/bin/env bash

export VAULT_ADDR="http://localhost:8200"
export VAULT_TOKEN="myroot"

eval "$(jq -r '@sh "SECRET_PATH=\(.secret_path)"')"

RESULT=""
if vault kv get -mount="secret" -field=password "$SECRET_PATH" >/dev/null 2>&1; then
    RESULT="true"
else
    RESULT="false"
fi

jq -n --arg exists "$RESULT" '{"exists":$exists}'