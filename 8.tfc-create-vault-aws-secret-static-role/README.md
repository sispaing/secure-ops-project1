# tfc-create-vault-aws-secret-static-role

# Terraform Configuration for AWS IAM Users and Vault Static Roles

This Terraform configuration automates the creation of AWS IAM users, their corresponding access keys, and the association of these users with static roles in Vault. The setup utilizes the `count` meta-argument to dynamically generate resources based on the number of users specified in the `user_list` variable.

## Resources

### 1. **AWS IAM User (`aws_iam_user`)**
   - **Description**: Creates an IAM user for each entry in the `user_list` variable.
   - **Key Attributes**:
     - `count`: The number of IAM users to create, determined by the length of `user_list`.
     - `name`: Sets the IAM username based on the entries in `user_list`.
     - `path`: Specifies the path for each IAM user, set to `/`.
     - `tags`: Adds a tag to each IAM user with their corresponding name.

### 2. **AWS IAM Access Key (`aws_iam_access_key`)**
   - **Description**: Generates an access key for each IAM user created.
   - **Key Attributes**:
     - `count`: Matches the number of access keys to the number of IAM users created.
     - `user`: Associates each access key with its corresponding IAM user.
   - **Lifecycle Configuration**:
     - `ignore_changes`: Ignores changes to the `user` attribute, ensuring stability in the resource configuration.

### 3. **AWS IAM Policy Document (`aws_iam_policy_document`)**
   - **Description**: Defines an inline IAM policy that grants permission to use the `iam:GetUser` action for all IAM users.
   - **Key Attributes**:
     - `statement`: Specifies the policy statement allowing the `iam:GetUser` action for all users within the AWS account.

### 4. **AWS IAM User Policy (`aws_iam_user_policy`)**
   - **Description**: Attaches the inline policy to each IAM user created.
   - **Key Attributes**:
     - `count`: Ensures that the number of policies matches the number of IAM users.
     - `name`: Defines the policy name based on the `inline_po_name` variable.
     - `user`: Attaches the policy to each corresponding IAM user.
     - `policy`: Links to the policy document created in the `aws_iam_policy_document` resource.

### 5. **Vault AWS Secret Backend Static Role (`vault_aws_secret_backend_static_role`)**
   - **Description**: Creates a static role in Vault for each IAM user, enabling credential rotation.
   - **Key Attributes**:
     - `count`: Matches the number of static roles to the number of IAM users created.
     - `backend`: Specifies the path of the Vault AWS Secret Backend where the static role will be configured.
     - `name`: Sets the static role name based on the entries in `user_list`.
     - `username`: Links the static role to the corresponding IAM username.
     - `rotation_period`: Defines the period after which the credentials are rotated, specified by the `rotation_period` variable.

## Prerequisites

- **AWS Account**: Ensure you have an AWS account with the necessary IAM permissions.
- **Vault Server**: A Vault server with AWS Secret Engine enabled.
- **Terraform**: Installed on your local machine.

## Usage

1. **Configure Variables**: Ensure the following variables are defined:
   - `user_list`: A list of IAM usernames to create.
   - `inline_po_name`: The name for the inline policy.
   - `rotation_period`: The duration for credential rotation.
   - `backend_path`: The path to the Vault AWS Secret Backend.

2. **Initialize and Apply**:
   ```bash
   terraform init
   terraform apply