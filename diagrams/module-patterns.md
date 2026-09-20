```mermaid
flowchart TD
    %% Module Composition Patterns
    
    subgraph RootModule[Root Module]
        RM1[main.tf] --> RM2[Call Child Modules]
        RM3[variables.tf] --> RM4[Define Inputs]
        RM5[outputs.tf] --> RM6[Define Outputs]
        RM7[versions.tf] --> RM8[Provider & TF Versions]
    end
    
    subgraph VPCModule[VPC Module]
        VM1[main.tf] --> VM2[Create VPC, Subnets, IGW, NAT]
        VM3[variables.tf] --> VM4[CIDR, AZs, Tags]
        VM5[outputs.tf] --> VM6[VPC ID, Subnet IDs, IGW ID]
    end
    
    subgraph EKSModule[EKS Module]
        EM1[main.tf] --> EM2[Create EKS Cluster, Node Groups]
        EM3[variables.tf] --> EM4[Version, Node Size, Desired Capacity]
        EM5[outputs.tf] --> EM6[Cluster Name, Endpoint, Security Group]
    end
    
    subgraph RDSModule[RDS Module]
        RDM1[main.tf] --> RDM2[Create DB Subnet Group, Security Group, RDS Instance]
        RDM3[variables.tf] --> RDM4[Engine, Instance Size, Storage]
        RDM5[outputs.tf] --> RDM6[Endpoint, Port, Security Group ID]
    end
    
    subgraph MonitoringModule[Monitoring Module]
        MM1[main.tf] --> MM2[Create CloudWatch Alarms, Log Groups, SNS Topics]
        MM3[variables.tf] --> MM4[Thresholds, Notification Emails]
        MM5[outputs.tf] --> MM6[Alarm ARNs, Log Group Names]
    end
    
    %% Composition Patterns
    %% Pattern 1: Layered Architecture
    LA1[Root Module] --> LA2[VPC Module]
    LA2 --> LA3[EKS Module]
    LA3 --> LA4[RDS Module]
    LA4 --> LA5[Monitoring Module]
    
    %% Pattern 2: Service Mesh Pattern
    SM1[Root Module] --> SM2[Service A Module]
    SM1 --> SM3[Service B Module]
    SM1 --> SM4[Service C Module]
    SM2 --> SM5[Shared Networking Module]
    SM3 --> SM5
    SM4 --> SM5
    
    %% Pattern 3: Environment Isolation
    EI1[Root Module - Dev] --> EI2[Shared Modules]
    EI3[Root Module - Staging] --> EI2
    EI4[Root Module - Prod] --> EI2
    
    %% Pattern 4: Multi-Region Deployment
    MR1[Root Module - Primary Region] --> MR2[Deploy Resources]
    MR3[Root Module - DR Region] --> MR4[Deploy Disaster Recovery Resources]
    MR2 --> MR5[Data Replication (via DS)]
    MR4 --> MR5
    
    classDef root fill:#1565C0,color:#ffffff;
    classDef service fill:#2E7D32,color:#ffffff;
    classDef shared fill:#EF6C00,color:#000000;
    classDef environment fill:#6A1B9A,color:#ffffff;
    
    class RM1,RM3,RM5,RM7 root;
    class VM1,VM3,VM5,EM1,EM3,EM5,RDM1,RDM3,RDM5,MM1,MM3,MM5 service;
    class SM5 shared;
    class EI1,EI3,EI4 environment;
```