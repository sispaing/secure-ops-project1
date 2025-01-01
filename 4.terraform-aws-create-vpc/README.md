# tfc-create-vpc-subnet-igw-ngw

## Overview

This Terraform module creates an AWS Virtual Private Cloud (VPC) along with associated subnets, an Internet Gateway (IGW), and a NAT Gateway (NGW). This setup is commonly used for deploying AWS infrastructure that requires public and private subnets with internet access.

## Features

- Creates a VPC with a customizable CIDR block.
- Creates multiple public and private subnets across different Availability Zones.
- Attaches an Internet Gateway (IGW) to the VPC.
- Deploys a NAT Gateway (NGW) in each public subnet for private subnet internet access.
- Configures route tables for public and private subnets.

## Architecture

The module creates the following architecture:

- **VPC**: A single VPC spanning multiple availability zones.
- **Public Subnets**: Subnets with a route to the Internet Gateway for public-facing resources.
- **Private Subnets**: Subnets with a route to the NAT Gateway for private resources that need internet access.
- **Database Subnets and Database Subnet Group**: Subnets with a route to the NAT Gateway for database resources that need internet access.
- **Internet Gateway (IGW)**: Enables internet access for public subnets.
- **NAT Gateway (NGW)**: Allows private subnets to access the internet while keeping resources private.

## Usage

To use this module, include it in your Terraform configuration as follows:

```hcl
module "vpc" {
  source = "path_to_your_module/tfc-create-vpc-subnet-igw-ngw"

  vpc_cidr            = "10.0.0.0/16"
  public_subnet_cidrs = ["10.0.1.0/24", "10.0.2.0/24"]
  private_subnet_cidrs = ["10.0.3.0/24", "10.0.4.0/24"]
  azs                 = ["us-east-1a", "us-east-1b"]

  enable_nat_gateway  = true
  single_nat_gateway  = true
  igw_tags            = {
    Name = "my-igw"
  }
  ngw_tags            = {
    Name = "my-ngw"
  }
}
```

### Inputs

| Name                 | Description                                                             | Type     | Default     | Required |
|----------------------|-------------------------------------------------------------------------|----------|-------------|----------|
| `vpc_cidr`           | The CIDR block for the VPC.                                             | `string` | `""`        | Yes      |
| `public_subnet_cidrs`| A list of CIDR blocks for public subnets.                               | `list`   | `[]`        | Yes      |
| `private_subnet_cidrs`| A list of CIDR blocks for private subnets.                              | `list`   | `[]`        | Yes      |
| `azs`                | A list of availability zones to use for subnets.                        | `list`   | `[]`        | Yes      |
| `enable_nat_gateway` | Whether to create a NAT Gateway.                                        | `bool`   | `true`      | No       |
| `single_nat_gateway` | Whether to use a single NAT Gateway for all private subnets.            | `bool`   | `false`     | No       |
| `igw_tags`           | A map of tags to apply to the Internet Gateway.                         | `map`    | `{}`        | No       |
| `ngw_tags`           | A map of tags to apply to the NAT Gateway.                              | `map`    | `{}`        | No       |

### Outputs

| Name            | Description                                       |
|-----------------|---------------------------------------------------|
| `vpc_id`        | The ID of the VPC.                                 |
| `public_subnets`| A list of IDs for the public subnets.              |
| `private_subnets`| A list of IDs for the private subnets.             |
| `igw_id`        | The ID of the Internet Gateway.                    |
| `nat_gateway_ids`| A list of IDs for the NAT Gateways.               |

## Examples

Here is an example of how you can use this module to create a VPC with two public and two private subnets, an Internet Gateway, and a NAT Gateway:

```hcl
module "vpc" {
  source = "path_to_your_module/tfc-create-vpc-subnet-igw-ngw"

  vpc_cidr            = "10.0.0.0/16"
  public_subnet_cidrs = ["10.0.1.0/24", "10.0.2.0/24"]
  private_subnet_cidrs = ["10.0.3.0/24", "10.0.4.0/24"]
  azs                 = ["us-west-2a", "us-west-2b"]

  enable_nat_gateway  = true
  single_nat_gateway  = false

  igw_tags = {
    Name = "example-igw"
  }

  ngw_tags = {
    Name = "example-ngw"
  }
}
```

## License

This project is licensed under the MIT License. See the [LICENSE](LICENSE) file for details.

## Authors

This module is maintained by [Your Name] and [Contributors].
