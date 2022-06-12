
data aws_sns_topic "alarm_topic" {
  provider = aws.us-east-1
  name = "UrgentIssue"
}

module "health_check_gawn_uk" {
  source = "./modules/website-health-check"
  providers = {
    aws.default = aws,
    aws.us-east-1 = aws.us-east-1 
   }
  fqdn = "gawn.uk"
  sns_arn = data.aws_sns_topic.alarm_topic.arn
}

module "health_check_www_gawn_uk" {
  source = "./modules/website-health-check"
  providers = {
    aws.default = aws,
    aws.us-east-1 = aws.us-east-1 
   }
  fqdn = "www.gawn.uk"
  sns_arn = data.aws_sns_topic.alarm_topic.arn
}

module "health_check_gawn_co_uk" {
  source = "./modules/website-health-check"
  providers = {
    aws.default = aws,
    aws.us-east-1 = aws.us-east-1 
   }
  fqdn = "gawn.co.uk"
  sns_arn = data.aws_sns_topic.alarm_topic.arn
}

module "health_check_www_gawn_co_uk" {
  source = "./modules/website-health-check"
  providers = {
    aws.default = aws,
    aws.us-east-1 = aws.us-east-1 
   }
  fqdn = "www.gawn.co.uk"
  sns_arn = data.aws_sns_topic.alarm_topic.arn
}

module "health_check_gawn_dev" {
  source = "./modules/website-health-check"
  providers = {
    aws.default = aws,
    aws.us-east-1 = aws.us-east-1 
   }
  fqdn = "gawn.dev"
  sns_arn = data.aws_sns_topic.alarm_topic.arn
}

module "health_check_www_gawn_dev" {
  source = "./modules/website-health-check"
  providers = {
    aws.default = aws,
    aws.us-east-1 = aws.us-east-1 
   }
  fqdn = "www.gawn.dev"
  sns_arn = data.aws_sns_topic.alarm_topic.arn
}