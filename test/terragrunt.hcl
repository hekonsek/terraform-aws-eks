locals {
  project = "clails-eks"
}

generate "provider" {
  path = "provider.tf"
  if_exists = "overwrite_terragrunt"
  contents = <<EOF
provider "aws" {
  version = ">= 2.28.1"
  region  = "us-east-1"
}
EOF
}