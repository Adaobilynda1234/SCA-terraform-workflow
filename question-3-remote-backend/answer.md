# Q3: What is a Remote Backend?

## Answer

A **remote backend** tells Terraform to store and retrieve its state file from a remote, shared location instead of the local filesystem.

### How it Works

When you configure a remote backend:
1. `terraform init` connects to the remote backend and downloads state.
2. `terraform apply` **locks** the state (prevents concurrent modifications), applies changes, then writes the updated state back remotely.
3. All teammates share the same state automatically.

### Common Remote Backends

| Backend | State Storage | Locking Mechanism |
|---|---|---|
| **AWS S3** | S3 bucket | DynamoDB table |
| **Terraform Cloud / HCP** | Terraform Cloud | Built-in |
| **Azure Blob Storage** | Azure Storage Account | Built-in lease |
| **Google Cloud Storage** | GCS bucket | Built-in |
| **HashiCorp Consul** | Consul KV | Built-in |

### Benefits

- **Centralized** — One source of truth for the whole team
- **Locking** — Prevents race conditions on concurrent `apply` runs
- **Encryption** — State encrypted at rest (S3 SSE, etc.)
- **Versioning** — S3 versioning lets you restore previous state
- **CI/CD friendly** — Pipelines authenticate to the backend without local state files

### Key Terraform Commands with Remote Backend

```bash
terraform init        # Downloads backend config and initializes remote state
terraform plan        # Reads remote state to compute diff
terraform apply       # Locks → applies → writes state remotely → unlocks
terraform state list  # Lists resources tracked in remote state
```

> **Note:** The backend block lives in your `.tf` files but credentials should come from environment variables or IAM roles — never hardcoded.