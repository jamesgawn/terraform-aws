variable "ana-host-ipv4" {
  type = list(string)
}

variable "ana-host-ipv6" {
  type = list(string)
}

module "sb-com" {
  source = "./scary-biscuits"

  domain = "scary-biscuits.com"

  googleauthkey = "google._domainkey"
  googleauthvalue = "v=DKIM1; k=rsa; p=MIGfMA0GCSqGSIb3DQEBAQUAA4GNADCBiQKBgQCtB0hx2A74wFRMPTZex0k6MxoFzeiE9ISxjPxo6FMc4E5KKL+PzWQNfPQtw82AynJRTDyGGYVoxTH9y1SYySMbflYbiiQsAo8cSKtJcaSPrzrnCuyFKaykwh/LD56U2NzkdZoJkXrBjU/f5sdVOILZEjSl0IDAR0+eUyTpx6BtDQIDAQAB"
  ana-host-ipv4 = var.ana-host-ipv4
  ana-host-ipv6 = var.ana-host-ipv6
}

module "sb-co-uk" {
  source = "./scary-biscuits"

  domain = "scary-biscuits.co.uk"

  googleauthkey = "google._domainkey"
  googleauthvalue = "v=DKIM1; k=rsa; p=MIGfMA0GCSqGSIb3DQEBAQUAA4GNADCBiQKBgQCqDrpKLNKCds0rZ3QGLYZZIG+IA6JD96OUVTTKmmo1oeUy5NGjByzSSMdgm6HxzZ0XqTwRnjebz6AW3gUeP4orKdjmj9ocecxYTcuLz1yQaAoeVcuM8c3ls0HiVK0cnHLbaDkXWu0p6e2ENzosCPoVFaFHHk8gpCizDJJGFLUPswIDAQAB"
  ana-host-ipv4 = var.ana-host-ipv4
  ana-host-ipv6 = var.ana-host-ipv6
}

module "gawn-uk" {
  source = "./gawn"

  domain = "gawn.uk"

  googleauthkey = "mailauth._domainkey"
  googleauthvalue = "v=DKIM1; k=rsa; p=MIGfMA0GCSqGSIb3DQEBAQUAA4GNADCBiQKBgQCSKIualHjOyfzkR6VWrMTx3vPzZhwzUcu0VMZFRYxPNh8X2l0dWeZJdCn5W+wLaVFK6PnYerrDW6b0lGzVPE/QDlgAGCG8MkqyLf85PTqHxXtEba4ykdqJZAL9fueiTI1Imf0KMiY13yro+IaVB8E6LL51wUQfOlpBbbA/K/Pb8wIDAQAB"
  ana-host-ipv4 = var.ana-host-ipv4
  ana-host-ipv6 = var.ana-host-ipv6
}

module "gawn-co-uk" {
  source = "./gawn"

  domain = "gawn.co.uk"

  googleauthkey = "gawn._domainkey"
  googleauthvalue = "v=DKIM1; k=rsa; p=MIGfMA0GCSqGSIb3DQEBAQUAA4GNADCBiQKBgQCSx1x+RX9Y6Gt6kZgumhbVl+l0x+dX883XW7yzuFi/nQEKQ4HTcCvq1T+jfyatrzPD4XmsaP+JhccAdS2I7m8RkOCE/Yk0AQpxyB7NTL/0macCVBdOzWgMbGFXfCicj0sVZRNdvpQGVmAgtPVLmNzh5Lfx8ASOmXj6WLlo3048IwIDAQAB"
  ana-host-ipv4 = var.ana-host-ipv4
  ana-host-ipv6 = var.ana-host-ipv6
}

resource "aws_route53_record" "gawn-uk-opera" {
  zone_id = module.gawn-uk.zone_id
  name = "opera.${module.gawn-uk.zone_name}"
  type    = "CNAME"
  ttl     = "300"

  records = ["domains.tumblr.com"]
}

resource "aws_route53_record" "gawn-uk-tumblr" {
  zone_id = module.gawn-uk.zone_id
  name = "tumblr.${module.gawn-uk.zone_name}"
  type    = "CNAME"
  ttl     = "300"

  records = ["domains.tumblr.com"]
}

resource "aws_route53_record" "gawn-uk-learning" {
  zone_id = module.gawn-uk.zone_id
  name = "learning.${module.gawn-uk.zone_name}"
  type    = "CNAME"
  ttl     = "300"

  records = ["jamesgawn.github.io"]
}
