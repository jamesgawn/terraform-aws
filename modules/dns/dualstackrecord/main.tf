variable "name" {
  type = string
}

variable "zone_id" {
  type = string
}

variable "a-records" {
  type = list(string)
}

variable "aaaa-records" {
  type = list(string)
}

resource "aws_route53_record" "a" {
  zone_id = var.zone_id
  name    = var.name
  type    = "A"
  ttl     = "300"

  records = var.a-records

  allow_overwrite = true
}

resource "aws_route53_record" "aaaa" {
  zone_id = var.zone_id
  name    = var.name
  type    = "AAAA"
  ttl     = "300"

  records = var.aaaa-records

  allow_overwrite = true
}

output "name" {
  value = aws_route53_record.a.name
}

output "zone_id" {
  value = aws_route53_record.a.zone_id
}

