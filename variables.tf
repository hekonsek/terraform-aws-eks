variable "vpc_id" {
    type = string
}

variable "vpc_private_subnets" {
  type = list(string)
}

variable "cluster_name" {
  type = string
}
