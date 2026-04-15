# 🌍 Terraform Workflow, State & Remote Backend Assignment

## 📌 Overview

This project demonstrates a practical understanding of Terraform workflow, state management, and remote backend configuration using AWS S3 and DynamoDB.

The assignment covers:

* Terraform state file purpose
* Risks of local state in team environments
* Remote backend concepts
* S3 backend configuration with state locking

---

## 🎯 Objectives

* Understand Terraform workflow (`init`, `validate`, `plan`, `apply`, `destroy`)
* Explain Terraform state management
* Configure a remote backend using AWS S3 + DynamoDB
* Demonstrate real command execution with screenshots

---

## 📁 Project Structure

```
terraform-workflow/
│
├── questions/
│   ├── question-1-state-file/
│   │   └── answer.md          ← What is the Terraform state file used for?
│   ├── question-2-state-risk/
│   │   └── answer.md          ← Why is storing state locally risky in a team environment?
│   ├── question-3-remote-backend/
│   │   └── answer.md          ← What is a remote backend?
│   └── q4-s3-backend-example/
│       └── backend.tf         ← S3 remote backend configuration block
│
├── terraform-config/
│   ├── provider.tf            ← Terraform version + AWS provider block
│   ├── variables.tf           ← All input variables
│   ├── main.tf                ← S3 bucket + DynamoDB resources
│   ├── outputs.tf             ← Output values
│   ├── backend.tf             ← Remote S3 backend configuration
│   └── .gitignore             ← Ignores state files, .terraform/, secrets
│
├── screenshots/
│   ├── terraform-init.png
│   ├── terraform-validate.png
│   ├── terraform-plan.png
│   ├── terraform-apply.png
│   ├── terraform-state-list.png
│   ├── terraform-backend-migrate.png
│   ├── aws-s3-console.png
│   ├── aws-dynamodb-console.png
│   └── terraform-destroy.png
│
└── README.md
```

---

## ⚙️ Terraform Configuration Files

The configuration is split across multiple files following standard Terraform project conventions.

### `provider.tf`
Defines the required Terraform version and AWS provider.

```hcl
terraform {
  required_version = ">= 1.5.0"

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
}

provider "aws" {
  region = var.aws_region
}
```

---

### `variables.tf`
Declares all input variables used across the configuration.

```hcl
variable "aws_region" {
  description = "AWS region to deploy resources into"
  type        = string
  default     = "us-east-1"
}

variable "environment" {
  description = "Deployment environment tag"
  type        = string
  default     = "prod"
}

variable "bucket_name" {
  description = "Globally unique name for the S3 state bucket"
  type        = string
  default     = "terraform-state-adaobi-123456"
}

variable "dynamodb_table_name" {
  description = "DynamoDB table name for state locking"
  type        = string
  default     = "terraform-state-lock"
}
```

---

### `main.tf`
Defines all AWS resources — S3 bucket (with versioning, encryption, public access block) and DynamoDB lock table.

```hcl
resource "aws_s3_bucket" "terraform_state" {
  bucket = var.bucket_name

  tags = {
    Name        = "Terraform State Bucket"
    Environment = var.environment
    ManagedBy   = "Terraform"
  }
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

resource "aws_s3_bucket_public_access_block" "terraform_state" {
  bucket = aws_s3_bucket.terraform_state.id

  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}

resource "aws_dynamodb_table" "terraform_state_lock" {
  name         = var.dynamodb_table_name
  billing_mode = "PAY_PER_REQUEST"
  hash_key     = "LockID"

  attribute {
    name = "LockID"
    type = "S"
  }

  tags = {
    Name        = "Terraform State Lock Table"
    Environment = var.environment
    ManagedBy   = "Terraform"
  }
}
```

---

### `outputs.tf`
Prints useful values after a successful apply.

```hcl
output "state_bucket_name" {
  description = "S3 bucket storing Terraform state"
  value       = aws_s3_bucket.terraform_state.id
}

output "state_bucket_arn" {
  description = "ARN of the S3 state bucket"
  value       = aws_s3_bucket.terraform_state.arn
}

output "lock_table_name" {
  description = "DynamoDB table used for state locking"
  value       = aws_dynamodb_table.terraform_state_lock.name
}
```

