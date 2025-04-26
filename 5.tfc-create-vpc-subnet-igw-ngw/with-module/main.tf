
data "aws_availability_zones" "azs" {
  state = "available"
}

locals {
  azs = data.aws_availability_zones.azs.names
}

module "vpc" {
  source = "app.terraform.io/empower-sphere/create-vpc/aws"
  
  name = var.name
  cidr = var.cidr
  azs = local.azs
  tags = var.tags
  public_subnets = var.public_subnets
  map_public_ip_on_launch = var.map_public_ip_on_launch
  public_subnet_names = var.public_subnet_names
  private_subnets = var.private_subnets
  private_subnet_names = var.private_subnet_names
  database_subnets = var.database_subnets
  database_subnet_names = var.database_subnet_names
  create_database_subnet_route_table = var.create_database_subnet_route_table
  create_database_nat_gateway_route = var.create_database_nat_gateway_route
  create_database_subnet_group = var.create_database_subnet_group
  database_subnet_group_name = var.database_subnet_group_name
  create_igw = var.create_igw
  enable_nat_gateway = var.enable_nat_gateway
  single_nat_gateway = var.single_nat_gateway

}