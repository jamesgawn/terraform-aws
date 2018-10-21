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

// Domain names
data "aws_route53_zone" "gawn_uk" {
  name         = "gawn.uk."
}

data "aws_route53_zone" "gawn_co_uk" {
  name         = "gawn.co.uk."
}

data "aws_route53_zone" "scary_biscuits_com" {
  name         = "scary-biscuits.com."
}

data "aws_route53_zone" "scary_biscuits_co_uk" {
  name         = "scary-biscuits.co.uk."
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

// files.gawn.uk

module "files_gawn_uk" {
  source = "github.com/jamesgawn/ana-terraform-shared.git/cloudfront-distribution-via-s3"

  site-name = "website-gawn-subdomain-files"
  cert-domain = "*.gawn.uk"
  site-domains = ["files.gawn.uk", "files.gawn.co.uk"]
  root = "index.html"
  s3_force_destroy = false
}

module "gawn_uk" {
  source = "github.com/jamesgawn/ana-terraform-shared.git/dns/dualstackaliasrecord"

  zone_id = "${data.aws_route53_zone.gawn_uk.zone_id}"
  name = "files.${data.aws_route53_zone.gawn_uk.name}"
  alias-target = "${module.files_gawn_uk.domain_name}"
  alias-hosted-zone-id = "${module.files_gawn_uk.hosted_zone_id}"
}

module "gawn_co_uk" {
  source = "github.com/jamesgawn/ana-terraform-shared.git/dns/dualstackaliasrecord"

  zone_id = "${data.aws_route53_zone.gawn_co_uk.zone_id}"
  name = "files.${data.aws_route53_zone.gawn_co_uk.name}"
  alias-target = "${module.files_gawn_uk.domain_name}"
  alias-hosted-zone-id = "${module.files_gawn_uk.hosted_zone_id}"
}

// files.scary-biscuits.com

module "files_scary_biscuits_com" {
  source = "github.com/jamesgawn/ana-terraform-shared.git/cloudfront-distribution-via-s3"

  site-name = "website-scary-biscuits-subdomain-files"
  cert-domain = "*.scary-biscuits.com"
  site-domains = ["files.scary-biscuits.com", "files.scary-biscuits.co.uk"]
  root = "index.html"
  s3_force_destroy = false
}

module "scary_biscuits_com" {
  source = "github.com/jamesgawn/ana-terraform-shared.git/dns/dualstackaliasrecord"

  zone_id = "${data.aws_route53_zone.scary_biscuits_com.zone_id}"
  name = "files.${data.aws_route53_zone.scary_biscuits_com.name}"
  alias-target = "${module.files_scary_biscuits_com.domain_name}"
  alias-hosted-zone-id = "${module.files_scary_biscuits_com.hosted_zone_id}"
}

module "scary_biscuits_co_uk" {
  source = "github.com/jamesgawn/ana-terraform-shared.git/dns/dualstackaliasrecord"

  zone_id = "${data.aws_route53_zone.scary_biscuits_co_uk.zone_id}"
  name = "files.${data.aws_route53_zone.scary_biscuits_co_uk.name}"
  alias-target = "${module.files_scary_biscuits_com.domain_name}"
  alias-hosted-zone-id = "${module.files_scary_biscuits_com.hosted_zone_id}"
}