output "queue_name" {
  description = "Name of the CloudTicket orders queue"
  value       = aws_sqs_queue.orders.name
}

output "queue_url" {
  description = "URL of the CloudTicket orders queue"
  value       = aws_sqs_queue.orders.url
}

output "queue_arn" {
  description = "ARN of the CloudTicket orders queue"
  value       = aws_sqs_queue.orders.arn
}
