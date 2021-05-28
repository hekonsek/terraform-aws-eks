module "eks" {
  source       = "terraform-aws-modules/eks/aws"
  version = "16.2.0"
  cluster_version = "1.18"
  cluster_name = var.cluster_name
  subnets      = var.vpc_private_subnets
  vpc_id = var.vpc_id
  enable_irsa = true

  worker_groups = [
    {
      name                          = "ondemand"
      instance_type                 = "m5.large"
      asg_desired_capacity          = 3
      additional_security_group_ids = [aws_security_group.worker_group_mgmt_one.id]
    },
    {
      name                = "spot"
      spot_price          = "0.199"
      instance_type       = "m5.large"
      asg_desired_capacity = 3
      kubelet_extra_args  = "--node-labels=node.kubernetes.io/lifecycle=spot"
      additional_security_group_ids = [aws_security_group.worker_group_mgmt_two.id]
      suspended_processes = ["AZRebalance"]
    },
  ]
}