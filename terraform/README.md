# StatusPulse Modular Terraform Infrastructure

This directory contains modular Infrastructure as Code (IaC) to provision a production-ready AWS environment.

## Modular Structure
- **`modules/vpc`**: Handles VPC, Subnets, Internet Gateway, and Routing.
- **`modules/security_group`**: Encapsulates firewall rules for the web server.
- **`modules/ec2`**: Provisions the EC2 instance and Elastic IP.

## Prerequisites
1. [Terraform](https://developer.hashicorp.com/terraform/downloads) installed locally.
2. AWS Credentials configured.
3. A DuckDNS account (Token and Domain).

## Usage Instructions

1.  **Initialize**: `terraform init`
2.  **Configure**: Create `terraform.tfvars`:
    ```hcl
    key_name       = "your-key"
    ssh_allowed_ip = "your.ip.addr/32"
    ```
3.  **Apply**: `terraform apply`

## DNS Setup (DuckDNS)
Since we are using DuckDNS, no Route53 resources are provisioned. 
2. Get your Token and Domain from [duckdns.org](https://www.duckdns.org/).
2. On your server, add these to your `.env` file:
   ```env
   DUCKDNS_DOMAIN=statuspulse1
   DUCKDNS_TOKEN=your-token
   ```
3. Schedule the update script via crontab:
   ```bash
   */5 * * * * /home/ubuntu/statuspulse/scripts/update-dns.sh
   ```
