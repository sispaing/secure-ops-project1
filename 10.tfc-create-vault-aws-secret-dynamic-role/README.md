# tfc-create-vault-aws-secret-dynamic-role


# Vault AWS Secret Engine Configuration

This Terraform configuration sets up a Vault AWS Secret Engine for managing secrets in an AWS Master Account and creates a dynamic role with specific IAM permissions.

## Resources

### 1. **Vault AWS Secret Backend (`vault_aws_secret_backend`)**:
   - **Description**: Configures the AWS Secret Engine in Vault to manage AWS credentials for the Master Account.
   - **Parameters**:
     - `description`: A brief description of the Vault AWS Secret Engine.
     - `access_key`: The AWS access key retrieved from the remote state of the `vault_admin` Terraform workspace.
     - `secret_key`: The corresponding AWS secret access key.
     - `region`: The AWS region specified by the `aws_region` variable.
     - `path`: The secret engine's path in Vault, specified by `master_secret_path` in the `secret_path` variable.
     - `default_lease_ttl_seconds`: The default time-to-live (TTL) for secrets issued by this backend, set to 600 seconds.
     - `max_lease_ttl_seconds`: The maximum TTL for secrets issued by this backend, set to 1800 seconds.
   - **Lifecycle Configuration**:
     - `ignore_changes`: Specifies to ignore changes in the `access_key` and `secret_key` attributes during updates.

### 2. **Vault AWS Secret Backend Role (`vault_aws_secret_backend_role`)**:
   - **Description**: Defines a dynamic role within the Vault AWS Secret Engine, which generates temporary AWS credentials.
   - **Parameters**:
     - `backend`: Specifies the path of the AWS Secret Engine where the role will be created.
     - `name`: The name of the role, specified by the `master_iamadmin_role_name` in the `secret_role_name` variable.
     - `credential_type`: The type of AWS credentials to be generated, defined by the `iam_user` in the `credential_type` variable.
     - `policy_arns`: The Amazon Resource Names (ARNs) of the IAM policies to be attached to the generated credentials, specified by the `iamadmin` value in the `policy_arns_name` variable.

## Usage

1. **Set Up Variables**: Ensure that the following variables are properly defined:
   - `vault_admin_accesskey`
   - `vault_admin_secret_accesskey`
   - `aws_region`
   - `master_secret_path`
   - `master_iamadmin_role_name`
   - `iam_user`
   - `iamadmin`

2. **Run Terraform Commands**:
   ```bash
   terraform init
   terraform apply
   ```

This will configure the Vault AWS Secret Engine and create the dynamic IAM role with the specified permissions.

## Prerequisites

- A configured Vault server with AWS Secret Engine enabled.
- AWS IAM credentials with permissions to create and manage IAM roles and policies.
- Terraform installed on your local machine.

## Outputs

- **Vault AWS Secret Backend**: The configured AWS Secret Engine in Vault.
- **Vault AWS Secret Backend Role**: The dynamic role created within the AWS Secret Engine that generates temporary AWS credentials.
