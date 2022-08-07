resource "aws_db_subnet_group" "_" {
  subnet_ids  = module.vpc.private_subnets
}

# resource "aws_db_parameter_group" "default" {
#   name    = "rds-mysql"
#   family  = "mysql5.7"
#
#   parameter {
#     name  = "character_set_server"
#     value = "utf8"
#   }
#   parameter {
#     name  = "character_set_client"
#     value = "utf8"
#   }
# }

resource "aws_db_instance" "default" {
  allocated_storage       = 10
  engine                  = "mysql"
  engine_version          = "8.0.28"
  instance_class          = "db.t3.small"
  # parameter_group_name    = "default.mysql5.7"
  skip_final_snapshot     = true
  # db_subnet_group_name  = module.vpc.private_subnets[0]
  # db_subnet_group_name  = "${module.vpc.name}"
  db_subnet_group_name    = aws_db_subnet_group._.id
  # parameter_group_name    = aws_db_parameter_group.default.name
  vpc_security_group_ids  = ["${aws_security_group.rds.id}"]
  db_name                 = var.db_name
  username                = var.db_user
  password                = var.db_pass
}


# resource "aws_db_subnet_group" "myvpc" {
#   name                  = "k8s_vpc"
#   subnet_ids            = [
