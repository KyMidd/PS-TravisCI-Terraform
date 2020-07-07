# Require TF version to be same as or greater than 0.12.19
terraform {
  required_version = ">=0.12.19"
  backend "s3" {
    bucket         = "mysampleterraform07072020123"
    key            = "terraform.tfstate"
    region         = "us-east-1"
    dynamodb_table = "aws-locks"
    encrypt        = true
  }
}

# Download AWS provider
provider "aws" {
  region  = "us-east-1"
  version = "~> 2.36.0"
}

# Terraform bootstrapping
module "bootstrap" {
  source                      = "./modules/bootstrap"
  name_of_s3_bucket           = "mysampleterraform07072020123"
  dynamo_db_table_name        = "aws-locks"
  iam_user_name               = "IamUser"
  ado_iam_role_name           = "IamRole"
  aws_iam_policy_permits_name = "IamPolicyPermits"
  aws_iam_policy_assume_name  = "IamPolicyAssume"
}

/*
locals {
  cisco_asav_name       = "CiscoASAv"  # Just for fun, name your ASAv anything you'd like!
  my_public_ip          = "1.2.3.4/32"  # Update this to your public IP when deploying
  ssh_key_name          = "cisco_asav_keypair"  # Update only if you've created an SSH key with a different name than cisco_asav_keypair
  asav_public_facing_ip = "172.16.20.10"
}

resource "aws_vpc" "aws_vpc" {
  cidr_block = "172.16.0.0/16"

  tags = {
    Name = "AwsVpc"
  }
}

resource "aws_internet_gateway" "internet_gateway" {
  vpc_id = aws_vpc.aws_vpc.id

  tags = {
    Name = "AwsInternetGateway"
  }
}

resource "aws_route_table" "public_route_table" {
  vpc_id = aws_vpc.aws_vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.internet_gateway.id
  }

  tags = {
    Name = "AwsPublicRouteTable"
  }
}

# Attach network subnet 1 to dia route table1
resource "aws_route_table_association" "dia_route_table1" {
  subnet_id      = aws_subnet.aws_public_subnet1.id
  route_table_id = aws_route_table.public_route_table.id
}

resource "aws_subnet" "aws_private_subnet1" {
  vpc_id            = aws_vpc.aws_vpc.id
  cidr_block        = "172.16.10.0/24"
  availability_zone = "us-east-1a"

  tags = {
    Name = "AwsPrivateSubnet1"
  }
}

resource "aws_subnet" "aws_public_subnet1" {
  vpc_id            = aws_vpc.aws_vpc.id
  cidr_block        = "172.16.20.0/24"
  availability_zone = "us-east-1a"

  tags = {
    Name = "AwsPublicSubnet1"
  }
}

# Create security group for ASAv public interface
resource "aws_security_group" "cisco_asav_public" {
  name        = "CiscoASAvPublicSg"
  description = "Allow TLS inbound traffic"
  vpc_id      = aws_vpc.aws_vpc.id

  ingress {
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = [local.my_public_ip]
  }

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = [local.my_public_ip]
  }

  ingress {
    from_port   = -1
    to_port     = -1
    protocol    = "icmp"
    cidr_blocks = [local.my_public_ip]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "CiscoASAvPublicSg"
  }
}

# Create security group for ASAv private interface
resource "aws_security_group" "cisco_asav_private" {
  name        = "CiscoASAvPrivateSg"
  description = "Allow TLS inbound traffic"
  vpc_id      = aws_vpc.aws_vpc.id

  ingress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["10.0.0.0/8"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "CiscoASAvPrivateSg"
  }
}

resource "aws_network_interface" "asav_private_interface" {
  subnet_id         = aws_subnet.aws_private_subnet1.id
  private_ips       = ["172.16.10.10"]
  source_dest_check = false

  security_groups = [
    aws_security_group.cisco_asav_private.id
  ]

  tags = {
    Name = "${local.cisco_asav_name}PrivateInterface"
  }
}

resource "aws_network_interface" "asav_public_interface" {
  subnet_id         = aws_subnet.aws_public_subnet1.id
  private_ips       = [local.asav_public_facing_ip]
  source_dest_check = false

  security_groups = [
    aws_security_group.cisco_asav_public.id
  ]

  tags = {
    Name = "${local.cisco_asav_name}PublicInterface"
  }
}

resource "aws_eip" "cisco_asav_elastic_public_ip" {
  vpc                       = true
  network_interface         = aws_network_interface.asav_public_interface.id
  associate_with_private_ip = local.asav_public_facing_ip

  depends_on = [
    aws_internet_gateway.internet_gateway
  ]
}

# Build the ASAv
resource "aws_instance" "cisco_asav" {
  # This AMI is only valid in us-east-1 region, with this specific instance type
  ami           = "ami-01b0bfec54ba93d12"
  instance_type = "c4.large"
  key_name      = local.ssh_key_name

  network_interface {
    network_interface_id = aws_network_interface.asav_private_interface.id
    device_index         = 0
  }

  network_interface {
    network_interface_id = aws_network_interface.asav_public_interface.id
    device_index         = 1
  }

  user_data = file("ASAv_Init_Config/asav_init_config.txt")

  tags = {
    Name = local.cisco_asav_name
  }
}

output "asav_public_ip" {
  value = aws_eip.cisco_asav_elastic_public_ip.public_ip
}
*/
