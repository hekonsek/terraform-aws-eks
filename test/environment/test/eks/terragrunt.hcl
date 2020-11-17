locals {
  project = read_terragrunt_config("../../../terragrunt.hcl")
  environment = read_terragrunt_config("../terragrunt.hcl")
  environment_full = "${local.project.locals.project}-${local.environment.locals.environment}"
}

dependency "vpc" {
  config_path = "../vpc"
}

terraform {
  source = "../../../.."
}

include {
  path = find_in_parent_folders()
}

inputs = {
  cluster_name = "${local.environment_full}"
  vpc_id = dependency.vpc.outputs.vpc_id
  vpc_private_subnets = dependency.vpc.outputs.vpc_private_subnets
}

generate "provider" {
  path = "provider.tf"
  if_exists = "overwrite_terragrunt"
  contents = <<EOF
data "aws_eks_cluster" "cluster" {
  name = module.eks.cluster_id
}

data "aws_eks_cluster_auth" "cluster" {
  name = module.eks.cluster_id
}

provider "kubernetes" {
  load_config_file       = "false"
  host                   = data.aws_eks_cluster.cluster.endpoint
  token                  = data.aws_eks_cluster_auth.cluster.token
  cluster_ca_certificate = base64decode(data.aws_eks_cluster.cluster.certificate_authority.0.data)
}
EOF
}