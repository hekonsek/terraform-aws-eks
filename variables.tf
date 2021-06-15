variable "vpc_id" {
    type = string
}

variable "vpc_private_subnets" {
  type = list(string)
}

variable "cluster_name" {
  type = string
}

variable "cluster_node_type" {
  type = string
  default = "m5.large"
}

variable "cluster_node_ondemand_count" {
  default = 1
}

variable "cluster_node_spot_count" {
  default = 1
}