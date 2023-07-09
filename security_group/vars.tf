variable "vpc_id"{
    type = string
}

variable "security_name" {
    type = string
}

variable "region"{
    type = string
}

variable "ingress"{
    type = map
}

variable "protocol" {
    type = string
}

variable "cidr_blocks"{
    type = list
}

variable "tags"{
    type = map
}