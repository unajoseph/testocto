variable "name" {
  type = list(string)
  default = ["queue_1","queue_2"]
}

variable "delay_seconds" {
  type = number
}

variable "max_message_size" {
  type = number
}

variable "messaage_retention_seconds" {
  type = number
}

variable "receive_wait_time_seconds" {
  type = number
}