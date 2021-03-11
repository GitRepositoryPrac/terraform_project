provider "aws" {
     access_key = "XXX"
    secret_key = "XXXXX"
    #region = "us-west-1"
    region = var.region

}

#we need to create a VPC resource
## Variable code is there here so delete that perticular code then we can write the code seperatly.
## the file name called "variable.tf"
resource "aws_vpc" "ntiervpc2" {
    cidr_block = var.vpccidr  #"192.168.0.0/16"
    enable_dns_support = true
    enable_dns_hostnames = true
             
             tags = {
                 "Name" = "From tf" 
             }
}
#lets create a subnet web1 
# how to declare multile subnets in loo 
#let's create all subnets
resource "aws_subnet" "subnets" { #here we has declare "subnets" this one is callin at "tags" file
    count = 6 # here we create 6 subnets that's why we can declare the variable in 6(count 6)
    vpc_id = aws_vpc.ntiervpc2.id # not chages 

# cidr_block = var.cidrranges[count.index]     #cidrranges this varible declared in variable.tf file
    cidr_block = cidrsubnet(var.vpccidr,8,count.index)
    #availability_zone = var.subnetazs[count.index]
   #instared of above code by using extensonal operator
    availability_zone = "${var.region}${count.index % 2 == 0 ? "a" : "c"}"
      tags = {
          #"Name" = var.subnets[count.index]   
          #Observe here we can call to "local.tf" file directly
          "Name" = local.subnets[count.index]
      }
    depends_on =[
        aws_vpc.ntiervpc2
    ]
}
#modify the below code and the different subnets we can declre the only one subnet code
# this code related variable data 
#we can declared in variable.tf file

##resource "aws_subnet" "web1" {
  ##  vpc_id = aws_vpc.ntiervpc2.id
    ##cidr_block = "192.168.0.0/24"
    ##availability_zone = "us-west-1a"
    ##tags = {
      ##  "Name" = "web1"
    ##}
  ##}

  #lets create a subnet  web2
#resource "aws_subnet" "web2" {
    #resource_type.resource_name.attribute_ID.
 #   vpc_id = aws_vpc.ntiervpc2.id
  #  cidr_block = "192.168.1.0/24"
   # availability_zone = "us-west-1c"
    #tags = {
     #   "Name" = "web2_tf2"
    #}
  #}


#Here creating the "Internet Gate way of the application"
resource "aws_internet_gateway" "ntiergw" {
  vpc_id = aws_vpc.ntiervpc2.id
  
  tags = {
    "Name" = local.igw_name
  }

  depends_on = [ 
    aws_vpc.ntiervpc2
   ]
}