resource "aws_db_instance" "default" {
  allocated_storage     = 10
  engine                = "mysql"
  engine_version        = "5.7"
  instance_class        = "db.t3.small"
  parameter_group_name  = "default.mysql5.7"
  skip_final_snapshot   = true
  db_subnet_group_name  = module.vpc.private_subnets[0]
  db_name               = var.db_name
  username              = var.db_user
  password              = var.db_pass
}
