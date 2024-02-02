// Setup SQS
resource "aws_sqs_queue" "sqs" {
  name = var.aws_optional_conf.sqs_queue_name
  tags = var.aws_optional_conf.tags

  depends_on = [aws_sns_topic_policy.sns]
}

resource "aws_sqs_queue_policy" "sqs" {
  queue_url = aws_sqs_queue.sqs.id
  policy = templatefile("${path.module}/aws_sqs_queue_policy.tpl", {
    sns_arn = aws_sns_topic.sns.arn
  })
}

resource "aws_sns_topic_subscription" "sqs" {
  topic_arn  = aws_sns_topic.sns.arn
  protocol   = "sqs"
  endpoint   = aws_sqs_queue.sqs.arn
  depends_on = [aws_sqs_queue_policy.sqs]
}
