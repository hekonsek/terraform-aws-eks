variable "name" {
  description = "Name of the EKS cluster."
  type        = string

  validation {
    condition     = can(regex("^[0-9A-Za-z][A-Za-z0-9_-]{0,99}$", var.name))
    error_message = "name must be 1-100 characters long, start with an alphanumeric character, and contain only alphanumeric characters, hyphens, and underscores."
  }
}

variable "vpc_id" {
  description = "ID of the VPC in which to create the EKS cluster."
  type        = string
}

variable "private_subnet_ids" {
  description = "IDs of the private subnets for the EKS control plane and managed node group. The subnets need outbound internet access, for example through a NAT gateway."
  type        = list(string)

  validation {
    condition     = length(var.private_subnet_ids) >= 2
    error_message = "private_subnet_ids must contain at least two subnets in different Availability Zones, as required by EKS."
  }
}

variable "kubernetes_version" {
  description = "Optional Kubernetes version for the EKS cluster. Leave null to use the AWS default supported version."
  type        = string
  default     = "1.36"
}

variable "authentication_mode" {
  description = "EKS cluster authentication mode. Use API_AND_CONFIG_MAP or API to enable EKS access entries."
  type        = string
  default     = "CONFIG_MAP"

  validation {
    condition     = contains(["CONFIG_MAP", "API_AND_CONFIG_MAP", "API"], var.authentication_mode)
    error_message = "authentication_mode must be CONFIG_MAP, API_AND_CONFIG_MAP, or API."
  }
}

variable "coredns_addon_version" {
  description = "CoreDNS EKS add-on version."
  type        = string
  default     = "v1.14.3-eksbuild.3"
}

variable "node_group_name" {
  description = "Name of the standard EKS managed node group."
  type        = string
  default     = "default"
}

variable "instance_types" {
  description = "EC2 instance types used by the managed node group."
  type        = list(string)
  default     = ["t3.medium"]
}

variable "capacity_type" {
  description = "Capacity type for the managed node group: ON_DEMAND or SPOT."
  type        = string
  default     = "ON_DEMAND"

  validation {
    condition     = contains(["ON_DEMAND", "SPOT"], var.capacity_type)
    error_message = "capacity_type must be ON_DEMAND or SPOT."
  }
}

variable "desired_size" {
  description = "Desired number of nodes in the managed node group."
  type        = number
  default     = 1

  validation {
    condition     = var.desired_size >= 1
    error_message = "desired_size must be at least 1."
  }
}

variable "min_size" {
  description = "Minimum number of nodes in the managed node group."
  type        = number
  default     = 1

  validation {
    condition     = var.min_size >= 1
    error_message = "min_size must be at least 1."
  }
}

variable "max_size" {
  description = "Maximum number of nodes in the managed node group."
  type        = number
  default     = 2

  validation {
    condition     = var.max_size >= 1
    error_message = "max_size must be at least 1."
  }
}

variable "disk_size" {
  description = "Disk size in GiB for each managed node."
  type        = number
  default     = 20

  validation {
    condition     = var.disk_size >= 20
    error_message = "disk_size must be at least 20 GiB."
  }
}

variable "endpoint_private_access" {
  description = "Whether to enable the private EKS Kubernetes API endpoint."
  type        = bool
  default     = true
}

variable "endpoint_public_access" {
  description = "Whether to enable the public EKS Kubernetes API endpoint."
  type        = bool
  default     = true
}

variable "endpoint_public_access_cidrs" {
  description = "CIDR blocks allowed to reach the public Kubernetes API endpoint. Ignored when endpoint_public_access is false."
  type        = list(string)
  default     = ["0.0.0.0/0"]

  validation {
    condition     = alltrue([for cidr in var.endpoint_public_access_cidrs : can(cidrhost(cidr, 0))])
    error_message = "endpoint_public_access_cidrs must contain valid CIDR blocks."
  }
}

variable "enabled_cluster_log_types" {
  description = "Control plane log types to send to CloudWatch Logs."
  type        = list(string)
  default     = []

  validation {
    condition     = alltrue([for log_type in var.enabled_cluster_log_types : contains(["api", "audit", "authenticator", "controllerManager", "scheduler"], log_type)])
    error_message = "enabled_cluster_log_types may only contain api, audit, authenticator, controllerManager, or scheduler."
  }
}

variable "tags" {
  description = "Additional tags to apply to resources created by this module."
  type        = map(string)
  default     = {}
}
