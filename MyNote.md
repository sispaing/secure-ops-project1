Creating VAULT Cluster and Necessary Set up for Git, HCP, TFC

1. Setup Git repo for project.

2. Create Workspace to create HCP Vault Cluster in HCP Terraform.
   - Connection between Git Hub and Terraform Cloud(TFC).
   - Create new workspace > Version Control Workflow > Github(Custom) > Register a new Outh Application > Authorize Application.
     Github > Setting > Developer Settings > OAuth Apps > New Auth App > Copy  & paste from TFC new Outh Application > Register Application

3. Create Service Prinicipal key from Hashicop Cloud Platform. Create env variable set at Terrfarom Cloud for this serice principal key.
Service Principal Key (Harshicorp Cloud)
Client ID - IsbGx9wZMZ9GStB4w7zf84LuTQVWQDSF
Client Secret - 4yGqYB2ryEEnm1WmFX_8CZLH_IGV9kSUMP23Qp24fp-xwrfH6Wt9p0DHMi6C_hC- 

4. Write terraform code for HCP Vault cluster. Push to Git repo.

5. Create and run workspace(1.tfc-create-hcp-vault-cluster) for HCP vault cluster. Check env variables(hcp service principal key inside workspace). If don't have, please add it.
   HCP_CLIENT_ID : IsbGx9wZMZ9GStB4w7zf84LuTQVWQDSF 
   HCP_CLIENT_SECRET : 4yGqYB2ryEEnm1WmFX_8CZLH_IGV9kSUMP23Qp24fp-xwrfH6Wt9p0DHMi6C_hC- 

6. Create Vault Cluster root token from TFC GUI. Export as env variable in your pc to get access to this vault cluster.
   export VAULT_ADDR=""
   export VAULT_TOKEN=""
   # env | grep VAULT
   # vault status             -- Check accessable to vault cluster
   # vault token lookup       -- Check root token or token got access to which policy

------------------------------------------------------------------------------------------
Enable JWT Auth, Config , role and policy.
7. Enable JWT auth method on Vault cluster
https://developer.hashicorp.com/terraform/cloud-docs/workspaces/dynamic-provider-credentials/vault-configuration

Manual Way
   # vault auth enable jwt
   # vault auth list         -- verify jwt auth enable or not
   # vault write auth/jwt/config \
    oidc_discovery_url="https://app.terraform.io" \
    bound_issuer="https://app.terraform.io"
   # vault read auth/jwt/config     -- check and verify vault auth config
   Create JWT Auth role and attach to a policy.
   - Create a policy
Policy
https://developer.hashicorp.com/vault/tutorials/policies/policies
# vi admin-policy.hcl
# vault policy write tfc-admin-policy tfc-admin-policy.hcl
# vault policy list
# vault policy read admin-policy
Role
# vi jwt-auth-admin-role.json
# vault wirte /auth/jwt/role/tfc-admin-role @tfc-admin-role.json
# vault list auth/jwt/role      -- how many role are there
# vault read /auth/jwt/role/tfc-admin-role

Disable JWT Auth Manual way and write terraform code.
# vault auth disable jwt
Check from GUI or
# vault auth list

8. Write Terraform code
https://registry.terraform.io/providers/hashicorp/vault/latest/docs/resources/jwt_auth_backend
Search vault provider terraform
Under vault_jwt_auth_backend

Vault Config 
resource "vault_jwt_auth_backend" "main" {
    description         = "Terraform dynamic provider credential"
    path                = "jwt"
    oidc_discovery_url  = "https://app.terraform.io"
    bound_issuer        = "https://app.terraform.io"
}

Policy
resource "vault_policy" "main" {
  name = "admin-policy"

  policy = <<EOT
path "auth/*"
{
  capabilities = ["create", "read", "update", "delete", "list", "sudo"]
}

# Create, update, and delete auth methods
path "sys/auth/*"
{
  capabilities = ["create", "update", "delete", "sudo"]
}

# List auth methods
path "sys/auth"
{
  capabilities = ["read"]
}

path "sys/mounts/example/"
{
  capabilities = ["create", "read", "update", "patch", "delete", "list"]
}
path "example/*"
{
  capabilities = ["create", "read", "update", "patch", "delete", "list"]
}
EOT
}

Role
resource "vault_jwt_auth_backend_role" "admin" {
  backend         = vault_jwt_auth_backend.main.path
  role_name       = "tfc-admin-role"
  token_policies  = [vault_policy.main.name]

  bound_audiences = [var.tfc_vault-audience]
  bound_claims_type": "glob"
  bound_claims = {
    sub = "organization:nick-hellocloud-tf-org:project:secure-ops-project1:workspace:*:run_phase:*"
  }
  user_claim      = "terraform_full_workspace"
  role_type       = "jwt"
  token_ttl       = " 1200"

Output
output "tfc_admin_role_name" {
  description = "tfc-admin-role-output"
  value =vault_jwt_auth_backend_role.admin.role_name
}

output "bound_claims" {
  description = "tfc-admin-role-bound-claims-output"
  value = vault_jwt_auth_backend_role.admin.bound_claims
}

Create Workspace and add variables
VAULT_ADDR=
VAULT_TOKEN=
