variable "aws_region" {
  description = "Região AWS"
  type        = string
  default     = "us-east-1"
}

variable "db_name" {
  description = "Nome do banco de dados"
  type        = string
  default     = "oficina"
}

variable "db_username" {
  description = "Usuário master do banco"
  type        = string
  default     = "postgres"
}

variable "db_password" {
  description = "Senha do banco de dados"
  type        = string
  sensitive   = true
}

variable "db_instance_class" {
  description = "Classe da instância RDS (db.t3.micro = free tier)"
  type        = string
  default     = "db.t3.micro"
}

variable "allowed_cidr_blocks" {
  description = "CIDRs com acesso ao banco (VPC do EKS + Lambda)"
  type        = list(string)
  default     = ["10.0.0.0/16"]
}

variable "publicly_accessible" {
  description = "Banco acessível publicamente (apenas para desenvolvimento)"
  type        = bool
  default     = false
}
