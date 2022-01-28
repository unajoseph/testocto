locals {
  delay_seconds             = 60
  max_message_size          = 1024
  message_retention_seconds = 86400
  receive_wait_time_seconds = 10
  queue_name = ["priority-10", "priority-100"]
}

provider "aws" {
  region     = "us-east-1"
  access_key = "AKIA2XEHX4AFPSXXWB5E"
  secret_key = "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"
}

module "sqs_queues" {
  source = "./modules/sqs"
  name = local.queue_name
  delay_seconds = local.delay_seconds
  max_message_size = local.max_message_size
  messaage_retention_seconds = local.message_retention_seconds
  receive_wait_time_seconds = local.receive_wait_time_seconds

}