// Resource for Dead Letter Queue
resource "aws_sqs_queue" "dead_letter_queue" {
    count = length(var.name)
    name                      = "${var.name[count.index]}-dlq"
    delay_seconds             = var.delay_seconds
    max_message_size          = var.max_message_size
    message_retention_seconds = var.messaage_retention_seconds
    receive_wait_time_seconds = var.receive_wait_time_seconds
  }
  
  // Resource for Main queue. It has attached the dead letter queue as redrive policy
  
  resource "aws_sqs_queue" "main_queue" {
    count = length(var.name)
    name                      = var.name[count.index]
    delay_seconds             = var.delay_seconds
    max_message_size          = var.max_message_size
    message_retention_seconds = var.messaage_retention_seconds
    receive_wait_time_seconds = var.receive_wait_time_seconds
    redrive_policy = jsonencode({
      deadLetterTargetArn = aws_sqs_queue.dead_letter_queue[count.index].arn
      maxReceiveCount     = 4
    })
    redrive_allow_policy = jsonencode({
      redrivePermission = "byQueue",
      sourceQueueArns   = ["${aws_sqs_queue.dead_letter_queue[count.index].arn}"]
    })
  
  }
  
  // Policy allow sqs:SendMessage to the main
  
  // TODO : NEED TO FIGURE OUT TO SEND THE MAIN QUEUE COUNT ID
  
  resource "aws_sqs_queue_policy" "send_message_main" {
    count = length(var.name)
    queue_url = aws_sqs_queue.main_queue[count.index].id
  
    policy = <<POLICY
  {
    "Version": "2012-10-17",
    "Statement": [
      {
        "Sid": "First",
        "Effect": "Allow",
        "Action": ["sqs:SendMessage"],
        "Resource": "${aws_sqs_queue.main_queue[count.index].arn}"
      }
    ]
  }
  POLICY
  }
  
  // Policy allow sqs:ReceiveMessage and sqs:DeleteMessage to Main Queue
  
  resource "aws_sqs_queue_policy" "receive_delete_message_main" {
    count = length(var.name)
    queue_url = aws_sqs_queue.main_queue[count.index].id
  
    policy = <<POLICY
  {
    "Version": "2012-10-17",
    "Statement": [
      {
        "Sid": "First",
        "Effect": "Allow",
        "Action": ["sqs:ReceiveMessage","sqs:DeleteMessage"],
        "Resource": "${aws_sqs_queue.main_queue[count.index].arn}"
      }
    ]
  }
  POLICY
  }
  
  // Policy allow sqs:ReceiveMessage and sqs:DeleteMessage to Dead Letter queue
  
  resource "aws_sqs_queue_policy" "receive_delete_message_dlq" {
    count = length(var.name)
    queue_url = aws_sqs_queue.dead_letter_queue[count.index].id
  
    policy = <<POLICY
  {
    "Version": "2012-10-17",
    "Statement": [
      {
        "Sid": "First",
        "Effect": "Allow",
        "Action": ["sqs:SendMessage","sqs:DeleteMessage"],
        "Resource": "${aws_sqs_queue.dead_letter_queue[count.index].arn}"
      }
    ]
  }
  POLICY
  }
  
  locals {
    dlq_queue_arns_map = { for r in aws_sqs_queue.dead_letter_queue : r.name => r.arn }
    main_queue_arns_map = { for r in aws_sqs_queue.main_queue : r.name => r.arn }
    dlq_consume_policy_arns_map = { for r in aws_sqs_queue_policy.receive_delete_message_dlq : r.id => r.policy }
    main_consume_policy_arns_map = { for r in aws_sqs_queue_policy.receive_delete_message_main : r.id => r.policy }
    main_consume_sendmsg_policy_arns_map = {for r in aws_sqs_queue_policy.send_message_main : r.id => r.policy }
  }