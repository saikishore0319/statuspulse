resource "aws_instance" "app_server" {
  ami                    = var.ami_id
  instance_type          = var.instance_type
  subnet_id              = var.subnet_id
  vpc_security_group_ids = [var.security_group_id]
  key_name               = var.key_name

  root_block_device {
    volume_size = var.root_volume_size
    volume_type = "gp3"
  }

  disable_api_termination = var.enable_termination_protection
  iam_instance_profile    = var.iam_instance_profile

  tags = {
    Name        = "${var.project_name}-server"
    Environment = "Production"
  }
}

resource "aws_eip" "app_server_eip" {
  instance = aws_instance.app_server.id
  domain   = "vpc"
  tags     = { Name = "${var.project_name}-eip" }
}
