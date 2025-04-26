##################################################
# VPC
##################################################
variable "name" {
  description = "(Require) Name to be used on all the resources as identifier"
  type        = string
  default     = "hellocloud-master-vpc"
}

variable "cidr" {
  description = "(Optional) The IPv4 CIDR block for the VPC. CIDR can be explicitly set"
  type        = string
  default     = "10.10.0.0/16"
}

variable "instance_tenancy" {
  description = "(Optional) A tenancy option for instances launched into the VPC"
  type        = string
  default     = "default"
}

variable "azs" {
  description = "(Require) A list of availability zones names or ids in the region"
  type        = list(string)
  default     = []
}

variable "enable_dns_hostnames" {
  description = "Should be true to enable DNS hostnames Default: `true`"
  type        = bool
  default     = true
}

variable "enable_dns_support" {
  description = "Should be true to enable DNS support Default: `true`"
  type        = bool
  default     = true
}


variable "tags" {
  description = "A map of tags to add to all resources"
  type        = map(string)
  default     = {
    "Environment" = "production"
    "Project"     = "tfc-vault-secret-management-project"
    "Owner"       = "network-team"
  }
}

################################################################################
# Publiс Subnets
################################################################################

variable "public_subnets" {
  description = "A list of public subnets"
  type        = list(string)
  default     = ["10.10.1.0/24", "10.10.2.0/24", "10.10.3.0/24"]
}

variable "create_multiple_public_route_tables" {
  description = "Indicates whether to create a separate route table for each public subnet. Default: `false`"
  type        = bool
  default     = false
}

variable "map_public_ip_on_launch" {
  description = "Specify true to indicate that instances launched into the subnet should be assigned a public IP address. Default is `false`"
  type        = bool
  default     = true
}

variable "public_subnet_names" {
  description = "Explicit values to use in the Name tag on public subnets."
  type        = list(string)
  default     = ["public-subnet01", "public-subnet02", "public-subnet03"]
}

variable "public_subnet_suffix" {
  description = "Suffix to append to public subnets name"
  type        = string
  default     = "public"
}



################################################################################
# Private Subnets
################################################################################

variable "private_subnets" {
  description = "A list of private subnets"
  type        = list(string)
  default     = ["10.10.4.0/24", "10.10.5.0/24", "10.10.6.0/24"]
}

variable "private_subnet_names" {
  description = "Explicit values to use in the Name tag on private subnets."
  type        = list(string)
  default     = ["private-subnet01", "private-subnet02", "private-subnet03"]
}

variable "private_subnet_suffix" {
  description = "Suffix to append to private subnets name"
  type        = string
  default     = "private"
}


################################################################################
# Database Subnets
################################################################################

variable "database_subnets" {
  description = "A list of database subnets inside the VPC"
  type        = list(string)
  default     = ["10.10.7.0/24", "10.10.8.0/24", "10.10.9.0/24"]
}

variable "database_subnet_names" {
  description = "Explicit values to use in the Name tag on database subnets. If empty, Name tags are generated"
  type        = list(string)
  default     = ["db-subnet01", "db-subnet02", "db-subnet03"]
}

variable "database_subnet_suffix" {
  description = "Suffix to append to database subnets name"
  type        = string
  default     = "db"
}



variable "database_subnet_group_name" {
  description = "Name of database subnet group"
  type        = string
  default     = "db-subnet-group"
}


################################################################################
# NAT Gateway
################################################################################

variable "nat_gateway_destination_cidr_block" {
  description = "Used to pass a custom destination route for private NAT Gateway. If not specified, the default 0.0.0.0/0 is used as a destination route"
  type        = string
  default     = "0.0.0.0/0"
}

##############################################
#Vault
##############################################

variable "aws_secret_backend_path" {
  description = "aws_secret_backend_path"
  type        = string
  default = "aws-master-account"
}

variable "aws_netadmin_role_name" {
  description = "aws_secret_backend_path"
  type        = string
  default = "master-networkadmin-role"
}

