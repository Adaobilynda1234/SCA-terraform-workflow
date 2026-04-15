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

* Understand Terraform workflow (`init`, `plan`, `apply`, `destroy`)
* Explain Terraform state management
* Configure a remote backend using AWS
* Demonstrate real command execution with screenshots

---

## 📁 Project Structure

```
terraform-workflow-assignment/
│
├── question-1-state-file/
│   └── answer.md
│
├── question-2-local-state-risk/
│   └── answer.md
│
├── question-3-remote-backend/
│   └── answer.md
│
├── question-4-s3-backend-example/
│   └── answer.md
│
├── terraform-config/
│   └── main.tf
│
├── screenshots/
│   ├── terraform-init.png
│   ├── terraform-plan.png
│   ├── terraform-apply.png
│   └── terraform-destroy.png
│
├── .gitignore
└── README.md
```

---

## ⚙️ Terraform Workflow

The following Terraform commands were executed:

### 1️⃣ Initialize Terraform

```bash
terraform init
```

### 2️⃣ Plan Infrastructure

```bash
terraform plan
```

### 3️⃣ Apply Configuration

```bash
terraform apply
```

### 4️⃣ Destroy Infrastructure

```bash
terraform destroy
```

---

## 📸 Screenshots

All Terraform command outputs are captured and stored in the `screenshots/` folder:

* `terraform-init.png`
* `terraform-plan.png`
* `terraform-apply.png`
* `terraform-destroy.png`

These serve as proof of successful execution.

---

## 📄 Answers to Questions

Each question is answered in its respective folder:

* **Question 1:** Terraform State File → `question-1-state-file/`
* **Question 2:** Local State Risks → `question-2-local-state-risk/`
* **Question 3:** Remote Backend → `question-3-remote-backend/`
* **Question 4:** S3 Backend Example → `question-4-s3-backend-example/`

---

## ☁️ Remote Backend Configuration

Terraform was configured to use an **AWS S3 remote backend** with **DynamoDB state locking**.

### 🔹 Example Backend Configuration

```hcl
terraform {
  backend "s3" {
    bucket         = "my-terraform-state-bucket-adaobi-123"
    key            = "terraform/state.tfstate"
    region         = "us-east-1"
    dynamodb_table = "terraform-lock-table"
    encrypt        = true
  }
}
```

### ✅ Why This Matters

* Enables team collaboration
* Prevents state conflicts
* Provides state locking
* Ensures secure and persistent storage

---

## 📄 Terraform Configuration File

The main Terraform configuration is located at:

```
terraform-config/main.tf
```

This file was updated to include:

* AWS provider configuration
* Example resource (S3 bucket)
* Remote backend configuration

---

## 🚀 How to Run This Project

### 1. Install Requirements

* Terraform
* AWS CLI

### 2. Configure AWS

```bash
aws configure
```

### 3. Navigate to Terraform Folder

```bash
cd terraform-config
```

### 4. Run Terraform Commands

```bash
terraform init
terraform plan
terraform apply
terraform destroy
```

---

## ⚠️ Notes

* S3 bucket names must be globally unique
* Ensure AWS credentials are properly configured
* DynamoDB table is required for state locking
* Always run `terraform destroy` to avoid unnecessary costs

---

## 💡 Key Learnings

* Terraform state is critical for infrastructure tracking
* Local state is unsafe for team collaboration
* Remote backends improve reliability and scalability
* AWS S3 + DynamoDB is a common production setup

---

## ✅ Conclusion

This project successfully demonstrates the complete Terraform workflow and highlights best practices for managing infrastructure state in a collaborative environment.

---

