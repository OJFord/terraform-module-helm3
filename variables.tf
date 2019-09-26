variable "chart" {
  description = "Chart to apply"
  type = object({
    name    = string
    version = string
  })
}

variable "release" {
  description = "Name of the release"
  type        = string
}

variable "values" {
  description = "Values to supply the Chart"
  type        = map
  default     = {}
}
