variable "region" {
  description = "AWS region in which to run the integration test."
  type        = string
  default     = "us-east-1"
}

variable "vpc_name" {
  description = "Name for the test VPC."
  type        = string
}

variable "cluster_name" {
  description = "Name for the test EKS cluster."
  type        = string
}

variable "instance_types" {
  description = "Instance types for the test node group."
  type        = list(string)
  default     = ["t3.medium"]
}

