data "aws_availability_zones" "azs" {
  state = "available"
}

####################################################################
# VPC Security Group
####################################################################

#------------------------------------------------------------
#Security DB

resource "aws_security_group" "security_group_rds" {
  name   = var.rds_security_group_name
  vpc_id = var.vpc_id

  tags = {
    Name = var.rds_security_group_name
  }
}

resource "aws_vpc_security_group_ingress_rule" "db" {
  for_each          = data.aws_subnet.private_subnet
  security_group_id = aws_security_group.security_group_rds.id

  cidr_ipv4   = each.value.cidr_block
  from_port   = var.db_from_port
  ip_protocol = "tcp"
  to_port     = var.db_to_port
}


resource "aws_vpc_security_group_ingress_rule" "vault_db" {
  security_group_id = aws_security_group.security_group_rds.id

  cidr_ipv4   = var.vault_cluster_cidr
  from_port   = var.db_from_port
  ip_protocol = "tcp"
  to_port     = var.db_to_port
}

resource "aws_vpc_security_group_egress_rule" "db" {
  security_group_id = aws_security_group.security_group_rds.id
  cidr_ipv4         = "0.0.0.0/0"
  ip_protocol       = "-1"
}


#------------------------------------------------------------
#Security Private

resource "aws_security_group" "security_group_private_ssh" {
  name   = var.private_ssh_security_group_name
  vpc_id = var.vpc_id

  tags = {
    Name = var.private_ssh_security_group_name
  }
}

resource "aws_vpc_security_group_ingress_rule" "private" {
  for_each          = data.aws_subnet.public_subnet
  security_group_id = aws_security_group.security_group_private_ssh.id

  cidr_ipv4   = each.value.cidr_block
  from_port   = var.ssh_from_port
  ip_protocol = "tcp"
  to_port     = var.ssh_to_port
}

resource "aws_vpc_security_group_egress_rule" "private" {
  security_group_id = aws_security_group.security_group_private_ssh.id
  cidr_ipv4         = "0.0.0.0/0"
  ip_protocol       = "-1"
}

#------------------------------------------------------------
#Security Public

resource "aws_security_group" "security_group_public_ssh" {
  name   = var.public_ssh_security_group_name
  vpc_id = var.vpc_id

  tags = {
    Name = var.public_ssh_security_group_name
  }
}

resource "aws_vpc_security_group_ingress_rule" "public" {
  security_group_id = aws_security_group.security_group_public_ssh.id

  cidr_ipv4   = "0.0.0.0/0"
  from_port   = var.ssh_from_port
  ip_protocol = "tcp"
  to_port     = var.ssh_to_port
}

resource "aws_vpc_security_group_egress_rule" "public" {
  security_group_id = aws_security_group.security_group_public_ssh.id
  cidr_ipv4         = "0.0.0.0/0"
  ip_protocol       = "-1"
}

####################################################################
# AWS DB Instance
####################################################################

resource "aws_db_instance" "project_rds" {
  engine                 = var.engine
  engine_version         = var.engine_version
  identifier             = var.identifier
  username               = var.username
  password               = var.password
  instance_class         = var.instance_class
  storage_type           = var.storage_type
  allocated_storage      = var.allocated_storage
  max_allocated_storage  = var.max_allocated_storage
  db_subnet_group_name   = var.db_subnet_group_name
  publicly_accessible    = var.publicly_accessible
  vpc_security_group_ids = [aws_security_group.security_group_rds.id]
  availability_zone      = data.aws_availability_zones.azs.names[0]
  port                   = var.mysql_port
  db_name                = var.db_name
  skip_final_snapshot    = true
}

#https://stackoverflow.com/questions/50930470/terraform-error-rds-cluster-finalsnapshotidentifier-is-required-when-a-final-s

####################################################################
# AWS EC2 Instance
####################################################################

//---------------------------------------------------------
//-App Server with AWS Auto Auth
//---------------------------------------------------------
resource "aws_instance" "app" {
  ami                         = data.aws_ami.ubuntu.id
  instance_type               = var.instance_type
  subnet_id                   = data.aws_subnets.private_subnet_az1a.ids[0]
  key_name                    = "ssh-key-${random_pet.env.id}"
  vpc_security_group_ids      = [aws_security_group.security_group_private_ssh.id]
  associate_public_ip_address = false
  iam_instance_profile        = aws_iam_instance_profile.vault-client.id

  user_data = data.template_file.vault_agent.rendered

  tags = {
    Name = "${var.environment_name}-app"
  }
  lifecycle {
    ignore_changes = [
      ami,
      tags,
    ]
  }
}

data "template_file" "vault_agent" {
  template = file("${path.module}/template/app-vault-client.tftpl")

  vars = {
    tpl_vault_server_addr = var.vault_addr
    MYSQL_HOST = aws_db_instance.project_rds.address
    MYSQL_USER = aws_db_instance.project_rds.username
    MYSQL_PASS = aws_db_instance.project_rds.password
  }
}

//---------------------------------------------------------
//-App Server with Approle Auto Auth
//---------------------------------------------------------
resource "aws_instance" "app-approle" {
  ami                         = data.aws_ami.ubuntu.id
  instance_type               = var.instance_type
  subnet_id                   = data.aws_subnets.private_subnet_az1b.ids[0]
  key_name                    = "ssh-key-${random_pet.env.id}"
  vpc_security_group_ids      = [aws_security_group.security_group_private_ssh.id]
  associate_public_ip_address = false
 
  user_data = data.template_file.vault_agent_approle.rendered

  tags = {
    Name = "${var.environment_name}-app-approle"
  }
  lifecycle {
    ignore_changes = [
      ami,
      tags,
    ]
  }
}

data "template_file" "vault_agent_approle" {
  template = file("${path.module}/template/app-approle-vault-client.tftpl")

  vars = {
    tpl_vault_server_addr = var.vault_addr
    login_role_id = data.terraform_remote_state.approle.outputs.db_approle_role_id
    login_secret_id = data.terraform_remote_state.approle.outputs.db_approle_role_sid
  }
}

//---------------------------------------------------------
//-Jump Server 
//---------------------------------------------------------
resource "aws_instance" "jump" {
  ami                         = data.aws_ami.ubuntu.id
  instance_type               = var.instance_type
  subnet_id                   = data.aws_subnets.public_subnet_az1a.ids[0]
  key_name                    = "ssh-key-${random_pet.env.id}"
  vpc_security_group_ids      = [aws_security_group.security_group_public_ssh.id]
  associate_public_ip_address = true

  tags = {
    Name = "${var.environment_name}-jump"
  }
  lifecycle {
    ignore_changes = [
      ami,
      tags,
    ]
  }
}

