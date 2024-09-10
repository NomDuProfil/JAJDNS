resource "aws_iam_role" "jajdns_ssm_role" {
  name = "jajdns_${var.name}_ssm_role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [{
      Action    = "sts:AssumeRole"
      Effect    = "Allow"
      Principal = {
        Service = "ec2.amazonaws.com"
      }
    }]
  })
  tags = var.common_tags
}

resource "aws_iam_policy_attachment" "jajdns_ssm_role_attach" {
  name       = "jajdns_${var.name}_ssm_role_attach"
  roles      = [aws_iam_role.jajdns_ssm_role.name]
  policy_arn = "arn:aws:iam::aws:policy/AmazonSSMManagedInstanceCore"
}

resource "aws_iam_instance_profile" "jajdns_ec2_instance_profile" {
  name = "jajdns_${var.name}_ec2_instance_profile"
  role = aws_iam_role.jajdns_ssm_role.name
  tags = var.common_tags
}

data "aws_ami" "jajdns_last_linux_image" {
  most_recent = true
  owners = ["amazon"]

  filter {
    name   = "name"
    values = ["amzn2-ami-hvm-*-gp2"]
  }

  filter {
    name   = "architecture"
    values = ["arm64"]
  }

  filter {
    name = "root-device-type"
    values = ["ebs"]
  }

  filter {
    name = "virtualization-type"
    values = ["hvm"]
  }

}

data "aws_vpc" "jajdns_default_vpc" {
  default = true
}

resource "aws_security_group" "jajdns_sg" {
  name        = "jajdns_${var.name}_sg"
  description = "Allow DNS inbound traffic"
  vpc_id      = data.aws_vpc.jajdns_default_vpc.id

  ingress {
    from_port   = 53
    to_port     = 53
    protocol    = "udp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_instance" "jajdns_ec2_instance" {
  ami                    = data.aws_ami.jajdns_last_linux_image.image_id
  instance_type          = "t4g.nano"
  root_block_device {
    volume_size = var.volume_size
    volume_type = "gp2"
  }
  iam_instance_profile   = aws_iam_instance_profile.jajdns_ec2_instance_profile.name
  key_name = aws_key_pair.jajdns_key_pair.key_name

  user_data = templatefile("${path.module}/install_script.sh.tpl", {
    ns_domain = "${var.ns_subdomain}",
    password = "${random_password.jajdns_generated_password.result}"
  })

  tags = {
    Name = var.name
    Project = "JAJDNS"
  }

  vpc_security_group_ids = [aws_security_group.jajdns_sg.id]

  metadata_options {
    http_tokens   = "required"
    http_endpoint = "enabled"
  }
}

resource "aws_key_pair" "jajdns_key_pair" {
  key_name   = "jajdns_${var.name}_ssh_key"
  public_key = tls_private_key.jajdns_tls_private.public_key_openssh
  tags = var.common_tags
}

resource "tls_private_key" "jajdns_tls_private" {
  algorithm = "RSA"
  rsa_bits  = 4096
}

resource "local_file" "private_key_pem" {
  filename = "jajdns_${var.name}_private_key.pem"
  content  = tls_private_key.jajdns_tls_private.private_key_pem
}