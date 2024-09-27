variable "env" {
  type = string
  default = "staging"
}

variable "image_tag" {
  type = string
  default = "staging"
}

variable "machine_type" {
  default = "e2-small"
  type    = string
}

variable "network_name" {
  type = string
  default = "gkenet"
}

variable "subnet_name" {
  type = string
  default = "mysubnet"
}

variable "gke_node_cidr" {
  description = "The CIDR range for the GKE nodes"
  type        = string
  default     = "10.0.0.0/16"
}

variable "pods_cidr" {
  description = "The secondary CIDR range for pods"
  type        = string
  default     = "10.1.0.0/16"
}

variable "svc_cidr" {
  description = "The secondary CIDR range for services"
  type        = string
  default     = "10.2.0.0/20"
}

variable "kubernetes_version" {
  type = string
  default = "1.30"
}

variable "node_count" {
  default = "3"
  type    = string
}

variable "region" {
  type = string
  default = "europe-west1"

}