resource "aws_security_group" "security_group" {
  vpc_id = var.vpc_id

  name = var.security_name

  dynamic "ingress"{
    for_each = var.ingress
    content {
      from_port = ingress.value
      to_port = ingress.value
      protocol = var.protocol
      cidr_blocks = var.cidr_blocks
    }
  }

  tags = var.tags
}