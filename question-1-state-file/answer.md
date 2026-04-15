# Q1: What is the Terraform State File Used For?

## Answer

The Terraform state file (`terraform.tfstate`) is a JSON file that acts as the **source of truth** mapping your configuration to real-world infrastructure.

It serves three core purposes:

1. **Resource Tracking** — Records every resource Terraform manages (IDs, attributes, metadata) so it knows what already exists in your cloud provider.

2. **Change Detection (Plan Diffing)** — During `terraform plan`, Terraform compares your `.tf` config against state to determine what needs to be created, updated, or destroyed — without querying the provider for every attribute.

3. **Dependency Mapping** — Stores the dependency graph of resources so they can be created/destroyed in the correct order.

## Example State Entry (simplified)

```json
{
  "resources": [
    {
      "type": "aws_instance",
      "name": "web",
      "instances": [
        {
          "attributes": {
            "id": "i-0abc123def456",
            "ami": "ami-0c55b159cbfafe1f0",
            "instance_type": "t2.micro"
          }
        }
      ]
    }
  ]
}
```

> **Key point:** Without state, Terraform would have no way to know which cloud resources it manages vs. resources created outside of Terraform.