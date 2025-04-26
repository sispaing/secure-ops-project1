
Link
https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/vpc

https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/subnet

main.tf
resource "aws_vpc" "main" {
  cidr_block       = "10.10.0.0/16"

  tags = {
    Name = "master-prod-prod"
  }
}
resource "aws_subnet" "public_subnet_01" {
  vpc_id     = aws_vpc.main.id
  cidr_block = var.public_subnet_01
  avilability_zone  = var.az_1a
  map_public_ip_on_launch = true

  tags = {
    Name = "public-subnet-01-ap-southeast-1a"
  }
}

variable.tf
variable public_subenet_01 {
  default       = "10.10.1.0/24"
  description   = "public-subnet-01"
}
variable az_1a {
  default       = "ap-southeast-1a"
  description   = "availability zone"
}

Copy 2 times for public subnet 2 and 3
Create this with aws secret and secret access key
Insert this aws key as variable from TFC workspace setting.
Explain from AWS console GUI created one.
 
 After apply above , please write output.
 data.tf
 data "aws_availability_zones" "azs" [
   state = "avilable"
 ]

 Go to Data Sources > availiablity zone
 output.tf
 output azs {
   vale = data.aws_availability_zones.azs.names
 }

 Save > Push to repo. Trigger pipeline.
Show the resutlt of azs output.

Now we wil fine tune terraform code to be better.
variable.tf
variable public_subenets {
  default       = ["10.10.1.0/24", "10.10.2.0/24", "10.10.3.0/24"]
  description   = "public-subnets"
}
variable azs {
  default       = ["ap-southeast-1a", "ap-southeast-1b", "ap-southeast-1c"]
  description   = "availability zone"
}

https://developer.hashicorp.com/terraform/language/meta-arguments/resource-provider

main.tf
resource "aws_subnet" "public_subnets" {
  count = 3  > count = length(var.public_subnets)
  vpc_id     = aws_vpc.main.id
  cidr_block = var.public_subnets[0]  > var.public_subnets[count.index]
  avilability_zone  = var.az_1a > data.aws_availability_zones.azs.names[count.index]          # copy from output of azs
  map_public_ip_on_launch = true

  tags = {
    Name = "public-subnet-01-ap-southeast-1a"  > 
"public-subent-0${[count.index+1]}-${data.aws_availability_zones.azs.names[count.index]}  }
}