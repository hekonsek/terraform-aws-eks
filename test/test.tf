terraform {
  required_version = ">= 1.5.0"

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = ">= 6.0.0"
    }
  }
}

provider "aws" {
  region = var.region
}

module "vpc" {
  source = "git::https://github.com/hekonsek/terraform-aws-vpc.git"

  network_name = var.vpc_name
  cluster_name = var.cluster_name
}

module "eks" {
  source = "./.."

  name               = var.cluster_name
  vpc_id             = module.vpc.vpc_id
  private_subnet_ids = module.vpc.private_subnet_ids
  instance_types     = var.instance_types
}

output "cluster_name" {
  value = module.eks.cluster_name
}

output "cluster_arn" {
  value = module.eks.cluster_arn
}

output "node_group_name" {
  value = module.eks.node_group_name
}

output "node_group_arn" {
  value = module.eks.node_group_arn
}

