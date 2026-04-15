# Q4: S3 Remote Backend Configuration Block

## Answer

Below is a complete, annotated S3 backend block. This goes inside any `.tf` file (typically `main.tf` or a dedicated `backend.tf`).

### Backend Block

```hcl
terraform {
  backend "s3" {
    # S3 bucket where state is stored — must exist before terraform init
    bucket = "my-terraform-state-bucket"

    # Path (key) for the state file inside the bucket
    key = "envs/prod/terraform.tfstate"

    # AWS region where the bucket lives
    region = "us-east-1"

    # Enable server-side encryption for the state file
    encrypt = true

    # DynamoDB table for state locking and consistency checking
    # Table must have a primary key named "LockID" (String)
    dynamodb_table = "terraform-state-lock"

    # Optional: specific AWS profile from ~/.aws/credentials
    # profile = "my-aws-profile"
  }
}
```

### Required AWS Resources (pre-create before `terraform init`)

**S3 Bucket:**
```hcl
resource "aws_s3_bucket" "terraform_state" {
  bucket = "my-terraform-state-bucket"
}

resource "aws_s3_bucket_versioning" "terraform_state" {
  bucket = aws_s3_bucket.terraform_state.id
  versioning_configuration {
    status = "Enabled"
  }
}

resource "aws_s3_bucket_server_side_encryption_configuration" "terraform_state" {
  bucket = aws_s3_bucket.terraform_state.id
  rule {
    apply_server_side_encryption_by_default {
      sse_algorithm = "AES256"
    }
  }
}
```

**DynamoDB Lock Table:**
```hcl
resource "aws_dynamodb_table" "terraform_state_lock" {
  name         = "terraform-state-lock"
  billing_mode = "PAY_PER_REQUEST"
  hash_key     = "LockID"       # Must be exactly "LockID"

  attribute {
    name = "LockID"
    type = "S"
  }
}
```

### Initialize the Backend

```bash
terraform init
# Terraform will prompt: "Do you want to copy existing state to the new backend?"
# Type: yes
```

### How Locking Works

```
terraform apply
  │
  ├─► Acquires lock in DynamoDB (LockID = <state path>)
  ├─► Reads current state from S3
  ├─► Applies changes
  ├─► Writes new state to S3
  └─► Releases DynamoDB lock
```

