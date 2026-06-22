# Terraform module for AWS EKS

This module creates a basic Amazon EKS cluster for small product teams. It creates one standard EKS managed node group backed by EC2 instances; it does **not** create Fargate profiles.

Features:

- Creates the EKS control plane and its IAM role.
- Creates one standard managed node group in private subnets, with the IAM permissions required for worker nodes, VPC CNI, and ECR image pulls.
- Installs the `vpc-cni`, `coredns`, and `kube-proxy` EKS add-ons.
- Supports private API access and optional public API access.
- Includes a live Terratest integration test that provisions [terraform-aws-vpc](https://github.com/hekonsek/terraform-aws-vpc) and passes its private subnet IDs to EKS.

## Usage

```hcl
provider "aws" {
  region = "us-east-1"
}

module "vpc" {
  source = "git::https://github.com/hekonsek/terraform-aws-vpc.git"

  network_name = "dev"
  cluster_name = "dev-eks"
}

module "eks" {
  source = "git::https://github.com/hekonsek/terraform-aws-eks.git"

  name               = "dev-eks"
  vpc_id             = module.vpc.vpc_id
  private_subnet_ids = module.vpc.private_subnet_ids

  instance_types = ["t3.medium"]
  desired_size   = 1
  min_size       = 1
  max_size       = 2
}
```

The VPC's private subnets must have egress access. The referenced VPC module provides this through its NAT gateway by default.

<!-- BEGIN_TF_DOCS -->
## Inputs

| Name | Description | Type | Default | Required |
|---|---|---|---|:---:|
| `name` | EKS cluster name | `string` | n/a | yes |
| `vpc_id` | VPC ID for the EKS cluster | `string` | n/a | yes |
| `private_subnet_ids` | Private subnet IDs for the cluster and node group | `list(string)` | n/a | yes |
| `kubernetes_version` | Optional Kubernetes version | `string` | `null` | no |
| `node_group_name` | Managed node group name | `string` | `"default"` | no |
| `instance_types` | Node EC2 instance types | `list(string)` | `["t3.medium"]` | no |
| `capacity_type` | `ON_DEMAND` or `SPOT` | `string` | `"ON_DEMAND"` | no |
| `desired_size` / `min_size` / `max_size` | Node group scaling settings | `number` | `1` / `1` / `2` | no |
| `disk_size` | Node root disk size in GiB | `number` | `20` | no |
| `endpoint_private_access` | Enable private Kubernetes API endpoint | `bool` | `true` | no |
| `endpoint_public_access` | Enable public Kubernetes API endpoint | `bool` | `true` | no |
| `endpoint_public_access_cidrs` | CIDRs allowed to reach the public endpoint | `list(string)` | `["0.0.0.0/0"]` | no |
| `enabled_cluster_log_types` | Control-plane logs sent to CloudWatch Logs | `list(string)` | `[]` | no |
| `tags` | Additional resource tags | `map(string)` | `{}` | no |

## Outputs

| Name | Description |
|---|---|
| `cluster_name` / `cluster_arn` | EKS cluster identifiers |
| `cluster_endpoint` | Kubernetes API endpoint |
| `cluster_certificate_authority_data` | API certificate authority data |
| `cluster_oidc_issuer_url` | OIDC issuer URL for IAM roles for service accounts |
| `node_group_name` / `node_group_arn` | Managed node group identifiers |
| `aws_eks_update_kubeconfig_command` | Command to configure `kubectl` access |
| `aws_console_cluster_url` | AWS Console link for the cluster |
<!-- END_TF_DOCS -->

## Testing

The integration test creates real VPC, NAT gateway, EKS, and EC2 resources, then destroys them. It requires Terraform, Go, AWS credentials, and an AWS region.

```bash
export AWS_REGION=us-east-1
make test
```

Set `TERRATEST_SKIP_DEPLOY=1` to compile the Terratest package without creating AWS resources. Interrupted tests can leave billable resources behind; clean up resources with the generated `eks-test-` prefix.

## License

MIT
