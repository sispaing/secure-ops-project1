#######################################################################
#Hashicorp Virtual Network
#######################################################################
resource "hcp_aws_network_peering" "peer_hvn_master_vpc" {
  hvn_id          = var.hvn_id
  peering_id      = var.peering_id
  peer_vpc_id     = var.vpc_id
  peer_account_id = data.aws_vpc.master_aws_vpc.owner_id
  peer_vpc_region = data.aws_arn.vpc_arn.region
}

resource "hcp_hvn_route" "hvn-to-private" {
  for_each = data.aws_subnet.private_subnet
  hvn_link         = data.hcp_hvn.hcp_hvn_id.self_link
  hvn_route_id     = each.value.id
  destination_cidr = each.value.cidr_block
  target_link      = hcp_aws_network_peering.peer_hvn_master_vpc.self_link
}

resource "hcp_hvn_route" "hvn-to-db" {
  for_each = data.aws_subnet.db_subnet
  hvn_link         = data.hcp_hvn.hcp_hvn_id.self_link
  hvn_route_id     = each.value.id
  destination_cidr = each.value.cidr_block
  target_link      = hcp_aws_network_peering.peer_hvn_master_vpc.self_link
}

#######################################################################
#AWS VPC
#######################################################################

resource "aws_vpc_peering_connection_accepter" "hvn_peer" {
  vpc_peering_connection_id = hcp_aws_network_peering.peer_hvn_master_vpc.provider_peering_id
  auto_accept               = true
}

resource "aws_route" "master_to_hvn_private_route" {
  route_table_id            = data.aws_route_table.private_rout_table.id
  destination_cidr_block    = data.hcp_hvn.hcp_hvn_id.cidr_block
  vpc_peering_connection_id = aws_vpc_peering_connection_accepter.hvn_peer.id
}

resource "aws_route" "master_to_hvn_db_route" {
  route_table_id            = data.aws_route_table.db_rout_table.id
  destination_cidr_block    = data.hcp_hvn.hcp_hvn_id.cidr_block
  vpc_peering_connection_id = aws_vpc_peering_connection_accepter.hvn_peer.id
}

