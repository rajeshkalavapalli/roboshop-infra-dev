module "mongodb" {
  source = "../../terraform_aws_sg"
  project_name = var.project_name
  environment = var.environment
  sg_description = "sg for momgodb"
  vpc_id = data.aws_ssm_parameter.vpc_id.value
  sg_name = "mongodb"
  #sg_ingress_rules = var.momgodb_sg_ingress_rules

}

module "vpn" {
  source = "../../terraform_aws_sg"
  project_name   = var.project_name
  environment    = var.environment
  sg_description = "SG for VPN"
  vpc_id         = data.aws_vpc.default.id
  sg_name        = "vpn"
  #sg_ingress_rules = var.mongodb_sg_ingress_rules
}


module "catalogue" {
  source = "../../terraform_aws_sg"
  project_name = var.project_name
  environment = var.environment
  sg_description = "sg for catalogue"
  vpc_id = data.aws_ssm_parameter.vpc_id.value
  sg_name = "catalogue"
  #sg_ingress_rules = var.momgodb_sg_ingress_rules

}

module "user" {
  source = "../../terraform_aws_sg"
  project_name = var.project_name
  environment = var.environment
  sg_description = "sg for user"
  vpc_id = data.aws_ssm_parameter.vpc_id.value
  sg_name = "user"
  #sg_ingress_rules = var.momgodb_sg_ingress_rules

}
module "cart" {
  source = "../../terraform_aws_sg"
  project_name = var.project_name
  environment = var.environment
  sg_description = "sg for cart"
  vpc_id = data.aws_ssm_parameter.vpc_id.value
  sg_name = "cart"
  #sg_ingress_rules = var.momgodb_sg_ingress_rules

}

module "shipping" {
  source = "../../terraform_aws_sg"
  project_name = var.project_name
  environment = var.environment
  sg_description = "sg for shipping"
  vpc_id = data.aws_ssm_parameter.vpc_id.value
  sg_name = "shipping"
  #sg_ingress_rules = var.momgodb_sg_ingress_rules

}

module "payments" {
  source = "../../terraform_aws_sg"
  project_name = var.project_name
  environment = var.environment
  sg_description = "sg for payments"
  vpc_id = data.aws_ssm_parameter.vpc_id.value
  sg_name = "payments"
  #sg_ingress_rules = var.momgodb_sg_ingress_rules

}

module "redis" {
  source = "../../terraform_aws_sg"
  project_name = var.project_name
  environment = var.environment
  sg_description = "sg for redis"
  vpc_id = data.aws_ssm_parameter.vpc_id.value
  sg_name = "redis"
  #sg_ingress_rules = var.momgodb_sg_ingress_rules

}

module "mysql" {
  source = "../../terraform_aws_sg"
  project_name = var.project_name
  environment = var.environment
  sg_description = "sg for mysql"
  vpc_id = data.aws_ssm_parameter.vpc_id.value
  sg_name = "mysql"
  #sg_ingress_rules = var.momgodb_sg_ingress_rules

}

module "rabbitmq" {
  source = "../../terraform_aws_sg"
  project_name = var.project_name
  environment = var.environment
  sg_description = "sg for rabbitmq"
  vpc_id = data.aws_ssm_parameter.vpc_id.value
  sg_name = "rabbitmq"
  #sg_ingress_rules = var.momgodb_sg_ingress_rules

}

module "web" {
  source = "../../terraform_aws_sg"
  project_name = var.project_name
  environment = var.environment
  sg_description = "sg for web"
  vpc_id = data.aws_ssm_parameter.vpc_id.value
  sg_name = "web"
  #sg_ingress_rules = var.momgodb_sg_ingress_rules

}
module "app_alb" {
  source = "../../terraform_aws_sg"
  project_name = var.project_name
  environment = var.environment
  sg_description = "sg for app alb"
  vpc_id = data.aws_ssm_parameter.vpc_id.value
  sg_name = "app-alb"
  #sg_ingress_rules = var.momgodb_sg_ingress_rules

}

module "web_alb" {
  source = "../../terraform_aws_sg"
  project_name = var.project_name
  environment = var.environment
  sg_description = "sg for web alb"
  vpc_id = data.aws_ssm_parameter.vpc_id.value
  sg_name = "web-alb"
  #sg_ingress_rules = var.momgodb_sg_ingress_rules

}

#app alb sould accept connections  from web 
resource "aws_security_group_rule" "web_alb_internet" { #vpn accepting from home 
  cidr_blocks = [ "0.0.0.0/0" ]
  type              = "ingress"
  from_port         = 443
  to_port           = 443
  protocol          = "tcp"
  security_group_id = module.web_alb.sg_id
}

