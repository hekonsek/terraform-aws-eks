output "cluster_name" {
  description = "Name of the EKS cluster."
  value       = aws_eks_cluster.cluster.name
}

output "cluster_arn" {
  description = "ARN of the EKS cluster."
  value       = aws_eks_cluster.cluster.arn
}

output "cluster_endpoint" {
  description = "Endpoint for the EKS Kubernetes API server."
  value       = aws_eks_cluster.cluster.endpoint
}

output "cluster_certificate_authority_data" {
  description = "Base64-encoded certificate authority data for the EKS Kubernetes API server."
  value       = aws_eks_cluster.cluster.certificate_authority[0].data
}

output "cluster_oidc_issuer_url" {
  description = "OpenID Connect issuer URL for the EKS cluster."
  value       = aws_eks_cluster.cluster.identity[0].oidc[0].issuer
}

output "node_group_name" {
  description = "Name of the standard EKS managed node group."
  value       = aws_eks_node_group.default.node_group_name
}

output "node_group_arn" {
  description = "ARN of the standard EKS managed node group."
  value       = aws_eks_node_group.default.arn
}

output "aws_eks_update_kubeconfig_command" {
  description = "AWS CLI command for adding this EKS cluster to the local kubeconfig."
  value       = "aws eks update-kubeconfig --region ${data.aws_region.current.region} --name ${aws_eks_cluster.cluster.name}"
}

output "aws_console_cluster_url" {
  description = "AWS Console URL for this EKS cluster."
  value       = "https://${data.aws_region.current.region}.console.aws.amazon.com/eks/home?region=${data.aws_region.current.region}#/clusters/${aws_eks_cluster.cluster.name}"
}
