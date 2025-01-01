locals {
  len_public_subnets   = length(var.public_subnets)
  len_private_subnets  = length(var.private_subnets)
  len_database_subnets = length(var.database_subnets)
  len_intra_subnets = length(var.intra_subnets)

  max_subnet_length = max(
    local.len_public_subnets,
    local.len_private_subnets,
    local.len_database_subnets,
    local.len_intra_subnets
  )
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
    var.tags,
    var.vpc_tags,
  )
}

################################################################################
# Publiс Subnets
################################################################################

locals {
  create_public_subnets = local.len_public_subnets > 0
}

resource "aws_subnet" "public" {
  count                   = local.create_public_subnets ? local.len_public_subnets : 0
  vpc_id                  = aws_vpc.main.id
  availability_zone       = var.azs[count.index]
  cidr_block              = var.public_subnets[count.index]
  map_public_ip_on_launch = var.map_public_ip_on_launch

  tags = merge(
    { "Name" = "${var.name}-${var.public_subnet_suffix}-${element(var.azs, count.index)}" },
    var.tags,
    var.public_subnet_tags,
  )
}

locals {
  num_public_route_tables = var.create_multiple_public_route_tables ? local.len_public_subnets : 1
}

resource "aws_route_table" "public" {
  count  = local.create_public_subnets ? local.num_public_route_tables : 0
  vpc_id = aws_vpc.main.id
  tags = merge(
    { "Name" = "${var.name}-${var.public_subnet_suffix}-${element(var.azs, count.index)}" },
    var.tags,
    var.public_route_table_tags,
  )
}

resource "aws_route_table_association" "public" {
  count          = local.create_public_subnets ? local.len_public_subnets : 0
  route_table_id = element(aws_route_table.public[*].id, var.create_multiple_public_route_tables ? count.index : 0)
  subnet_id      = aws_subnet.public[count.index].id
}

resource "aws_route" "public_internet_gateway" {
  count                  = local.create_public_subnets && var.create_igw ? local.num_public_route_tables : 0
  route_table_id         = aws_route_table.public[count.index].id
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = aws_internet_gateway.main[count.index].id
  timeouts {
    create = "5m"
  }
}

################################################################################
# Private Subnets
################################################################################

resource "aws_subnet" "private" {
  count             = local.len_private_subnets > 0 ? local.len_private_subnets : 0
  vpc_id            = aws_vpc.main.id
  availability_zone = var.azs[count.index]
  cidr_block        = var.private_subnets[count.index]

  tags = merge(
    { "Name" = "${var.name}-${var.private_subnet_suffix}-${element(var.azs, count.index)}" },
    var.tags,
    var.private_subnet_tags,
  )
}

# There are as many routing tables as the number of NAT gateways
resource "aws_route_table" "private" {
  count  = local.len_private_subnets > 0 ? local.nat_gateway_count : 0
  vpc_id = aws_vpc.main.id
  tags = merge(
    { "Name" = "${var.name}-${var.private_subnet_suffix}-${element(var.azs, count.index)}" },
    var.tags,
    var.public_route_table_tags,
  )
}

resource "aws_route_table_association" "private" {
  count          = local.len_private_subnets > 0 ? local.len_private_subnets : 0
  route_table_id = element(aws_route_table.private[*].id, var.single_nat_gateway ? 0 : count.index,)
  subnet_id      = element(aws_subnet.private[*].id, count.index)
}

resource "aws_route" "private_nat_gateway" {
  count = var.enable_nat_gateway ? local.nat_gateway_count : 0
  route_table_id = element(
    aws_route_table.private[*].id, count.index
  )
  destination_cidr_block = var.nat_gateway_destination_cidr_block
  nat_gateway_id = element(
    aws_nat_gateway.nat[*].id, count.index
  )
  timeouts {
    create = "5m"
  }
}

################################################################################
# Database Subnets
################################################################################

resource "aws_subnet" "database" {
  count             = local.len_database_subnets > 0 ? local.len_database_subnets : 0
  vpc_id            = aws_vpc.main.id
  availability_zone = var.azs[count.index]
  cidr_block        = var.database_subnets[count.index]

  tags = merge(
    { "Name" = "${var.name}-${var.database_subnet_suffix}-${element(var.azs, count.index)}" },
    var.tags,
    var.database_subnet_tags,
  )
}

resource "aws_db_subnet_group" "database" {
  count       = local.len_database_subnets > 0 && var.create_database_subnet_group ? 1 : 0
  name        = lower(coalesce(var.database_subnet_group_name, var.name))
  description = "Database subnet group for ${var.name}"
  subnet_ids  = aws_subnet.database[*].id
  tags = merge(
    {
      "Name" = lower(coalesce(var.database_subnet_group_name, var.name))
    },
    var.tags,
    var.database_subnet_group_tags,
  )
}

locals {
  create_database_route_table = local.len_database_subnets > 0 && var.create_database_subnet_route_table
}

