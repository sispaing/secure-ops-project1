locals {
  len_public_subnets   = length(var.public_subnets)
  len_private_subnets  = length(var.private_subnets)
  len_database_subnets = length(var.database_subnets)
}

data "aws_availability_zones" "azs" {
  state = "available"
}

##################################################
# VPC
##################################################

resource "aws_vpc" "main" {
  cidr_block           = var.cidr
  instance_tenancy     = var.instance_tenancy
  enable_dns_hostnames = var.enable_dns_hostnames
  enable_dns_support   = var.enable_dns_support

  tags = merge(
    { "Name" = var.name },
    var.tags
  )
}


################################################################################
# Publiс Subnets
################################################################################

resource "aws_subnet" "public" {
  count                   = local.len_public_subnets
  vpc_id                  = aws_vpc.main.id
  availability_zone       = data.aws_availability_zones.azs.names[count.index]
  cidr_block              = var.public_subnets[count.index]
  map_public_ip_on_launch = var.map_public_ip_on_launch

  tags = merge(
    { "Name" = "${var.name}-${var.public_subnet_suffix}-${element(data.aws_availability_zones.azs.names, count.index)}" },
    var.tags,
  )
}

resource "aws_route_table" "public" {
  vpc_id = aws_vpc.main.id
  tags = merge(
    { "Name" = "${var.name}-${var.public_subnet_suffix}${element(data.aws_availability_zones.azs.names, 0)}" },
    var.tags
  )
}

resource "aws_route_table_association" "public" {
  count          = local.len_public_subnets
  route_table_id = aws_route_table.public.id
  subnet_id      = aws_subnet.public[count.index].id
}

resource "aws_route" "public_internet_gateway" {
  route_table_id         = aws_route_table.public.id
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = aws_internet_gateway.this.id
  timeouts {
    create = "5m"
  }
}

################################################################################
# Private Subnets
################################################################################

resource "aws_subnet" "private" {
  count             = local.len_private_subnets
  vpc_id            = aws_vpc.main.id
  availability_zone = data.aws_availability_zones.azs.names[count.index]
  cidr_block        = var.private_subnets[count.index]

  tags = merge(
    { "Name" = "${var.name}-${var.private_subnet_suffix}-${element(data.aws_availability_zones.azs.names, count.index)}" },
    var.tags
  )
}

resource "aws_route_table" "private" {
  vpc_id = aws_vpc.main.id
  tags = merge(
    { "Name" = "${var.name}-${var.private_subnet_suffix}-${data.aws_availability_zones.azs.names[0]}" },
    var.tags,
  )
}

resource "aws_route_table_association" "private" {
  count          = local.len_private_subnets
  route_table_id = aws_route_table.private.id
  subnet_id      = element(aws_subnet.private[*].id, count.index)
}


resource "aws_route" "private_nat_gateway" {
  route_table_id         = aws_route_table.private.id
  destination_cidr_block = var.nat_gateway_destination_cidr_block
  nat_gateway_id         = aws_nat_gateway.nat.id
  timeouts {
    create = "5m"
  }
}

################################################################################
# Database Subnets
################################################################################

resource "aws_subnet" "database" {
  count             = local.len_database_subnets
  vpc_id            = aws_vpc.main.id
  availability_zone = data.aws_availability_zones.azs.names[count.index]
  cidr_block        = var.database_subnets[count.index]

  tags = merge(
    { "Name" = "${var.name}-${var.database_subnet_suffix}-${data.aws_availability_zones.azs.names[count.index]}" },
    var.tags
  )
}

resource "aws_db_subnet_group" "database" {
  name        = var.database_subnet_group_name
  description = "Database subnet group for ${var.name}"
  subnet_ids  = aws_subnet.database[*].id
  tags = merge(
    {
      "Name" = lower(var.database_subnet_group_name)
    },
    var.tags
  )
}

resource "aws_route_table" "database" {
  vpc_id = aws_vpc.main.id

  tags = merge(
    { "Name" = lower(var.database_subnet_group_name) },
    var.tags,
  )
}

resource "aws_route_table_association" "database" {
  count          = local.len_database_subnets
  route_table_id = aws_route_table.database.id
  subnet_id      = aws_subnet.database[count.index].id
}


resource "aws_route" "database_nat_gateway" {
  route_table_id         = aws_route_table.database.id
  destination_cidr_block = "0.0.0.0/0"
  nat_gateway_id         = aws_nat_gateway.nat.id
  timeouts {
    create = "5m"
  }
}

################################################################################
# Internet Gateway
################################################################################

resource "aws_internet_gateway" "this" {
  vpc_id = aws_vpc.main.id
  tags = merge(
    { "Name" = var.name },
    var.tags,
  )
}

################################################################################
# NAT Gateway
################################################################################

resource "aws_eip" "nat" {
  domain = "vpc"
  tags = merge(
    {
      "Name" = format(
        "${var.name}-%s",
      data.aws_availability_zones.azs.names[0])
    },
    var.tags,
  )
  depends_on = [aws_internet_gateway.this]
}

resource "aws_nat_gateway" "nat" {
  allocation_id = aws_eip.nat.id
  subnet_id = element(
    aws_subnet.public[*].id, 0
  )
  tags = merge(
    {
      "Name" = format(
        "${var.name}-%s",
      data.aws_availability_zones.azs.names[0])
    },
    var.tags,
  )

  depends_on = [aws_internet_gateway.this]
}