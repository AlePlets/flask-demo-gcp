variable "project_id" {
  type        = string
  description = "ID do projeto GCP"
}

variable "region" {
  type        = string
  description = "Região GCP"
  
}

variable "name" {
  type        = string
  description = "Prefixo base para nome dos recursos"
}

variable "zone" {
  type        = string
  description = "Zona onde está a VM"
}

variable "instance_self_link" {
  type        = string
  description = "Self link da instância da VM"
}
