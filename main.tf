provider "aws" {
     access_key = "XXX"
    secret_key = "XXXXX"
    #region = "us-west-1"
    region = var.region

}

#we need to create a VPC resource
resource "aws_vpc" "ntiervpc2" {
    cidr_block = var.vpccidr  #"192.168.0.0/16"
    enable_dns_support = true
    enable_dns_hostnames = true
         
             tags = {
                 "Name" = "From tf" 
             }
}
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
#Here creating the "Internet Gate way of the application"
resource "aws_internet_gateway" "ntiergw" {
  vpc_id = aws_vpc.ntiervpc2.id
  
  tags = {
    "Name" = local.igw_name
  }
}

#Create a route table
resource "aws_route_table" "publicrt" {
   vpc_id = aws_vpc.ntiervpc2.id

  route  {
    #count = 6
    cidr_block = local.anywhere  #subnet[count.insex]
    gateway_id = aws_internet_gateway.ntiergw.id
  }

#Depends related 
  depends_on = [ 
    aws_vpc.ntiervpc2,
    aws_subnet.subnets[0],
    aws_subnet.subnets[1]
    

   ]
   tags = {
    "Name" = "publicrt"
  }  
}

# we can associate the web related
resource "aws_route_table_association" "webassociations" {
  count = 2
  route_table_id = aws_route_table.publicrt.id
  subnet_id = aws_subnet.subnets[count.index].id
  
  depends_on = [ 
    aws_route_table.publicrt
   ]
  
}

resource "aws_route_table" "privatert" {
  vpc_id = aws_vpc.ntiervpc2.id
  #Depends related 
  depends_on = [ 
    aws_vpc.ntiervpc2,
    aws_subnet.subnets[3],
    aws_subnet.subnets[4],
    aws_subnet.subnets[5],
    aws_subnet.subnets[6]
   ]
  tags = {
    "Name" = "privatert"
  }

}
resource "aws_route_table_association" "app1associations" {  # here main theme is we are not write any
   count = 4
    route_table_id = aws_route_table.privatert.id
    subnet_id = aws_subnet.subnets[count.index].id
  depends_on = [
     aws_route_table.privatert
   ]
 
}
#  route_table_id = aws_route_table.publicrt.id
#  subnet_id = aws_subnet.subnets[count.index].id
