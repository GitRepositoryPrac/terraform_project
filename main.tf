provider "aws" {
    access_key = "XXXXX"
    secret_key = "XXXXX"
    #region = "us-west-1"
    region = var.region

}

# we can declare the Variables
variable "region" {
    type = string
    default =  "us-west-1"
    description = "region in which ntier2 has to be created"
}

#we need to create a VPC resource

resource "aws_vpc" "ntiervpc2" {
    cidr_block = "192.168.0.0/16"
    enable_dns_support = true
    enable_dns_hostnames = true
             
             tags = {
                 "Name" = "From tf" 
             }
}#lets create a subnet web1 
resource "aws_subnet" "web1" {
    vpc_id = aws_vpc.ntiervpc2.id
    cidr_block = "192.168.0.0/24"
    availability_zone = "us-west-1a"
    tags = {
        "Name" = "web1"
    }
  }

  #lets create a subnet  web2
resource "aws_subnet" "web2" {
    vpc_id = aws_vpc.ntiervpc2.id
    cidr_block = "192.168.1.0/24"
    availability_zone = "us-west-1c"
    tags = {
        "Name" = "web2_tf2"
    }
  }
