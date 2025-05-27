variable "project_id" {
  type        = string
  description = "ID do projeto"
}

variable "region" {
  type        = string
  description = "Região para o NAT e o router"
}

variable "network_self_link" {
  type        = string
  description = "Self link da VPC existente"
}

variable "router_name" {
  type        = string
  description = "Nome do Cloud Router"
}

variable "nat_name" {
  type        = string
  description = "Nome do Cloud NAT"
}

variable "enable_logging" {
  type        = bool
  default     = false
  description = "Habilita o Cloud NAT Logging"
}
