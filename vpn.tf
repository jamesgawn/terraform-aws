/*
 * This creates a VPN site-to-site connection server. In addition to this configuration you also need to manually:
 * - Add the VPN server as the target for the home CIDR destination.
 * - Add inbound traffic (or suitably restricted alternatives) rules with the vpn-server security group as the source to any security groups that you wish to allow access to via the VPN connection.
 */

variable vpc {
  type = string
}
variable homeGatewayIp {
  type = string
}
variable homeNetworkCidr {
  type = string
}
variable vpnSharedSecret {
  type = string
}

data "aws_vpc" "network" {
  id = var.vpc
}

resource "aws_security_group" "server_security_group" {
  name        = "vpn-server-sg"
  description = "Allow VPN Services In"
  vpc_id      = data.aws_vpc.network.id

  ingress {
    from_port   = 4500
    to_port     = 4500
    protocol    = "udp"
    cidr_blocks = ["${var.homeGatewayIp}/32"]
  }

  ingress {
    from_port   = 4500
    to_port     = 4500
    protocol    = "tcp"
    cidr_blocks = ["${var.homeGatewayIp}/32"]
  }

  ingress {
    from_port   = 500
    to_port     = 500
    protocol    = "udp"
    cidr_blocks = ["${var.homeGatewayIp}/32"]
  }

  ingress {
    from_port   = 500
    to_port     = 500
    protocol    = "tcp"
    cidr_blocks = ["${var.homeGatewayIp}/32"]
  }

  ingress {
    from_port   = 0
    to_port     = 0
    protocol    = "51"
    cidr_blocks = ["${var.homeGatewayIp}/32"]
  }

  ingress {
    from_port   = -1
    to_port     = -1
    protocol    = "icmp"
    cidr_blocks = ["${var.homeGatewayIp}/32"]
  }

  ingress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = [data.aws_vpc.network.cidr_block, var.homeNetworkCidr]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    ipv6_cidr_blocks = ["::/0"]
  }
}

data "aws_ami" "amazon-linux-2" {
  most_recent = true

  filter {
    name   = "owner-alias"
    values = ["amazon"]
  }

  filter {
    name   = "name"
    values = ["amzn2-ami-hvm*"]
  }

  owners = ["137112412989"]
}

data "template_file" "server-cloud-init" {
  template = file("./cloudinit.cfg")
  vars = {
    VPN_SHARED_SECRET = var.vpnSharedSecret
    AWS_NETWORK_CIDR = data.aws_vpc.network.cidr_block
    HOME_GATEWAY_IP = var.homeGatewayIp
    HOME_NETWORK_CIDR = var.homeNetworkCidr
  }
}

data "aws_iam_role" "ec2instancerole" {
  name = "EC2SystemManagerRole"
}

resource "aws_instance" "server" {
  ami                  = data.aws_ami.amazon-linux-2.id
  instance_type        = "t3a.nano"
  iam_instance_profile = data.aws_iam_role.ec2instancerole.name

  user_data = data.template_file.server-cloud-init.rendered
  source_dest_check = false

  vpc_security_group_ids = [aws_security_group.server_security_group.id]

  tags = {
    Name = "vpn-server"
  }
}

output "vpn-server-ip" {
  value = aws_instance.server.public_ip
}