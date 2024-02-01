variable "region" {
    type = string
}

#vpc

variable "cidr_block" {
    description = "main vpc cider block"
    type = string
}

#subnets

variable "pub_sub_cidr_block" {
    type = string
}

variable "pub_sub_name" {
    type = string
}

variable "map_ip" {
    type = bool
}

#sgs

#ec2

variable "instance_type" {
    type = string
}

variable "key_name" {
    type = string
}

#s3


variable "email" {
    type = string
}
