 # NOTE: Uncomment this block only after running terraform apply first
# to create the S3 bucket and DynamoDB table.

# terraform {
#   backend "s3" {
#     bucket         = "terraform-state-adaobi-123456"
#     key            = "envs/prod/terraform.tfstate"
#     region         = "us-east-1"
#     encrypt        = true
#     dynamodb_table = "terraform-state-lock"
#   }
# }