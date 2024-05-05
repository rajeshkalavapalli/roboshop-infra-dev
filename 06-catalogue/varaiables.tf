variable "common_tags" {
  default = {
    project_name = "roboshop"
    environment = "dev"
    terraform = "true"
  }
}

variable "tags" {
  default = {
    component = "catalogue"
  }
}
variable "project_name" {
    type = string
    default = "ROBOSHOP"
  
}

variable "environment" {
  default = "dev"
}

# variable "instance_type" {
#   type = string
#   default = "t3.small"
# }


variable "zone_name" {
  default = "bigmatrix.in"
}