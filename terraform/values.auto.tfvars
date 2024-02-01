region = "us-east-1"

#vpc

cidr_block = "10.0.0.0/16"

#subnets

pub_sub_cidr_block = "10.0.1.0/24"

pub_sub_name = "pub_sub"

map_ip = true

#ec2

instance_type = "t2.large"
key_name = "terraform_ec2"

#sns topic subscription email
email = "EMAIL_ADDRESS"

