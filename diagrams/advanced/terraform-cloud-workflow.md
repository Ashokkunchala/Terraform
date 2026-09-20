```mermaid
flowchart TD
    %% Terraform Cloud/Enterprise Workflow Diagram
    
    subgraph DeveloperWorkflow[Developer Workflow]
        DW1[Write Terraform Code] --> DW2[Create Feature Branch]
        DW2 --> DW3[Push to VCS (GitHub/GitLab/Bitbucket)]
        DW3 --> DW4[Open Pull/Merge Request]
        DW4 --> DW5[Automatic Terraform Cloud Run Triggered]
        DW5 --> DW6[View Plan in TFC UI]
        DW6 --> DW7[Request/Approve Run]
        DW7 --> DW8[Terraform Apply Executed]
        DW8 --> DW9[Apply Completed Successfully]
        DW9 --> DW10[Merge to Main Branch]
        DW10 --> DW11[Update Main Branch Infrastructure]
    end
    
    subgraph TFCAutomation[TFC Automation & Governance]
        TA1[TFC Webhook Receives VCS Event] --> TA2[TFC Creates New Run]
        TA2 --> TA3[Run terraform init]
        TA3 --> TA4[Run terraform validate]
        TA4 --> TA5[Run terraform plan]
        TA5 --> TA6[Upload Plan Artifact]
        TA6 --> TA7[Run Policy Checks (Sentinel)]
        TA7 -->|Policy Pass| TA8[Run Available for Apply]
        TA7 -->|Policy Fail| TA9[Run Errored - Notify Team]
        TA8 --> TA10[Manual/Auto Apply Approval]
        TA10 --> TA11[Run terraform apply]
        TA11 --> TA12[Upload State & Artifacts]
        TA12 --> TA13[Run Completed - Notify Stakeholders]
    end
    
    subgraph SentinelPolicies[Sentinel Policy Governance]
        SP1[Sentinel Policy Set] --> SP2[Cost Estimation Policy]
        SP2 --> SP3{Check Estimated Cost}
        SP3 -->|Under Threshold| SP4[Allow]
        SP3 -->|Over Threshold| SP5[Deny & Notify]
        
        SP1 --> SP6[Security Policy]
        SP6 --> SP7{Check for Public S3 Buckets}
        SP7 -->|Found Public| SP8[Deny & Notify]
        SP7 -->|No Public| SP9[Allow]
        
        SP1 --> SP10[Compliance Policy]
        SP10 --> SP11{Check Required Tags}
        SP11 -->|Missing Tags| SP12[Deny & Notify]
        SP11 -->|Has Tags| SP13[Allow]
    end
    
    subgraph PrivateModuleRegistry[Private Module Registry]
        PMR1[Publish Module to PMR] --> PMR2[Module Versioned]
        PMR2 --> PMR3[Available for Consumption]
        PMR3 --> PMR4[Teams Reference Module]
        PMR4 --> PMR5[Automatic Updates via Version Constraints]
    end
    
    subgraph AuditLogging[Audit Logging & Notification]
        AL1[All TFC Actions] --> AL2[Write to Audit Log]
        AL2 --> AL3[Stream to SIEM/Splunk]
        AL3 --> AL4[Generate Compliance Reports]
        AL1 --> AL5[Send Notifications]
        AL5 --> AL6[Email/Slack/MS Teams]
        AL5 --> AL7[Trigger Webhooks]
    end
    
    %% Connections
    DW5 --> TA1
    TA13 --> DW9
    TA12 --> PMR2
    SP7 --> TA8
    SP9 --> TA8
    SP13 --> TA8
    
    classDef developer fill:#E3F2FD,stroke:#1565C0,stroke-width:2px;
    classDef tfc fill:#E8F5E8,stroke:#2E7D32,stroke-width:2px;
    classDef policy fill:#FFF3E0,stroke:#EF6C00,stroke-width:2px;
    classDef registry fill:#F3E5F5,stroke:#6A1B9A,stroke-width:2px;
    classDef audit fill:#FFEBEE,stroke:#C62828,stroke-width:2px;
    
    class DW1,DW2,DW3,DW4,DW5,DW6,DW7,DW8,DW9,DW10,DW11 developer;
    class TA1,TA2,TA3,TA4,TA5,TA6,TA7,TA8,TA9,TA10,TA11,TA12,TA13 tfc;
    class SP1,SP2,SP3,SP4,SP5,SP6,SP7,SP8,SP9,SP10,SP11,SP12,SP13 policy;
    class PMR1,PMR2,PMR3,PMR4,PMR5 registry;
    class AL1,AL2,AL3,AL4,AL5,AL6,AL7 audit;
```