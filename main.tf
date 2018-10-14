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

terraform {
  backend "s3" {
    bucket = "ana-terraform-state-global"
    key = "ana-terraform-state-global/terraform.tfstate"
    profile = "terraform"
    region = "eu-west-2"
  }
}