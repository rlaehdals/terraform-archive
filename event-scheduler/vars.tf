variable "sns_name" {
  type = string
}

variable "sqs_name" {
  type = string
}

variable "event_bridge_name" {
  type = string
}

variable "event_bridge_scheduler_cron" {
  type = string
}

variable "region" {
  type = string
}

variable "tags" {
  type = map(any)
}

variable "event_scheduler_role"{
  type = string
}