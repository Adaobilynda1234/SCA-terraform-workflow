output "state_bucket_name" {
  description = "S3 bucket storing Terraform state"
  value       = aws_s3_bucket.terraform_state.id
}

output "lock_table_name" {
  description = "DynamoDB table used for state locking"
  value       = aws_dynamodb_table.terraform_state_lock.name
}

output "state_bucket_arn" {
  description = "ARN of the S3 state bucket"
  value       = aws_s3_bucket.terraform_state.arn
}