#app alb sould accept connections only from vpn 
resource "aws_security_group_rule" "app_alb_vpn" { #vpn accepting from home 
  source_security_group_id = module.vpn.sg_id
  type              = "ingress"
  from_port         = 80
  to_port           = 80
  protocol          = "tcp"
  security_group_id = module.app_alb.sg_id
}

#app alb sould accept connections  from web  
resource "aws_security_group_rule" "app_alb_web" { #vpn accepting from home 
  source_security_group_id = module.web.sg_id
  type              = "ingress"
  from_port         = 80
  to_port           = 80
  protocol          = "tcp"
  security_group_id = module.app_alb.sg_id
}


#creating sg for vpn 
resource "aws_security_group_rule" "vpn_home" { #vpn accepting from home 
  security_group_id = module.vpn.sg_id
  type              = "ingress"
  from_port         = 0
  to_port           = 65535
  protocol          = "-1"
  cidr_blocks = ["0.0.0.0/0"]  # ideally your home ip address 
}


#mongodb accepting connection from catalogue to mongodb instance 
resource "aws_security_group_rule" "mongodb_vpn" {
  source_security_group_id = module.vpn.sg_id
  type              = "ingress"
  from_port         = 22
  to_port           = 22
  protocol          = "tcp"
  security_group_id = module.mongodb.sg_id
    
}
#mongodb accepting connection from catalogue to mongodb instance 
resource "aws_security_group_rule" "mongodb_catalogue" {
  source_security_group_id = module.catalogue.sg_id
  type              = "ingress"
  from_port         = 27017
  to_port           = 27017
  protocol          = "tcp"
  security_group_id = module.mongodb.sg_id
    
}

#mongodb accepting connection from user mongodb instance 
resource "aws_security_group_rule" "mongodb_user" {
  source_security_group_id = module.user.sg_id
  type              = "ingress"
  from_port         = 27017
  to_port           = 27017
  protocol          = "tcp"
  security_group_id = module.mongodb.sg_id
    
}

#mongodb accepting connection from user to redis  instance 
resource "aws_security_group_rule" "redis_vpn" {
  source_security_group_id = module.vpn.sg_id
  type              = "ingress"
  from_port         = 22
  to_port           = 22
  protocol          = "tcp"
  security_group_id = module.redis.sg_id
    
}
#mongodb accepting connection from user to redis  instance 
resource "aws_security_group_rule" "redis_user" {
  source_security_group_id = module.user.sg_id
  type              = "ingress"
  from_port         = 6379
  to_port           = 6379
  protocol          = "tcp"
  security_group_id = module.redis.sg_id
    
}

#mongodb accepting connection from user to redis  instance 
resource "aws_security_group_rule" "redis_cart" {
  source_security_group_id = module.cart.sg_id
  type              = "ingress"
  from_port         = 6379
  to_port           = 6379
  protocol          = "tcp"
  security_group_id = module.redis.sg_id
    
}

resource "aws_security_group_rule" "mysql_vpn" {
  source_security_group_id = module.vpn.sg_id
  type                     = "ingress"
  from_port                = 22
  to_port                  = 22
  protocol                 = "tcp"
  security_group_id        = module.mysql.sg_id
}

resource "aws_security_group_rule" "mysql_shipping" {
  source_security_group_id = module.shipping.sg_id
  type                     = "ingress"
  from_port                = 3306
  to_port                  = 3306
  protocol                 = "tcp"
  security_group_id        = module.mysql.sg_id
}


resource "aws_security_group_rule" "rabbitmq_vpn" {
  source_security_group_id = module.vpn.sg_id
  type                     = "ingress"
  from_port                = 22
  to_port                  = 22
  protocol                 = "tcp"
  security_group_id        = module.rabbitmq.sg_id
}

resource "aws_security_group_rule" "rabbitmq_payments" {
  source_security_group_id = module.payments.sg_id
  type                     = "ingress"
  from_port                = 5672
  to_port                  = 5672
  protocol                 = "tcp"
  security_group_id        = module.rabbitmq.sg_id
}

resource "aws_security_group_rule" "catalogue_vpn" {
  source_security_group_id = module.vpn.sg_id
  type                     = "ingress"
  from_port                = 22
  to_port                  = 22
  protocol                 = "tcp"
  security_group_id        = module.catalogue.sg_id
}
resource "aws_security_group_rule" "catalogue_vpn_http" {
  source_security_group_id = module.vpn.sg_id
  type                     = "ingress"
  from_port                = 8080
  to_port                  = 8080
  protocol                 = "tcp"
  security_group_id        = module.catalogue.sg_id
}
# resource "aws_security_group_rule" "catalogue_web" {
#   source_security_group_id = module.web.sg_id
#   type                     = "ingress"
#   from_port                = 8080
#   to_port                  = 8080
#   protocol                 = "tcp"
#   security_group_id        = module.catalogue.sg_id
# }

