variable "region" {
  type = string
}

variable "log_group_name" {
  type = string
}

variable "protocol"{
  type = string
}

variable "email"{
  type = string
}

variable "s3_bucket_name"{
  type = string
}

variable "cloud_trail_trace_name"{
  type = string
}

variable "cloud_watch_policy_name"{
  type = string
}

variable "cloud_watch_role_name"{
  type = string
}

variable "sns_topic_name"{
  type = string
}

variable "event_bridge_rule_name"{
  type = string
}

variable "event_bridge_sns_role_name"{
  type = string
}