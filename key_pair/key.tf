resource "aws_key_pair" "key_pair" {
    key_name = var.key_name
    public_key = var.path_to_public_key
}

output "key_pair_id"{
    value = aws_key_pair.key_pair.id
}