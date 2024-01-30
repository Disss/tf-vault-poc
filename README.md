## How to use
1. `docker run --cap-add=IPC_LOCK -e 'VAULT_DEV_ROOT_TOKEN_ID=myroot' -e 'VAULT_DEV_LISTEN_ADDRESS=0.0.0.0:8200' -p 8200:8200 docker.io/hashicorp/vault`
2. `tf plan`
3. `tf apply`