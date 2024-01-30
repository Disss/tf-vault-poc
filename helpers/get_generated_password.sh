#!/usr/bin/env bash

export VAULT_ADDR="http://localhost:8200"
export VAULT_TOKEN="myroot"

# for the demostration purposes the policy creation is done on every script execution
curl -X 'POST' \
  "$VAULT_ADDR/v1/sys/policies/password/test" \
  -H 'accept: */*' \
  -H 'Content-Type: application/json' \
  -H 'X-Vault-Token: myroot' \
  -d '{
  "policy": "length = 20\nrule \"charset\" {charset=\"abcdefghijklmnopqrstuvwxyz\" min-chars = 1}\nrule \"charset\" {charset=\"abcdefghijklmnopqrstuvwxyz\" min-chars = 1}\nrule \"charset\" {charset=\"abcdefghijklmnopqrstuvwxyz\" min-chars = 1}\nrule \"charset\" {charset=\"-\" min-chars = 1}"
}'

curl -X 'GET' \
  "$VAULT_ADDR/v1/sys/policies/password/test/generate" \
  -H 'accept: application/json' \
  -H 'X-Vault-Token: myroot' \
  -s | jq ".data"
