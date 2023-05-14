resource "aws_subnet" "private-subnet-1" {
  vpc_id                  = var.vpc_id
  cidr_block              = var.private_cidr_block_1
  map_public_ip_on_launch = var.map_private_ip_on_launch
  availability_zone       = var.availability_zone_1
  tags = var.tags
}

resource "aws_subnet" "private-subnet-2" {
  vpc_id                  = var.vpc_id
  cidr_block              = var.private_cidr_block_2
  map_public_ip_on_launch = var.map_private_ip_on_launch
  availability_zone       = var.availability_zone_2
  tags = var.tags
}

resource "aws_subnet" "private-subnet-3" {
  vpc_id                  = var.vpc_id
  cidr_block              = var.private_cidr_block_3
  map_public_ip_on_launch = var.map_private_ip_on_launch
  availability_zone       = var.availability_zone_3
  tags = var.tags
}

output "private-subnet-1-id"{
  value = aws_subnet.private-subnet-1.id
}

output "private-subnet-2-id"{
  value = aws_subnet.private-subnet-2.id
}

output "private-subnet-3-id"{
  value = aws_subnet.private-subnet-3.id
}