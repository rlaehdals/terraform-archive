resource "aws_internet_gateway" "gw" {
  vpc_id = var.vpc_id

  tags = var.tags
}

resource "aws_route_table" "public" {
  vpc_id = var.vpc_id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.gw.id
  }

  tags = var.tags
}

resource "aws_route_table_association" "public-1" {
  subnet_id      = var.public_1_subnet_id
  route_table_id = aws_route_table.public.id
}

resource "aws_route_table_association" "public-2" {
  subnet_id      = var.public_2_subnet_id
  route_table_id = aws_route_table.public.id
}

resource "aws_route_table_association" "public-3" {
  subnet_id      = var.public_3_subnet_id
  route_table_id = aws_route_table.public.id
}