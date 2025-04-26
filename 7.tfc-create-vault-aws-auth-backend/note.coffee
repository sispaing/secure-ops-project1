Create a AWS IAM policy to allow Vault Dedicated to validate the identity of AWS services.
Create a AWS IAM user to allow Vault Dedicated to access your AWS resources.
Create AWS IAM role which will be assigned to AWS services and trusted by Vault Dedicated.
Enable the AWS auth method for Vault Dedicated.
Assign the AWS IAM user credentials to the AWS auth method configuration.
Configure a Vault Dedicated role to authenticate AWS services with a trusted AWS IAM role.
Validate the configuration using a EC2 instance and the Vault binary.