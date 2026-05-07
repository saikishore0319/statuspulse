output "server_public_ip" {
  description = "The Elastic IP address of the StatusPulse server"
  value       = module.ec2.public_ip
}

output "ssh_command" {
  description = "Command to SSH into the server"
  value       = "ssh -p 2222 -i /path/to/your/key.pem ubuntu@${module.ec2.public_ip}"
}

output "backup_bucket_name" {
  description = "The name of the S3 bucket created for backups"
  value       = module.s3.bucket_name
}
