variable "name" {
  type = string
}

variable "zone_id" {
  type = string
}

resource "aws_route53_zone" "child-zone" {
  name = var.name
}

resource "aws_route53_record" "ns" {
  zone_id = var.zone_id
  name    = var.name
  type    = "NS"
  ttl     = "300"
  records = aws_route53_zone.child-zone.name_servers
  
  allow_overwrite = true
}

output "name" {
  value = aws_route53_zone.child-zone.name
}

output "zone_id" {
  value = aws_route53_zone.child-zone.zone_id
}