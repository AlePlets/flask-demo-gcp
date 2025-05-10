variable "project_id" {
  type        = string
  description = "ID do projeto GCP"
}

variable "instance_name" {
  type        = string
  description = "Nome da instância"
}

variable "machine_type" {
  type        = string
  default     = "e2-micro"
  description = "Tipo da máquina"
}

variable "region" {
  type        = string
  description = "Região da instância e do IP"
}


variable "zone" {
  type        = string
  description = "Zona da instância (ex: us-central1-a)"
}

variable "image" {
  type        = string
  default     = "projects/debian-cloud/global/images/family/debian-11"
  description = "Imagem do SO"
}

variable "subnet" {
  type        = string
  description = "Self link ou nome da subnet"
}

variable "service_account_email" {
  type        = string
  description = "Email da conta de serviço com permissões adequadas"
}

# variable "startup_script" {
#   type        = string
#   default     = "#!/bin/bash\necho 'Hello from VM!' > /var/www/html/index.html"
#   description = "Script de inicialização para provisionamento básico"
# }
