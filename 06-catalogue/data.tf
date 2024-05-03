data "aws_ami" "centos-8-Practice" {
owners           = ["973714476881"]
most_recent      = true

    filter {
        name   = "name"
        values = ["Centos-8-DevOps-Practice"]
    }

    #  filter {
    #      name   = "root-device-type"
    #      values = ["EBS"]
    # }

    #  filter {
    #      name   = "virtualization-type"
    #      values = ["hvm"]
    #  }

}

# ssm alb subnet ids 
data "aws_ssm_parameter" "app_alb_sg_id" {
  name = "/${var.project_name}/${var.environment}/app_alb_sg_id"
}

# ssm private subnet ids 
data "aws_ssm_parameter" "private_subnet_ids" {
  name = "/${var.project_name}/${var.environment}/private_subnet_ids"
}

# ssm vpc id  
data "aws_ssm_parameter" "vpc_id" {
  name = "/${var.project_name}/${var.environment}/vpc_id"
}

# ssm vpc id  
data "aws_ssm_parameter" "catalogue_sg_id" {
  name = "/${var.project_name}/${var.environment}/catalogue_sg_id"
}

# listenere arn 
data "aws_ssm_parameter" "app_alb_listenere_arn" {
  name = "/${var.project_name}/${var.environment}/app_alb_listenere_arn"
}