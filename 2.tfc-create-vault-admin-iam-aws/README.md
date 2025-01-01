# tfc-create-vault-admin-iam-aws

# AWS IAM User and Policy Setup for Vault Admin

This Terraform configuration creates an AWS IAM user with the necessary access keys and attaches an inline policy that grants the user permissions to manage IAM users, particularly those related to Vault.

## Resources

1. **AWS IAM User (`aws_iam_user`)**:
   - **Purpose**: Creates an IAM user specifically for Vault administration.
   - **Parameters**:
     - `name`: The name of the IAM user, specified by the `user_name` variable.
     - `path`: The path under which the user is created, set to the root path `/`.
     - `tags`: Tags the IAM user with the name provided in the `user_name` variable.

2. **AWS IAM Access Key (`aws_iam_access_key`)**:
   - **Purpose**: Generates an access key for the IAM user to enable programmatic access.
   - **Parameters**:
     - `user`: Associates the access key with the IAM user created earlier.
     - **Lifecycle Configuration**:
       - `ignore_changes`: Ignores changes to the `user` attribute to prevent unnecessary updates.

3. **AWS IAM Policy Document (`aws_iam_policy_document`)**:
   - **Purpose**: Defines an inline policy that grants permissions for various IAM actions on users that follow the naming pattern `vault-*`.
   - **Statements**:
     - `effect`: Set to "Allow" to permit the actions listed.
     - `actions`: A list of IAM actions the policy allows, including creating, deleting, and managing users and access keys.
     - `resources`: Restricts the policy to affect only IAM users with names that match the pattern `vault-*`.

4. **AWS IAM User Policy (`aws_iam_user_policy`)**:
   - **Purpose**: Attaches the inline policy defined above to the IAM user.
   - **Parameters**:
     - `name`: The name of the policy, specified by the `inline_po_name` variable.
     - `user`: Associates the policy with the IAM user created earlier.
     - `policy`: The JSON representation of the policy document created by the `aws_iam_policy_document` resource.

## Usage

1. **Set Up Variables**: Ensure the variables `user_name` and `inline_po_name` are defined with appropriate values.
2. **Run Terraform Commands**:
   ```bash
   terraform init
   terraform apply
   ```

This will create the IAM user, generate the access keys, and attach the specified inline policy.

## Prerequisites

- An AWS account with sufficient permissions to create IAM users, policies, and access keys.
- Terraform installed on your local machine.

## Outputs

- **IAM User**: The IAM user created for Vault administration.
- **Access Key**: The access key associated with the IAM user, which can be used for programmatic access.
- **Policy**: The inline policy granting permissions to manage Vault-related IAM users.

