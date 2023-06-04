variable "bucket_name" {
  type = string
}

variable "acl" {
  type = string
}
variable "block_public_acls" {
  type = bool
}

variable "block_public_policy" {
  type = bool
}

variable "ignore_public_acls" {
  type = bool
}

variable "restrict_public_buckets" {
  type = bool
}

variable "versioning"{
  type = string
}

variable "sse_algorithm" {
  type = string
}

variable "tags" {
  type = map
}