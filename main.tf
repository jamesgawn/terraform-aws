variable "profile" {
  type = "string",
  default = "terraform"
}

variable "region" {
  type = "string",
  default = "eu-west-2"
}

provider "aws" {
  region = "${var.region}"
  profile = "${var.profile}"
}

provider "aws" {
  alias = "us-east-1"

  region = "us-east-1"
  profile = "${var.profile}"
}

terraform {
  backend "s3" {
    bucket = "ana-terraform-state"
    key = "global/terraform.tfstate"
    profile = "terraform"
    region = "eu-west-2"
  }
}

resource "aws_guardduty_detector" "master" {
  enable = true
}

variable "ana-host-ipv4" {
  type = "string"
  default = "35.177.49.58"
}

variable "ana-host-ipv6" {
  type = "string"
  default = "2a05:d01c:99:e300:3182:c1a3:ef58:1b67"
}

// The DNS confguration for globally managed domain names
module "dns" {
  source = "dns"

  ana-host-ipv4 = ["${var.ana-host-ipv4}"]
  ana-host-ipv6 = ["${var.ana-host-ipv6}"]
}

// The AWS Cert Manager for globally managed domain names
data "aws_acm_certificate" "gawn" {
  provider = "aws.us-east-1"

  domain   = "*.gawn.uk"
  statuses = ["ISSUED"]
}

data "aws_acm_certificate" "sb" {
  provider = "aws.us-east-1"

  domain   = "*.scary-biscuits.com"
  statuses = ["ISSUED"]
}
