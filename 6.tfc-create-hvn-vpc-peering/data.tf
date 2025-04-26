data "hcp_hvn" "hcp_hvn_id" {
  hvn_id = var.hvn_id
}

######################################################
# AWS VPC
########################################################
data "aws_vpc" "master_aws_vpc" {
  id = var.vpc_id
}

data "aws_arn" "vpc_arn" {
  arn = data.aws_vpc.master_aws_vpc.arn
}

data "aws_subnets" "all_subnets" {

}

data "aws_subnets" "private_subnet_ids" {
    filter {
    name   = "vpc-id"
    values = [var.vpc_id]
  }

  tags = {
    Name = "*private*"
  }
}

data "aws_subnet" "private_subnet" {
  for_each = toset(data.aws_subnets.private_subnet_ids.ids)
  id = each.value
}

data "aws_subnets" "db_subnet_ids" {
    filter {
    name   = "vpc-id"
    values = [var.vpc_id]
  }

  tags = {
    Name = "*db*"
  }
}

data "aws_subnet" "db_subnet" {
  for_each = toset(data.aws_subnets.db_subnet_ids.ids)
  id = each.value
}

# data "aws_subnet" "db_subnet" {
#   count = length(data.aws_subnets.db_subnet_ids.ids)
#   id = element(data.aws_subnets.db_subnet_ids.ids, count.index)
# }

data "aws_route_table" "private_rout_table" {
  subnet_id = data.aws_subnets.private_subnet_ids.ids[0]
}

data "aws_route_table" "db_rout_table" {
  subnet_id = data.aws_subnets.db_subnet_ids.ids[0]
}