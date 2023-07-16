resource "aws_eip" "nat" {
  domain = "vpc"
}

resource "aws_nat_gateway" "nat-gw" {
  allocation_id = aws_eip.nat.id
  subnet_id     = var.dev_public_1_id
}

resource "aws_route_table" "private" {
  vpc_id = var.vpc_id
  route {
    cidr_block     = "0.0.0.0/0"
    nat_gateway_id = aws_nat_gateway.nat-gw.id
  }

  tags = var.tags
}

resource "aws_route_table_association" "private-1" {
  subnet_id      = var.dev_private_1_id
  route_table_id = aws_route_table.private.id
}

resource "aws_route_table_association" "private-2" {
  subnet_id      = var.dev_private_2_id
  route_table_id = aws_route_table.private.id
}

resource "aws_route_table_association" "private-3" {
  subnet_id      = var.dev_private_3_id
  route_table_id = aws_route_table.private.id
}