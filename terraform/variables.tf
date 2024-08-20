variable "region" {
  type = string
}

variable "subscription_id_prod" {
  description = "ID da subscription para o ambiente de produção"
  type        = string
}

variable "subscription_id_dev" {
  description = "ID da subscription para o ambiente de desenvolvimento"
  type        = string
}
