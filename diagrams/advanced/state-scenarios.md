```mermaid
flowchart TD
    %% Advanced Terraform State Scenarios
    
    subgraph StateMigration[State Migration Scenarios]
        SM1[State Migration from Local to Remote] --> SM2[Backup Local State]
        SM2 --> SM3[Configure Backend]
        SM3 --> SM4[Run terraform init -migrate-state]
        SM4 --> SM5[Verify State in Remote Backend]
        SM5 --> SM6[Remove Local State File]
        
        SM7[State Migration Between Backends] --> SM8[Configure New Backend]
        SM8 --> SM9[Run terraform init -migrate-state]
        SM9 --> SM10[Verify State in New Backend]
        SM10 --> SM11[Old Backend Can Be Deleted]
        
        SM12[State Pull/Push for Emergency Recovery] --> SM13[terraform state pull > backup.tfstate]
        SM13 --> SM14[Fix Issues in backup.tfstate]
        SM14 --> SM15[terraform state push backup.tfstate]
    end
    
    subgraph StateSharding[State Sharding Patterns]
        SS1[Monolithic State (Single Workspace)] --> SS2[All Resources in One State]
        SS2 --> SS3[Pros: Simple, Cons: Slow, Risky]
        
        SS4[Workspace per Environment] --> SS5[dev/stage/prod Workspaces]
        SS5 --> SS6[Pros: Isolation, Cons: Limited Sharing]
        
        SS7[Directory per Environment] --> SS8[Separate Config Directories]
        SS8 --> SS9[Pros: Full Isolation, Cons: Code Duplication]
        
        SS10[Resource Grouping by Lifecycle] --> SS11[Networking, Compute, Data States]
        SS11 --> SS12[Pros: Independent Updates, Cons: Complex Dependencies]
        
        SS13[Feature-based State] --> SS14[Auth State, API State, DB State]
        SS14 --> SS15[Pros: Team Ownership, Cons: Cross-feature Deps]
    end
    
    subgraph StateRecovery[State Recovery Procedures]
        SR1[State Corruption Detected] --> SR2[Identify Corruption Source]
        SR2 --> SR3[terraform validate -check-variables=false]
        SR3 --> SR4[Review State File JSON Structure]
        SR4 --> SR5[Identify Invalid Resource Entries]
        
        SR6[Recovery Option 1: State Rollback] --> SR7[Use Backend Versioning]
        SR7 --> SR8[Restore Previous State Version]
        SR8 --> SR9[Verify with terraform plan]
        
        SR10[Recovery Option 2: State Surgery] --> SR11[Extract Good Resources]
        SR11 --> SR12[Remove Corrupted Entries]
        SR12 --> SR13[Inject Correct Values from Cloud]
        SR13 --> SR14[Validate State Internally]
        
        SR15[Recovery Option 3: Disaster Recovery] --> SR16[Import Existing Infrastructure]
        SR16 --> SR17[terraform import for Key Resources]
        SR17 --> SR18[Gradually Bring Resources Under TF Control]
    end
    
    subgraph StateLocking[Advanced Locking Mechanisms]
        SL1[Standard Locking (Backend Provided)] --> SL2[DynamoDB, Consul, etc.]
        SL2 --> SL3[Automatic Lock Acquisition/Release]
        
        SL4[Custom Locking with External Systems] --> SL5[Use pre/post-conditions]
        SL5 --> SL6[Check External Lock Before Init]
        SL6 --> SL7[Release External Lock After Apply]
        
        SL8[Application-Level Locking] --> SL9[Mutex/Redis for Critical Sections]
        SL9 --> SL10[Protect Specific Resource Groups]
        SL10 --> SL11[Allow Parallel Work on Independent Sets]
        
        SL12[Lock Timeout and Deadlock Handling] --> SL13[Configurable Lock Timeouts]
        SL13 --> SL14[Automatic Lock Cleanup on Stale Processes]
        SL14 --> SL15[Deadlock Detection and Resolution]
    end
    
    subgraph StateEncryption[State Encryption Strategies]
        SE1[Encryption at Rest (Backend Provided)] --> SE2[S3 SSE-S3/SSE-KMS]
        SE2 --> SE3[Azure SSE, GCS CMEK]
        SE3 --> SE4[Managed by Storage Provider]
        
        SE5[Client-Side Encryption] --> SE6[Encrypt Before Sending to Backend]
        SE6 --> SE7[Requires Custom Backend or Plugins]
        SE7 --> SE8[Full Control Over Encryption Keys]
        
        SE9[Field-Level Encryption in State] --> SE10[Not Natively Supported]
        SE10 --> SE11[Use External Vault for Secrets]
        SE11 --> SE12[Reference Secrets in Config, Don't Store in State]
        
        SE13[Key Rotation Strategies] --> SE14[Backend-Managed Key Rotation]
        SE14 --> SE15[Periodic Key Rotation with Re-encryption]
        SE15 --> SE16[Maintain Access to Old Keys for Decryption]
    end
    
    %% Connections and styling
    classDef migration fill:#E3F2FD,stroke:#1565C0,stroke-width:2px;
    classDef sharding fill:#E8F5E8,stroke:#2E7D32,stroke-width:2px;
    classDef recovery fill:#FFF3E0,stroke:#EF6C00,stroke-width:2px;
    classDef locking fill:#F3E5F5,stroke:#6A1B9A,stroke-width:2px;
    classDef encryption fill:#FFEBEE,stroke:#C62828,stroke-width:2px;
    
    class SM1,SM2,SM3,SM4,SM5,SM6,SM7,SM8,SM9,SM10,SM11,SM12,SM13,SM14,SM15 migration;
    class SS1,SS2,SS3,SS4,SS5,SS6,SS7,SS8,SS9,SS10,SS11,SS12,SS13,SS14,SS15 sharding;
    class SR1,SR2,SR3,SR4,SR5,SR6,SR7,SR8,SR9,SR10,SR11,SR12,SR13,SR14,SR15,SR16,SR17,SR18 recovery;
    class SL1,SL2,SL3,SL4,SL5,SL6,SL7,SL8,SL9,SL10,SL11,SL12,SL13,SL14,SL15 locking;
    class SE1,SE2,SE3,SE4,SE5,SE6,SE7,SE8,SE9,SE10,SE11,SE12,SE13,SE14,SE15,SE16 encryption;
```