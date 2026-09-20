```mermaid
flowchart TD
    %% CI/CD Pipeline for Terraform
    
    subgraph SourceControl[Source Control Management]
        SC1[Developer Commits Code] --> SC2[Create Feature Branch]
        SC2 --> SC3[Push to Remote Repository]
        SC3 --> SC4[Open Pull Request]
    end
    
    subgraph AutomatedChecks[Automated Pre-Merge Checks]
        AC1[PR Triggered] --> AC2[Run Terraform Fmt Check]
        AC2 --> AC3[Run Terraform Validate]
        AC3 --> AC4[Run TFSec/Checkov Security Scan]
        AC4 --> AC5[Run Terratest Unit Tests]
        AC5 --> AC6[Run Infracost Cost Estimation]
        AC6 --> AC7[Generate Plan Artifact]
        AC7 --> AC8[Post PR Comment with Results]
    end
    
    subgraph ManualReview[Manual Review Process]
        MR1[Developer Reviews AC Results] --> MR2[Address Feedback]
        MR2 --> MR3[Update Code if Needed]
        MR3 --> SC4[Back to PR]
        MR4[Approvers Review] --> MR5[Approve or Request Changes]
        MR5 -->|Approved| MR6[Merge to Main]
        MR5 -->|Changes Requested| MR2
    end
    
    subgraph PostMerge[Post-Merge Automation]
        PM1[Merge to Main] --> PM2[Trigger Pipeline on Main]
        PM2 --> PM3[Run terraform init]
        PM3 --> PM4[Run terraform validate]
        PM4 --> PM5[Run terraform plan -out=tfplan]
        PM5 --> PM6[Upload Plan Artifact]
        PM6 --> PM7[Send Notification for Approval]
    end
    
    subgraph ManualApproval[Manual Approval Gate]
        MA1[Review Plan Artifact] --> MA2[Approve or Reject]
        MA2 -->|Approve| MA3[Trigger Apply]
        MA2 -->|Reject| MA4[Notify Team]
        MA4 --> MA1[Loop Back for Review]
    end
    
    subgraph ApplyPhase[Apply Phase]
        MA3 --> AP1[Run terraform init]
        AP1 --> AP2[Run terraform apply tfplan]
        AP2 --> AP3[Apply Success/Failure]
        AP3 -->|Success| AP4[Deploy Success Notification]
        AP3 -->|Failure| AP5[Rollback Procedure]
        AP5 --> AP6[Notify On-Call Engineer]
    end
    
    subgraph PostDeploy[Post-Deployment]
        AP4 --> PD1[Run Infrastructure Tests]
        PD1 --> PD2[Run Smoke Tests]
        PD2 --> PD3[Run Security Validation]
        PD3 --> PD4[Update Documentation]
        PD4 --> PD5[Notify Stakeholders]
        PD5 --> PD6[Monitor for Drift]
    end
    
    subgraph DriftDetection[Drift Detection (Scheduled)]
        DD1[Scheduled Job (Daily/Hourly)] --> DD2[Run terraform plan]
        DD2 --> DD3[Check for Drift]
        DD3 -->|Drift Found| DD4[Create Drift Ticket]
        DD3 -->|No Drift| DD5[Log Success]
        DD4 --> DD6[Notify Team for Review]
        DD6 --> DD7[Decide: Update Code or Accept Drift]
    end
    
    classDef scm fill:#1565C0,color:#ffffff;
    classDef auto fill:#2E7D32,color:#ffffff;
    classDef manual fill:#EF6C00,color:#000000;
    classDef apply fill:#6A1B9A,color:#ffffff;
    classDef post fill:#C62828,color:#ffffff;
    
    class SC1,SC2,SC3,SC4 scm;
    class AC1,AC2,AC3,AC4,AC5,AC6,AC7,AC8 auto;
    class MR1,MR2,MR3,MR4,MR5,MR6 manual;
    class PM1,PM2,PM3,PM4,PM5,PM6,PM7 auto;
    class MA1,MA2,MA3,MA4 manual;
    class AP1,AP2,AP3,AP4,AP5,AP6 apply;
    class PD1,PD2,PD3,PD4,PD5,PD6 post;
    class DD1,DD2,DD3,DD4,DD5,DD6,DD7 auto;
```