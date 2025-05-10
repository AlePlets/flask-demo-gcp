variable "project_id" {
  type        = string
  description = "ID do projeto GCP"
}

variable "instance_name" {
  type        = string
  description = "Nome da instância Cloud SQL"
}

variable "region" {
  type        = string
  default     = "us-central1"
  description = "Região da instância"
}

variable "tier" {
  type        = string
  default     = "db-custom-1-3840"
  description = "Tipo de máquina do Cloud SQL"
}

variable "vpc" {
  type        = string
  description = "Self link da rede VPC"
}

variable "peering_ip" {
  type        = string
  default     = "10.60.8.0"
  description = "IP reservado para peering com Cloud SQL"
}

variable "peering_prefix" {
  type        = number
  default     = 24
  description = "Prefix length do IP reservado"
}

variable "peering_network" {
  
}