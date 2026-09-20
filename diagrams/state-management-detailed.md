```mermaid
flowchart TD
    %% State Management Detailed Diagram
    
    subgraph LocalDevelopment[Local Development]
        LD1[Write Terraform Code] --> LD2[terraform init]
        LD2 --> LD3[terraform fmt]
        LD3 --> LD4[terraform validate]
        LD4 --> LD5[terraform plan]
        LD5 --> LD6[Review Plan]
        LD6 --> LD7[terraform apply]
        LD7 --> LD8[Infrastructure Created]
        LD8 --> LD9[terraform state]
    end
    
    subgraph RemoteState[Remote State Management]
        RS1[Configure Backend] --> RS2[S3 Bucket + DynamoDB Table]
        RS2 --> RS3[State Locking Mechanism]
        RS3 --> RS4[State Storage in S3]
        RS4 --> RS5[State Versioning]
        RS5 --> RS6[Collaborative Access]
    end
    
    subgraph StateOperations[State Operations]
        SO1[terraform state list] --> SO2[Show all resources]
        SO3[terraform state show] --> SO4[Show resource details]
        SO5[terraform state mv] --> SO6[Move resource state]
        SO7[terraform state rm] --> SO8[Remove resource from state]
        SO9[terraform state import] --> SO10[Import existing resource]
        SO11[terraform state replace-provider] --> SO12[Replace provider config]
    end
    
    subgraph DriftDetection[Drift Detection & Remediation]
        DD1[Manual Changes in Cloud] --> DD2[Resource Drift]
        DD2 --> DD3[terraform plan -detect-changes]
        DD3 --> DD4[Show Drift in Plan]
        DD4 --> DD5[Options:][DD5a[Update Code to Match], DD5b[Apply to Fix Drift]]
        DD5a --> LD1
        DD5b --> LD7
    end
    
    subgraph TeamWorkflow[Team Collaboration]
        TW1[Developer A] --> TW2[Feature Branch]
        TW3[Developer B] --> TW4[Feature Branch]
        TW2 --> TW5[Pull Request]
        TW4 --> TW5
        TW5 --> TW6[Automated terraform plan]
        TW6 --> TW7[Plan Review & Approval]
        TW7 --> TW8[terraform apply (manual/auto)]
        TW8 --> TW9[State Updated in S3]
        TW9 --> TW10[All Developers See Latest State]
    end
    
    %% Connections
    LD9 --> RS6
    RS6 --> TW10
    DD1 --> DD2
    style LocalDevelopment fill:#E3F2FD,stroke:#1565C0,stroke-width:2px
    style RemoteState fill:#E8F5E8,stroke:#2E7D32,stroke-width:2px
    style StateOperations fill:#FFF3E0,stroke:#EF6C00,stroke-width:2px
    style DriftDetection fill:#FFEBEE,stroke:#C62828,stroke-width:2px
    style TeamWorkflow fill:#F3E5F5,stroke:#6A1B9A,stroke-width:2px
```