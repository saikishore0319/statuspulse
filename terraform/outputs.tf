output "server_public_ip" {
  description = "The Elastic IP address of the StatusPulse server"
  value       = module.ec2.public_ip
}

output "ssh_command" {
  description = "Command to SSH into the server"
  value       = "ssh -i /path/to/your/key.pem ubuntu@${module.ec2.public_ip}"
}