resource "aws_route_table" "database" {
  count  = local.create_database_route_table ? 1 : 0
  vpc_id = aws_vpc.main.id

  tags = merge(
    { "Name" = lower(coalesce(var.database_subnet_group_name, var.name)) },
    var.tags,
    var.database_route_table_tags,
  )
}
###########################################################################################
  # If var.create_database_subnet_route_table is true: 
  #(And if var.single_nat_gateway is true: 
  #The index used for the element function will be 0.)
  #If the above condition is false: The index will be count.index.
  #If var.create_database_subnet_route_table is false: The index will be count.index.
#########################################################################################
resource "aws_route_table_association" "database" {
  count          = local.create_database_route_table ? local.len_database_subnets : 0
  route_table_id = element(
    coalescelist(aws_route_table.database[*].id, aws_route_table.private[*].id),
    var.create_database_subnet_route_table ? var.single_nat_gateway ? 0 : count.index : count.index,
  )

  subnet_id      = aws_subnet.database[count.index].id
}

##################################################################
# if (local.create_database_route_table && var.create_database_nat_gateway_route && var.enable_nat_gateway) is true
# ? if var.single_nat_gateway is true 
#? 1 : elif local.len_database_subnets : else 0
#################################################################
resource "aws_route" "database_nat_gateway" {
  count = local.create_database_route_table && var.create_database_nat_gateway_route && var.enable_nat_gateway ? var.single_nat_gateway ? 1 : local.len_database_subnets : 0

  route_table_id = element(aws_route_table.database[*].id, count.index)
  destination_cidr_block = "0.0.0.0/0"
  nat_gateway_id         = element(aws_nat_gateway.nat[*].id, count.index)
  timeouts {
    create = "5m"
  }
}

################################################################################
# Intra Subnets
################################################################################

locals {
  create_intra_subnets = local.len_intra_subnets > 0
}

resource "aws_subnet" "intra" {
  count = local.create_intra_subnets ? local.len_intra_subnets : 0
  vpc_id            = aws_vpc.main.id
  availability_zone = var.azs[count.index]
  cidr_block        = var.intra_subnets[count.index]

  tags = merge(
    { "Name" = "${var.name}-${var.intra_subnet_suffix}-${element(var.azs, count.index)}" },
    var.tags,
    var.intra_subnet_tags,
  ) 
}

locals {
  num_intra_route_tables = var.create_multiple_intra_route_tables ? local.len_intra_subnets : 1
}

resource "aws_route_table" "intra" {
  count = local.create_intra_subnets ? local.num_intra_route_tables : 0
  vpc_id            = aws_vpc.main.id
    tags = merge(
    {
      "Name" = var.create_multiple_intra_route_tables ? format(
        "${var.name}-${var.intra_subnet_suffix}-%s",
        element(var.azs, count.index),
      ) : "${var.name}-${var.intra_subnet_suffix}"
    },
    var.tags,
    var.intra_route_table_tags,
  )
}

resource "aws_route_table_association" "intra" {
  count = local.create_intra_subnets ? local.len_intra_subnets : 0
  subnet_id = element(aws_subnet.intra[*].id, count.index)
  route_table_id = element(aws_route_table.intra[*].id, var.create_multiple_intra_route_tables ? count.index : 0)  
}

################################################################################
# Internet Gateway
################################################################################

resource "aws_internet_gateway" "main" {
  count = local.create_public_subnets && var.create_igw ? 1 : 0
  vpc_id = aws_vpc.main.id
  tags = merge(
    { "Name" = var.name },
    var.tags,
    var.igw_tags,
  )
}

################################################################################
# NAT Gateway
################################################################################

#####
#nat_gateway_count = if var.single_nat_gateway is true ? 1 
# else 
#: if var.one_nat_gateway_per_az is true 
#? length(var.azs) 
#else : local.max_subnet_length
####
####
#nat_gateway_ips   = if var.reuse_nat_ips is true 
#? var.external_nat_ip_ids 
#else : aws_eip.nat[*].id

locals {
  nat_gateway_count = var.single_nat_gateway ? 1 : var.one_nat_gateway_per_az ? length(var.azs) : local.max_subnet_length
  nat_gateway_ips   = var.reuse_nat_ips ? var.external_nat_ip_ids : aws_eip.nat[*].id
}

resource "aws_eip" "nat" {
  count = var.enable_nat_gateway && !var.reuse_nat_ips ? local.nat_gateway_count : 0
  domain = "vpc"
  tags = merge(
    {
      "Name" = format(
        "${var.name}-%s",
        element(var.azs, var.single_nat_gateway ? 0 : count.index),
      )
    },
    var.tags,
    var.nat_eip_tags,
  )
  depends_on = [ aws_internet_gateway.main ]
}

resource "aws_nat_gateway" "nat" {
  count = var.enable_nat_gateway ? local.nat_gateway_count : 0
  allocation_id = element( 
    local.nat_gateway_ips, 
    var.single_nat_gateway ? 0 : count.index)
  subnet_id = element(
    aws_subnet.public[*].id, 
    var.single_nat_gateway ? 0 : count.index
  )
    tags = merge(
    {
      "Name" = format(
        "${var.name}-%s",
        element(var.azs, var.single_nat_gateway ? 0 : count.index),
      )
    },
    var.tags,
    var.nat_gateway_tags,
  )

  depends_on = [aws_internet_gateway.main]
}