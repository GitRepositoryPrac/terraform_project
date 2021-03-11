
# Here we can declare the Varialbes in seperate file 
# we can declare the Variables
#in below code 
# we can declare the "region" related information by using variable

variable "region" {
    type = string
    default =  "us-west-1"
    description = "region in which ntier2 has to be created"
}
#in below code 
# we can declare the "VPC" related information by using variable

variable "vpccidr" {
    type = string
    default = "192.168.0.0/16"

}

#in below code 
# we can declare the subnets related information by using variable

variable "subnets" { # this one call at main.tf file 
    type = list(string)
    default = ["web1","web2","app1","app2","db1","db2"]
    description = "Name of the subnets"

}

#in below code 
# we can declare the "CIDR " range related information by using variable
variable "cidrranges" { # this CIDR name we can give on main.tf #we can call this variable in main.tf file
    type = list(string)
    default = ["192.168.0.0/24","192.168.1.0/24","192.168.2.0/24","192.168.3.0/24","192.168.4.0/24","192.168.5.0/24"]
    description =" CIDr Reanges of the subnets "

}

variable "subnetazs" { 
    type = list(string)
    default = ["us-west-1a","us-west-1c","us-west-1a","us-west-1c","us-west-1a","us-west-1c"]#["us-west-2a","us-west-2b","us-west-2a","us-west-2b","us-west-2a","us-west-2b"]

}
#us-west-1a, us-west-1c