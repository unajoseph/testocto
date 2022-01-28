output "main_queue_arn" {
  value = local.main_queue_arns_map
}

output "dlq_queue_arns" {
  value = local.dlq_queue_arns_map
}

output "dlq_policy_arn" {
  value = local.dlq_consume_policy_arns_map
}

output "main_policy_arn" {
  value = local.main_consume_policy_arns_map
}

output "main_sendmsg_policy" {
  value = local.main_consume_sendmsg_policy_arns_map
}