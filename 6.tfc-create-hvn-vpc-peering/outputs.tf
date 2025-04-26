output "vpc_owner_id" {
  description = "ID of the AWS account that owns the VPC."
  value = data.aws_vpc.master_aws_vpc.owner_id
}

output "all_subnets" {
  description = "a set of subnet IDs"
  value = data.aws_subnets.all_subnets.ids
}

output "private_subnet_id" {
  description = "a set of private subnet id"
  value = data.aws_subnets.private_subnet_ids.ids
}

output "set_private_subnet_id" {
  description = "a set of private subnet id"
  value = toset(data.aws_subnets.private_subnet_ids.ids)
}

output "db_subnet_id" {
  description = "a set of db subnet id"
  value = data.aws_subnets.db_subnet_ids.ids
}

output "set_db_subnet_id" {
  description = "a set of db subnet id"
  value = toset(data.aws_subnets.db_subnet_ids.ids)
}

output "hcp_hvn_id" {
  description = "The CIDR range of the HVN."
  value = data.hcp_hvn.hcp_hvn_id.cidr_block
}