---

### `backend.tf`
Configures Terraform to store state remotely in S3 and lock via DynamoDB. Added after the first `terraform apply`.

```hcl
terraform {
  backend "s3" {
    bucket         = "terraform-state-adaobi-123456"
    key            = "envs/prod/terraform.tfstate"
    region         = "us-east-1"
    encrypt        = true
    dynamodb_table = "terraform-state-lock"
  }
}
```

---

## 🚀 How to Run This Project

### Prerequisites
* Terraform `>= 1.5.0` installed
* AWS CLI installed and configured (`aws configure`)
* IAM user with S3 and DynamoDB permissions

### Step 1 — Verify AWS connection
```bash
aws sts get-caller-identity
```

### Step 2 — Navigate to config folder
```bash
cd terraform-config
```

### Step 3 — Initialize Terraform
```bash
terraform init
```

### Step 4 — Validate syntax
```bash
terraform validate
```

### Step 5 — Preview changes
```bash
terraform plan
```

### Step 6 — Apply (creates AWS resources)
```bash
terraform apply
```
Type `yes` when prompted.

### Step 7 — Migrate state to S3 backend
Add the `backend.tf` file then run:
```bash
terraform init -migrate-state
```
Type `yes` when prompted.

### Step 8 — Confirm state
```bash
terraform state list
```

### Step 9 — Destroy (cleanup)
```bash
terraform destroy
```

---

## ☁️ Remote Backend Configuration

Terraform was configured to use an **AWS S3 remote backend** with **DynamoDB state locking**.

| Component | AWS Resource | Purpose |
|---|---|---|
| State storage | S3 bucket | Stores `terraform.tfstate` remotely |
| State locking | DynamoDB table | Prevents concurrent `apply` conflicts |
| Encryption | AES256 (SSE) | Protects sensitive state data at rest |
| Versioning | S3 versioning | Allows state rollback |

---

## 📸 Screenshots

All Terraform command outputs are in the `screenshots/` folder:

| File | Command |
|---|---|
| `terraform-init.png` | `terraform init` |
| `terraform-validate.png` | `terraform validate` |
| `terraform-plan.png` | `terraform plan` |
| `terraform-apply.png` | `terraform apply` |
| `terraform-state-list.png` | `terraform state list` |
| `terraform-backend-migrate.png` | `terraform init -migrate-state` |
| `aws-s3-console.png` | AWS Console — S3 bucket |
| `aws-dynamodb-console.png` | AWS Console — DynamoDB table |
| `terraform-destroy.png` | `terraform destroy` |

---

## 📄 Answers to Questions

| # | Question | File |
|---|---|---|
| 1 | What is the Terraform state file used for? | `questions/q1/answer.md` |
| 2 | Why is storing state locally risky in a team environment? | `questions/q2/answer.md` |
| 3 | What is a remote backend? | `questions/q3/answer.md` |
| 4 | Write an example backend block for an S3 remote backend | `questions/q4/answer.md` |

---

## ⚠️ Notes

* S3 bucket names must be **globally unique** across all AWS accounts
* Ensure AWS credentials are properly configured before running any commands
* DynamoDB table must have a primary key named exactly `LockID`
* Always run `terraform destroy` after the assignment to avoid unnecessary AWS costs
* Never commit `.tfstate` files or `.terraform/` directory to version control

---

## 💡 Key Learnings

* Terraform state is critical for tracking real infrastructure
* Local state is unsafe for team collaboration
* Remote backends with S3 + DynamoDB is the standard production setup
* Splitting `.tf` files (`provider.tf`, `variables.tf`, `main.tf`, `outputs.tf`, `backend.tf`) improves maintainability
* `prevent_destroy = true` protects critical resources from accidental deletion

---

## ✅ Conclusion

This project successfully demonstrates the complete Terraform workflow and highlights best practices for managing infrastructure state in a collaborative environment using AWS S3 and DynamoDB as a remote backend.

## Author

**Adaobi Okwuosa**  
Date: April 2026