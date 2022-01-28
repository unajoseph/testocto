output "dead_letter_queue" {
  value = module.sqs_queues.dlq_queue_arns
}

output "main_queue" {
  value = module.sqs_queues.main_queue_arn
}

output "dead_letter_policy" {
  value = module.sqs_queues.dlq_policy_arn
}

output "main_queue_policy" {
  value = module.sqs_queues.main_policy_arn
}

output "main_queue_sendmsg_policy" {
  value = module.sqs_queues.main_sendmsg_policy
}