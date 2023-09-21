resource "tls_private_key" "public_key" {
  algorithm = "RSA"
  rsa_bits  = 4096
}

resource "local_file" "private_key" {
  content         = tls_private_key.public_key.private_key_openssh
  filename        = "${path.module}/key.pem"
  file_permission = "0600"
}

resource "aws_key_pair" "key_pair" {
  key_name   = "${var.name}-key"
  public_key = tls_private_key.public_key.public_key_openssh
}

resource "aws_vpc" "vpc" {
  cidr_block = "10.0.0.0/24"

  tags = {
    Name = "${var.name}-vpc"
  }
}

resource "aws_internet_gateway" "internet_gateway" {
  vpc_id = aws_vpc.vpc.id

  tags = {
    Name = "${var.name}-internet_gateway"
  }
}

resource "aws_route_table" "route_table" {
  vpc_id = aws_vpc.vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.internet_gateway.id
  }

  tags = {
    Name = "${var.name}-route_table"
  }
}

resource "aws_subnet" "subnet" {
  vpc_id = aws_vpc.vpc.id

  cidr_block        = "10.0.0.0/24"
  availability_zone = "us-east-1a"

  tags = {
    Name = "${var.name}-subnet"
  }
}

resource "aws_route_table_association" "aws_route_table_association" {
  for_each = aws_subnet.subnet

  route_table_id = aws_route_table.route_table.id
  subnet_id      = aws_subnet.subnet.id
}

resource "aws_security_group" "security_group" {
  name        = "${var.name}-security_group"
  description = "The ${var.name} security group generated by Terraform"

  vpc_id = aws_vpc.vpc.id

  dynamic "ingress" {
    for_each = var.ports

    content {
      from_port   = ingress.value
      to_port     = ingress.value
      protocol    = "tcp"
      cidr_blocks = ["0.0.0.0/0"]
    }
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_eip" "elastic_ip" {
  instance = aws_instance.ec2_instance.id
}

resource "aws_instance" "ec2_instance" {
  # Ubuntu 22.04 ami
  ami = var.ami

  instance_type = var.instance_type

  key_name               = aws_key_pair.key_pair.key_name
  subnet_id              = aws_subnet.subnet.id
  vpc_security_group_ids = [aws_security_group.security_group.id]

  root_block_device {
    volume_size = 150
    volume_type = "gp3"
  }

  tags = {
    Name = "${var.name}-ec2"
  }
}
