# Remote State with S3

```mermaid
flowchart TB
  E1[Engineer / CI] --> TF[Terraform]
  E2[Engineer / CI] --> TF
  TF --> S3[(S3 State Object)]
  TF --> L[(S3 Lock File)]
  TF --> AWS[AWS APIs]
  S3 --> V[Bucket Versioning]
  S3 --> K[Encryption]
```

Current HashiCorp guidance documents S3 locking with `use_lockfile = true` and recommends bucket versioning for recovery. DynamoDB locking is documented as deprecated. citeturn726687search0
