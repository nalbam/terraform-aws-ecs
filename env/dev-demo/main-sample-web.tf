# ecs fargate

module "sample_web" {
  source = "../../modules/fargate"

  region = "${var.region}"
  stage  = "${var.stage}"

  cluster_id         = "${module.ecs.cluster_id}"
  cluster_name       = "${module.ecs.cluster_name}"
  vpc_id             = "${module.ecs.vpc_id}"
  subnet_public_ids  = "${module.ecs.subnet_public_ids}"
  subnet_private_ids = "${module.ecs.subnet_private_ids}"

  name    = "sample-web"
  image   = "nalbam/sample-web"
  port    = "80"
  cpu     = "256"
  memory  = "512"
  desired = "1"
  min     = "1"
  max     = "5"

  base_domain = "nalbam.com"
}

output "sample_web_app_name" {
  value = "${module.sample_web.app_name}"
}

output "sample_web_alb_dns_name" {
  value = "${module.sample_web.alb_dns_name}"
}

output "sample_web_dns_name" {
  value = "${module.sample_web.dns_name}"
}
