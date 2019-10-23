# ecs

terraform {
  backend "s3" {
    region = "ap-northeast-2"
    bucket = "terraform-nalbam-seoul"
    key    = "ecs-cluster.tfstate"
  }
  required_version = ">= 0.12"
}

provider "aws" {
  region = var.region
}

module "ecs" {
  source = "../../"

  region = var.region
  name   = var.name
}
