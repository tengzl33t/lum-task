output "healthcheck_subnet_id" {
  value = aws_subnet.healthcheck_subnet.id
}

output "healthcheck_sg_id" {
  value = aws_security_group.healthcheck_sg.id
}