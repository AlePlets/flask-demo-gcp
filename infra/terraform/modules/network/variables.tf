variable "project_id" {
  type        = string
  description = "ID do projeto GCP"
}

variable "vpc_name" {
  type        = string
  description = "Nome da VPC"
}

variable "subnet_name" {
  type        = string
  description = "Nome da subnet"
}

variable "subnet_cidr" {
  type        = string
  description = "CIDR da subnet (ex: 10.10.0.0/24)"
}

variable "region" {
  type        = string
  description = "Região da subnet"
}
