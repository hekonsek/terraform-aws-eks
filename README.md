# Terraform module for AWS EKS

This module creates a basic Amazon EKS cluster for small product teams. It creates one standard EKS managed node group backed by EC2 instances; it does **not** create Fargate profiles.

Features:

- Creates the EKS control plane and its IAM role.
- Creates one standard managed node group in private subnets, with the IAM permissions required for worker nodes, VPC CNI, and ECR image pulls.
- Installs the `vpc-cni`, `coredns`, `kube-proxy`, and `metrics-server` EKS add-ons.
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
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 1.5.0 |
| <a name="requirement_aws"></a> [aws](#requirement\_aws) | >= 6.0.0 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_aws"></a> [aws](#provider\_aws) | >= 6.0.0 |

## Modules

No modules.

## Resources

| Name | Type |
|------|------|
| [aws_eks_addon.coredns](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/eks_addon) | resource |
| [aws_eks_addon.kube_proxy](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/eks_addon) | resource |
| [aws_eks_addon.metrics_server](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/eks_addon) | resource |
| [aws_eks_addon.vpc_cni](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/eks_addon) | resource |
| [aws_eks_cluster.cluster](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/eks_cluster) | resource |
| [aws_eks_node_group.default](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/eks_node_group) | resource |
| [aws_iam_role.cluster](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role) | resource |
| [aws_iam_role.node](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role) | resource |
| [aws_iam_role_policy_attachment.cluster](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role_policy_attachment) | resource |
| [aws_iam_role_policy_attachment.node_cni](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role_policy_attachment) | resource |
| [aws_iam_role_policy_attachment.node_ecr](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role_policy_attachment) | resource |
| [aws_iam_role_policy_attachment.node_worker](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role_policy_attachment) | resource |
| [aws_region.current](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/region) | data source |
| [aws_subnet.private](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/subnet) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_capacity_type"></a> [capacity\_type](#input\_capacity\_type) | Capacity type for the managed node group: ON\_DEMAND or SPOT. | `string` | `"ON_DEMAND"` | no |
| <a name="input_coredns_addon_version"></a> [coredns\_addon\_version](#input\_coredns\_addon\_version) | CoreDNS EKS add-on version. | `string` | `"v1.14.3-eksbuild.3"` | no |
| <a name="input_desired_size"></a> [desired\_size](#input\_desired\_size) | Desired number of nodes in the managed node group. | `number` | `1` | no |
| <a name="input_disk_size"></a> [disk\_size](#input\_disk\_size) | Disk size in GiB for each managed node. | `number` | `20` | no |
| <a name="input_enabled_cluster_log_types"></a> [enabled\_cluster\_log\_types](#input\_enabled\_cluster\_log\_types) | Control plane log types to send to CloudWatch Logs. | `list(string)` | `[]` | no |
| <a name="input_endpoint_private_access"></a> [endpoint\_private\_access](#input\_endpoint\_private\_access) | Whether to enable the private EKS Kubernetes API endpoint. | `bool` | `true` | no |
| <a name="input_endpoint_public_access"></a> [endpoint\_public\_access](#input\_endpoint\_public\_access) | Whether to enable the public EKS Kubernetes API endpoint. | `bool` | `true` | no |
| <a name="input_endpoint_public_access_cidrs"></a> [endpoint\_public\_access\_cidrs](#input\_endpoint\_public\_access\_cidrs) | CIDR blocks allowed to reach the public Kubernetes API endpoint. Ignored when endpoint\_public\_access is false. | `list(string)` | <pre>[<br/>  "0.0.0.0/0"<br/>]</pre> | no |
| <a name="input_instance_types"></a> [instance\_types](#input\_instance\_types) | EC2 instance types used by the managed node group. | `list(string)` | <pre>[<br/>  "t3.medium"<br/>]</pre> | no |
| <a name="input_kubernetes_version"></a> [kubernetes\_version](#input\_kubernetes\_version) | Optional Kubernetes version for the EKS cluster. Leave null to use the AWS default supported version. | `string` | `"1.36"` | no |
| <a name="input_max_size"></a> [max\_size](#input\_max\_size) | Maximum number of nodes in the managed node group. | `number` | `2` | no |
| <a name="input_min_size"></a> [min\_size](#input\_min\_size) | Minimum number of nodes in the managed node group. | `number` | `1` | no |
| <a name="input_name"></a> [name](#input\_name) | Name of the EKS cluster. | `string` | n/a | yes |
| <a name="input_node_group_name"></a> [node\_group\_name](#input\_node\_group\_name) | Name of the standard EKS managed node group. | `string` | `"default"` | no |
| <a name="input_private_subnet_ids"></a> [private\_subnet\_ids](#input\_private\_subnet\_ids) | IDs of the private subnets for the EKS control plane and managed node group. The subnets need outbound internet access, for example through a NAT gateway. | `list(string)` | n/a | yes |
| <a name="input_tags"></a> [tags](#input\_tags) | Additional tags to apply to resources created by this module. | `map(string)` | `{}` | no |
| <a name="input_vpc_id"></a> [vpc\_id](#input\_vpc\_id) | ID of the VPC in which to create the EKS cluster. | `string` | n/a | yes |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_aws_console_cluster_url"></a> [aws\_console\_cluster\_url](#output\_aws\_console\_cluster\_url) | AWS Console URL for this EKS cluster. |
| <a name="output_aws_eks_update_kubeconfig_command"></a> [aws\_eks\_update\_kubeconfig\_command](#output\_aws\_eks\_update\_kubeconfig\_command) | AWS CLI command for adding this EKS cluster to the local kubeconfig. |
| <a name="output_cluster_arn"></a> [cluster\_arn](#output\_cluster\_arn) | ARN of the EKS cluster. |
| <a name="output_cluster_certificate_authority_data"></a> [cluster\_certificate\_authority\_data](#output\_cluster\_certificate\_authority\_data) | Base64-encoded certificate authority data for the EKS Kubernetes API server. |
| <a name="output_cluster_endpoint"></a> [cluster\_endpoint](#output\_cluster\_endpoint) | Endpoint for the EKS Kubernetes API server. |
| <a name="output_cluster_name"></a> [cluster\_name](#output\_cluster\_name) | Name of the EKS cluster. |
| <a name="output_cluster_oidc_issuer_url"></a> [cluster\_oidc\_issuer\_url](#output\_cluster\_oidc\_issuer\_url) | OpenID Connect issuer URL for the EKS cluster. |
| <a name="output_node_group_arn"></a> [node\_group\_arn](#output\_node\_group\_arn) | ARN of the standard EKS managed node group. |
| <a name="output_node_group_name"></a> [node\_group\_name](#output\_node\_group\_name) | Name of the standard EKS managed node group. |
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
