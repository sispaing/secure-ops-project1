variable "vpc_id" {
  description = "(Need to Change) VPC ID"
}


variable "peering_id" {
  description = "The ID of the network peering."
  default = "vpc-peering-hvn-master-vpc"
}

variable "hvn_route_id" {
  description = "The ID of the HVN route."
  default = "vpc-peering-route"
}

variable "peer_vpc_region" {
  description = "The region of the peer VPC in AWS."
  default = "ap-southeast-1"
}

variable "hvn_id" {
  description = "The ID of the HashiCorp Virtual Network (HVN)"
  default = "vault-aws-hvn"
}