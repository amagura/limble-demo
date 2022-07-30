resource "aws_db_instance" "default" {
  allocated_storage     = 10
  engine                = "mysql"
  engine_version        = "5.7"
  instance_class        = "db.t3.small"
  name                  = "demodb"
  username              = "lidem"
  password              = "Lithuanian UnknowingsHesit ance sAmarium"
  parameter_group_name  = "default.mysql5.7"
  skip_final_snapshot   = true
  db_subnet_group_name  = module.vpc.private_subnets
}
