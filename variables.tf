# variables.tf

variable "cilium_version" {
  type        = string
  description = "Cilium Helm chart version"

  validation {
    condition     = can(regex("^[0-9]+\\.[0-9]+\\.[0-9]+", var.cilium_version))
    error_message = "cilium_version must start with X.Y.Z"
  }
}

variable "cluster_endpoint" {
  type        = string
  description = "Kubernetes API endpoint in the format https://host:port. When provided, injects k8sServiceHost and k8sServicePort into Cilium. Required for OKE if k8sServiceHost and k8sServicePort are not present in your values file."
  default     = null

  validation {
    condition     = var.cluster_endpoint == null || can(regex("^https://", var.cluster_endpoint))
    error_message = "cluster_endpoint must start with https://"
  }
}

variable "values_default" {
  type        = string
  description = "Selects a built-in Cilium values preset. Required when values_url and values_local are not set."
  default     = null
  nullable    = true

  validation {
    condition     = var.values_default == null || contains(["talos", "oke"], var.values_default)
    error_message = "Supported presets: talos, oke"
  }

  validation {
    condition     = !(var.values_default == null && var.values_url == null && var.values_local == null)
    error_message = "one of values_default, values_url, or values_local must be set"
  }
}

variable "values_local" {
  type        = string
  description = "Cilium Helm values as a YAML string, replaces the default values.yaml"
  default     = null
}

variable "values_url" {
  type        = string
  description = "URL to fetch Cilium Helm values from, replaces the default values.yaml"
  default     = null

  validation {
    condition     = var.values_url == null || can(regex("^https?://", var.values_url))
    error_message = "values_url must be a valid http or https URL"
  }
}