resource "aws_security_group_rule" "catalogue_app_alb" {
  source_security_group_id = module.app_alb.sg_id
  type                     = "ingress"
  from_port                = 8080
  to_port                  = 8080
  protocol                 = "tcp"
  security_group_id        = module.catalogue.sg_id
}

# resource "aws_security_group_rule" "catalogue_cart" {
#   source_security_group_id = module.cart.sg_id
#   type                     = "ingress"
#   from_port                = 8080
#   to_port                  = 8080
#   protocol                 = "tcp"
#   security_group_id        = module.catalogue.sg_id
# }

resource "aws_security_group_rule" "user_vpn" {
  source_security_group_id = module.vpn.sg_id
  type                     = "ingress"
  from_port                = 22
  to_port                  = 22
  protocol                 = "tcp"
  security_group_id        = module.user.sg_id
}
resource "aws_security_group_rule" "user_app_alb" {
  source_security_group_id = module.app_alb.sg_id
  type                     = "ingress"
  from_port                = 8080
  to_port                  = 8080
  protocol                 = "tcp"
  security_group_id        = module.user.sg_id
}
# resource "aws_security_group_rule" "user_web" {
#   source_security_group_id = module.web.sg_id
#   type                     = "ingress"
#   from_port                = 8080
#   to_port                  = 8080
#   protocol                 = "tcp"
#   security_group_id        = module.user.sg_id
# }

# resource "aws_security_group_rule" "user_payments" {
#   source_security_group_id = module.payments.sg_id
#   type                     = "ingress"
#   from_port                = 8080
#   to_port                  = 8080
#   protocol                 = "tcp"
#   security_group_id        = module.user.sg_id
# }

resource "aws_security_group_rule" "cart_vpn" {
  source_security_group_id = module.vpn.sg_id
  type                     = "ingress"
  from_port                = 22
  to_port                  = 22
  protocol                 = "tcp"
  security_group_id        = module.cart.sg_id
}

resource "aws_security_group_rule" "cart_web" {
  source_security_group_id = module.web.sg_id
  type                     = "ingress"
  from_port                = 8080
  to_port                  = 8080
  protocol                 = "tcp"
  security_group_id        = module.cart.sg_id
}

resource "aws_security_group_rule" "cart_shipping" {
  source_security_group_id = module.shipping.sg_id
  type                     = "ingress"
  from_port                = 8080
  to_port                  = 8080
  protocol                 = "tcp"
  security_group_id        = module.cart.sg_id
}

resource "aws_security_group_rule" "cart_payments" {
  source_security_group_id = module.payments.sg_id
  type                     = "ingress"
  from_port                = 8080
  to_port                  = 8080
  protocol                 = "tcp"
  security_group_id        = module.cart.sg_id
}

resource "aws_security_group_rule" "shipping_vpn" {
  source_security_group_id = module.vpn.sg_id
  type                     = "ingress"
  from_port                = 22
  to_port                  = 22
  protocol                 = "tcp"
  security_group_id        = module.shipping.sg_id
}

resource "aws_security_group_rule" "shipping_web" {
  source_security_group_id = module.web.sg_id
  type                     = "ingress"
  from_port                = 8080
  to_port                  = 8080
  protocol                 = "tcp"
  security_group_id        = module.shipping.sg_id
}

resource "aws_security_group_rule" "payment_vpn" {
  source_security_group_id = module.vpn.sg_id
  type                     = "ingress"
  from_port                = 22
  to_port                  = 22
  protocol                 = "tcp"
  security_group_id        = module.payments.sg_id
}

resource "aws_security_group_rule" "payment_web" {
  source_security_group_id = module.web.sg_id
  type                     = "ingress"
  from_port                = 8080
  to_port                  = 8080
  protocol                 = "tcp"
  security_group_id        = module.payments.sg_id
}

resource "aws_security_group_rule" "web_vpn" {
  source_security_group_id = module.vpn.sg_id
  type                     = "ingress"
  from_port                = 22
  to_port                  = 22
  protocol                 = "tcp"
  security_group_id        = module.web.sg_id
}

resource "aws_security_group_rule" "web_internet" {
  cidr_blocks = ["0.0.0.0/0"]
  type                     = "ingress"
  from_port                = 80
  to_port                  = 80
  protocol                 = "tcp"
  security_group_id        = module.web.sg_id
}