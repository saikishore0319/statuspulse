# StatusPulse Modular Infrastructure (IaC)

Modular Terraform configuration to provision a production-ready AWS environment.

## Architecture
- **VPC Module**: Isolated network, public subnet, and Internet Gateway.
- **Security Group Module**: Firewall rules for SSH (restricted IP), HTTP, and HTTPS.
- **EC2 Module**: T2.Medium instance with Elastic IP and Termination Protection.

## Prerequisites
1. Terraform installed.
2. AWS CLI configured with valid credentials.

## Deployment Steps
1. `terraform init`
2. Create `terraform.tfvars`:
   ```hcl
   key_name       = "your-aws-key"
   ssh_allowed_ip = "your.home.ip/32"
   ```
3. `terraform apply`

## Outputs
The setup will output the `server_public_ip`. Use this IP for your GitHub Secrets and DNS configuration.
