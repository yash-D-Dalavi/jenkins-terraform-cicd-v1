output "instance_id" {
  description = "ID of the deployed EC2 instance"
  value       = aws_instance.web_server.id
}

output "instance_public_ip" {
  description = "Public IP address of the deployed EC2 instance"
  value       = aws_instance.web_server.public_ip
}