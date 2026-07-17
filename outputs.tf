output "db_endpoint" {
  description = "Endpoint do RDS PostgreSQL"
  value       = aws_db_instance.oficina.address
}

output "db_port" {
  description = "Porta do banco"
  value       = aws_db_instance.oficina.port
}

output "db_name" {
  description = "Nome do banco"
  value       = aws_db_instance.oficina.db_name
}

output "vpc_id" {
  description = "ID da VPC compartilhada (consumida pelo repo oficina-infra-k8s)"
  value       = aws_vpc.oficina.id
}

output "private_subnet_ids" {
  description = "Subnets privadas (EKS nodes + Lambda)"
  value       = [aws_subnet.private_a.id, aws_subnet.private_b.id]
}

output "public_subnet_ids" {
  description = "Subnets públicas (load balancers)"
  value       = [aws_subnet.public_a.id, aws_subnet.public_b.id]
}

output "db_security_group_id" {
  description = "Security group do banco"
  value       = aws_security_group.db.id
}
