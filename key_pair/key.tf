resource "aws_key_pair" "key_pair" {
    key_name = var.key_name
    public_key = var.path_to_public_key
}