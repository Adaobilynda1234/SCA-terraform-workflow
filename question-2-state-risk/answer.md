# Q2: Why is Storing State Locally Risky in a Team Environment?

## Answer

Storing `terraform.tfstate` locally (the default) introduces several serious risks when multiple engineers work on the same infrastructure:

### 1. No Shared Access
State lives only on your machine. Teammates running `terraform plan` or `terraform apply` won't see your latest state — leading to **conflicting or duplicate resource creation**.

### 2. No State Locking
Two engineers can run `terraform apply` simultaneously. Without locking, both processes can **corrupt the state file** by writing conflicting changes at the same time.

### 3. Accidental Deletion / Data Loss
If a developer deletes their local workspace or reformats their machine, the state file is **gone permanently** — Terraform loses track of all managed infrastructure.

### 4. State Contains Secrets
State files often contain **plaintext sensitive values** (passwords, private keys, connection strings). Storing locally means it may end up accidentally committed to git.

### 5. No Audit Trail
Local state provides no versioning or history — you can't roll back to a previous state after a bad apply.

---

## Summary Table

| Risk | Local State | Remote Backend |
|---|---|---|
| Shared access | ❌ One person only | ✅ Team-wide |
| State locking | ❌ No locking | ✅ DynamoDB / native lock |
| Durability | ❌ Machine-dependent | ✅ S3 / GCS versioned |
| Secret exposure | ❌ Plain file on disk | ✅ Encrypted at rest |
| History/rollback | ❌ None | ✅ Versioned |