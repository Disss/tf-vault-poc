locals {
  vault_prefix = "product"
  environment_name = "dev"
  db_name = "test"
  vault_path = "${local.vault_prefix}/${local.environment_name}/connections/${local.vault_prefix}_postgresql_${local.db_name}"
  db_password = data.external.user_secret.result.exists ? data.vault_generic_secret.user[0].data.password : data.external.password.result.password
}

data "external" "password" {
  program = ["bash", "${path.module}/helpers/get_generated_password.sh"]
}

data "external" "user_secret" {
  program = ["bash", "${path.module}/helpers/check_secret_existence.sh"]
  query = {
    secret_path = "${local.vault_path}"
  }
}

data "vault_generic_secret" "user" {
  count = data.external.user_secret.result.exists ? 1 : 0
  path = "secret/${local.vault_path}"
}

resource "vault_kv_secret_v2" "user" {
  mount = "secret"
  name = local.vault_path
  cas = 1
  delete_all_versions = true
  custom_metadata {
    max_versions = 5
  }

  data_json = jsonencode({
    password = sensitive(local.db_password)
  })
}

resource "local_file" "file" {
  content = sensitive(local.db_password)
  filename = "${path.module}/local"
}

output "password" {
  value = nonsensitive(local.db_password)
}
