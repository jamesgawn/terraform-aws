variable "profile" {
  type = string
  default = "default"
}

variable "region" {
  type = string
  default = "eu-west-2"
}

provider "aws" {
  region = var.region
  profile = var.profile
}

provider "aws" {
  alias = "us-east-1"

  region = "us-east-1"
  profile = var.profile
}

provider "aws" {
  alias = "eu-west-1"

  region = "eu-west-1"
  profile = var.profile
}

terraform {
  backend "s3" {
    bucket = "ana-terraform-state"
    key = "global/terraform.tfstate"
    region = "eu-west-2"
  }
}

resource "aws_guardduty_detector" "master" {
  enable = true
}

data aws_instance "ana" {
  instance_id = "i-0dfc4294ee146be56"
}

// The DNS confguration for globally managed domain names
module "dns" {
  source = "./dns"
}

// Domain names
data "aws_route53_zone" "gawn_uk" {
  name         = "gawn.uk."
}

data "aws_route53_zone" "gawn_co_uk" {
  name         = "gawn.co.uk."
}

// The generic SNS queue used for alarms
data "aws_sns_topic" "alarm_sns" {
  name = "EmergencyNotificationList"
}