# Terraform Basics Practice Exercises

## Exercise 1: Hello World Terraform

**Objective**: Create your first Terraform configuration

**Task**:
1. Create a directory called `hello-world`
2. Create a `main.tf` file that defines a local file resource
3. The file should contain "Hello, Terraform!" 
4. Apply the configuration
5. Verify the file was created correctly
6. Destroy the resource

**Solution**:
```hcl
# hello-world/main.tf
resource "local_file" "hello" {
  content  = "Hello, Terraform!"
  filename = "${path.module}/hello.txt"
}
```

**Commands**:
```bash
mkdir hello-world
cd hello-world
# Create main.tf with the content above
terraform init
terraform apply
# Verify hello.txt exists with correct content
cat hello.txt
terraform destroy
```

## Exercise 2: Variables and Outputs

**Objective**: Practice using variables and outputs

**Task**:
1. Create a configuration that defines:
   - A variable for instance type (default: "t2.micro")
   - A variable for AMI ID (no default)
   - An output for the instance ID
2. Create an AWS instance resource using these variables
3. Create a terraform.tfvars file to set the AMI ID
4. Apply and verify outputs

**Solution**:
```hcl
# variables.tf
variable "instance_type" {
  description = "EC2 instance type"
  type        = string
  default     = "t2.micro"
}

variable "ami_id" {
  description = "AMI ID for the instance"
  type        = string
}

# outputs.tf
output "instance_id" {
  description = "ID of the created instance"
  value       = aws_instance.example.id
}

# main.tf
provider "aws" {
  region = "us-west-2"
}

resource "aws_instance" "example" {
  ami           = var.ami_id
  instance_type = var.instance_type

  tags = {
    Name = "example-instance"
  }
}
```

```hcl
# terraform.tfvars
ami_id = "ami-0abcdef1234567890"  # Replace with valid AMI for your region
```

## Exercise 3: State Management

**Objective**: Practice state inspection and manipulation

**Task**:
1. Create an AWS S3 bucket
2. Apply the configuration
3. Use state commands to:
   - List all resources
   - Show the bucket details
   - Move the bucket to a different address
   - Import an existing bucket (if you have one)
4. Destroy the resource

**Solution**:
```hcl
# main.tf
provider "aws" {
  region = "us-east-1"
}

resource "aws_s3_bucket" "example" {
  bucket = "my-unique-bucket-name-${random_id.suffix.hex}"
  acl    = "private"

  tags = {
    Environment = "practice"
  }
}

resource "random_id" "suffix" {
  byte_length = 4
}
```

**State Commands**:
```bash
terraform init
terraform apply
terraform state list
terraform state show aws_s3_bucket.example
terraform state mv aws_s3_bucket.example aws_s3_bucket.moved
# To import (replace with actual bucket name):
# terraform aws_s3_bucket.imported my-existing-bucket-name
terraform destroy
```

## Exercise 4: Dependencies and Meta-arguments

**Objective**: Practice using depends_on and for_each

**Task**:
1. Create 3 security groups with specific rules
2. Create 2 EC2 instances
3. Associate each instance with a different security group
4. Use for_each to create the security groups
5. Use depends_on to ensure security groups are created before instances
6. Output the instance IDs and their associated security group IDs

**Solution**:
```hcl
# variables.tf
variable "instance_count" {
  description = "Number of instances to create"
  type        = number
  default     = 2
}

# main.tf
provider "aws" {
  region = "us-west-2"
}

# Create security groups using for_each
resource "aws_security_group" "web" {
  for_each = toset(["allow-http", "allow-https", "allow-ssh"])

  name        = "sg-${each.key}"
  description = "Security group for ${each.key}"

  ingress {
    from_port   = lookup(map("allow-http", 80, "allow-https", 443, "allow-ssh", 22), each.key, 0)
    to_port     = lookup(map("allow-http", 80, "allow-https", 443, "allow-ssh", 22), each.key, 0)
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "sg-${each.key}"
  }
}

# Create instances
resource "aws_instance" "web" {
  count          = var.instance_count
  ami           = "ami-0abcdef1234567890"  # Replace with valid AMI
  instance_type = "t2.micro"

  # Associate with security groups - first instance gets http sg, second gets https sg
  vpc_security_group_ids = [element(values(aws_security_group.web)[*].id, count.index)]

  # Ensure security groups are created first
  depends_on = [aws_security_group.web]

  tags = {
    Name = "web-server-${count.index}"
  }
}

# outputs.tf
output "instance_ids" {
  description = "IDs of the web servers"
  value       = aws_instance.web[*].id
}

output "security_group_ids" {
  description = "IDs of security groups"
  value       = [for sg in aws_security_group.web : sg.id]
}
```

## Exercise 5: Data Sources

**Objective**: Practice using data sources

**Task**:
1. Use a data source to get the latest Amazon Linux 2 AMI
2. Use a data source to get available AZs in the current region
3. Create an EC2 instance in the first available AZ
4. Output the AMI ID used and the AZ where the instance was placed

**Solution**:
```hcl
# main.tf
provider "aws" {
  region = "us-west-2"
}

# Get latest Amazon Linux 2 AMI
data "aws_ami" "amazon_linux" {
  most_recent = true
  owners      = ["amazon"]

  filter {
    name   = "name"
    values = ["amzn2-ami-hvm-*-x86_64-gp2"]
  }
}

# Get available AZs
data "aws_availability_zones" "available" {
  state = "available"
}

# Create instance
resource "aws_instance" "example" {
  ami           = data.aws_ami.amazon_linux.id
  instance_type = "t2.micro"
  availability_zone = data.aws_availability_zones.available.names[0]

  tags = {
    Name = "data-source-example"
  }
}

# outputs.tf
output "ami_used" {
  description = "AMI ID used for the instance"
  value       = data.aws_ami.amazon_linux.id
}

output "availability_zone" {
  description = "AZ where instance was placed"
  value       = data.aws_availability_zones.available.names[0]
}
```

## Exercise 6: Remote State Configuration

**Objective**: Practice configuring remote state

**Task**:
1. Configure an S3 backend for state storage
2. Create a DynamoDB table for state locking
3. Initialize Terraform with the backend
4. Create a simple resource (S3 bucket)
5. Verify state is stored remotely
6. Practice state locking by simulating concurrent operations

**Note**: For this exercise, you'll need AWS credentials configured.

**Solution**:
```hcl
# terraform.tf (backend configuration)
terraform {
  backend "s3" {
    bucket         = "my-terraform-state-bucket-unique"
    key            = "prod/environment/terraform.tfstate"
    region         = "us-east-1"
    encrypt        = true
    dynamodb_table = "terraform-locks"
  }
}

# main.tf
provider "aws" {
  region = "us-east-1"
}

resource "aws_s3_bucket" "state_bucket" {
  bucket = "my-terraform-state-bucket-unique"
  acl    = "private"

  versioning {
    enabled = true
  }

  server_side_encryption_configuration {
    rule {
      apply_server_side_encryption_by_default {
        sse_algorithm = "AES256"
      }
    }
  }

  tags = {
    Environment = "practice"
    ManagedBy   = "Terraform"
  }
}
```

**Setup Instructions**:
```bash
# 1. Create S3 bucket for state (if not already created)
aws s3api create-bucket --bucket my-terraform-state-bucket-unique --region us-east-1
aws s3api put-bucket-versioning --bucket my-terraform-state-bucket-unique --versioning-configuration Status=Enabled

# 2. Create DynamoDB table for locking
aws dynamodb create-table \
    --table-name terraform-locks \
    --attribute-definitions AttributeName=LockID,AttributeType=S \
    --key-schema AttributeName=LockID,KeyType=HASH \
    --billing-mode PAY_PER_REQUEST

# 3. Initialize Terraform
terraform init

# 4. Apply configuration
terraform apply

# 5. Verify remote state
# Check that terraform.tfstate file is NOT in your local directory
# State should be in S3 bucket

# 6. Test locking (advanced):
# In one terminal: terraform apply (don't confirm yet)
# In another terminal: try to run terraform plan - should fail with lock error
```

## Exercise 7: Module Usage

**Objective**: Practice using Terraform modules from the Registry

**Task**:
1. Use the AWS VPC module from the Terraform Registry
2. Create a VPC with public and private subnets
3. Create an EC2 instance in the private subnet
4. Create a bastion host in the public subnet for access
5. Output the VPC ID, instance IDs, and bastion public IP

**Solution**:
```hcl
# main.tf
terraform {
  required_version = ">= 1.0.0"
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 4.0"
    }
  }
}

provider "aws" {
  region = "us-west-2"
}

# Use VPC module from Terraform Registry
module "vpc" {
  source  = "terraform-aws-modules/vpc/aws"
  version = "3.14.0"

  name = "practice-vpc"
  cidr = "10.0.0.0/16"

  azs             = ["us-west-2a", "us-west-2b"]
  private_subnets = ["10.0.1.0/24", "10.0.2.0/24"]
  public_subnets  = ["10.0.101.0/24", "10.0.110.0/24"]

  enable_nat_gateway   = true
  enable_vpn_gateway   = false

  tags = {
    Environment = "practice"
  }
}

# Bastion host in public subnet
resource "aws_instance" "bastion" {
  ami           = "ami-0abcdef1234567890"  # Replace with valid AMI
  instance_type = "t2.micro"
  subnet_id     = element(module.vpc.public_subnets, 0)

  vpc_security_group_ids = [aws_security_group.bastion.id]

  associate_public_ip_address = true

  tags = {
    Name = "bastion-host"
  }
}

# Security group for bastion (SSH only)
resource "aws_security_group" "bastion" {
  name        = "bastion-sg"
  description = "Allow SSH inbound"
  vpc_id      = module.vpc.vpc_id

  ingress {
    description = "SSH"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]  # In production, restrict to your IP
  }

  egress {
    description = "All outbound"
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

# Private EC2 instance
resource "aws_instance" "private_app" {
  ami           = "ami-0abcdef1234567890"  # Replace with valid AMI
  instance_type = "t2.micro"
  subnet_id     = element(module.vpc.private_subnets, 0)

  vpc_security_group_ids = [aws_security_group.private_app.id]

  tags = {
    Name = "private-app"
  }
}

# Security group for private app (allow from bastion only)
resource "aws_security_group" "private_app" {
  name        = "private-app-sg"
  description = "Allow SSH from bastion only"
  vpc_id      = module.vpc.vpc_id

  ingress {
    description = "SSH from bastion"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    security_groups = [aws_security_group.bastion.id]
  }

  egress {
    description = "All outbound"
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

# outputs.tf
output "vpc_id" {
  description = "ID of the VPC"
  value       = module.vpc.vpc_id
}

output "instance_ids" {
  description = "IDs of EC2 instances"
  value = {
    bastion   = aws_instance.bastion.id
    private   = aws_instance.private_app.id
  }
}

output "bastion_public_ip" {
  description = "Public IP of bastion host"
  value       = aws_instance.bastion.public_ip
}
```

## Exercise 8: Workspaces Practice

**Objective**: Practice using Terraform workspaces

**Task**:
1. Create a simple web server configuration
2. Create workspaces for dev, staging, and prod
3. Use different instance types for each environment (t2.micro for dev, t2.small for staging, t2.medium for prod)
4. Use workspace-specific variables
5. Apply to each workspace and verify isolation

**Solution**:
```hcl
# main.tf
provider "aws" {
  region = "us-west-2"
}

# Get current workspace
data "terraform_remote_state" "workspace" {
  backend = "local"
}

variable "instance_types" {
  description = "Map of workspace to instance type"
  type        = map(string)
  default = {
    dev     = "t2.micro"
    staging = "t2.small"
    prod    = "t2.medium"
  }
}

resource "aws_instance" "web" {
  ami           = "ami-0abcdef1234567890"  # Replace with valid AMI
  instance_type = lookup(var.instance_types, terraform.workspace, "t2.micro")

  tags = {
    Name        = "web-server-${terraform.workspace}"
    Environment = terraform.workspace
  }
}

# outputs.tf
output "instance_id" {
  description = "ID of the web server"
  value       = aws_instance.web.id
}

output "instance_type" {
  description = "Instance type used"
  value       = aws_instance.web.instance_type
}

output "workspace" {
  description = "Current Terraform workspace"
  value       = terraform.workspace
}
```

**Commands**:
```bash
terraform init
terraform workspace new dev
terraform workspace select dev
terraform apply -var-file=dev.tfvars

terraform workspace new staging
terraform workspace select staging
terraform apply -var-file=staging.tfvars

terraform workspace new prod
terraform workspace select prod
terraform apply -var-file=prod.tfvars

# Verify isolation
terraform workspace select dev
terraform state list
# Should only see dev resources

terraform workspace select staging
terraform state list
# Should only see staging resources
```

## Exercise 9: Provisioners Practice

**Objective**: Practice using provisioners (use with caution!)

**Task**:
1. Create an EC2 instance
2. Use a local-exec provisioner to create a local file after instance creation
3. Use a remote-exec provisioner to run a command on the instance via SSH
4. Use a file provisioner to copy a file to the instance
5. Output the instance's public DNS

**Important**: Provisioners should be used sparingly as they can cause issues with state management.

**Solution**:
```hcl
# main.tf
provider "aws" {
  region = "us-west-2"
}

resource "aws_key_pair" "generated" {
  key_name   = "terraform-practice"
  public_key = file("~/.ssh/id_rsa.pub")  # Assumes you have an SSH key pair
}

resource "aws_instance" "web" {
  ami           = "ami-0abcdef1234567890"  # Replace with valid AMI
  instance_type = "t2.micro"
  key_name      = aws_key_pair.generated.key_name

  vpc_security_group_ids = [aws_security_group.ssh.id]

  # File provisioner - copy local file to instance
  provisioner "file" {
    source      = "index.html"
    destination = "/var/www/html/index.html"

    connection {
      type        = "ssh"
      user        = "ec2-user"
      private_key = file("~/.ssh/id_rsa")
      host        = self.public_ip
    }
  }

  # Remote-exec provisioner - run commands on instance
  provisioner "remote-exec" {
    inline = [
      "sudo yum install -y httpd",
      "sudo systemctl start httpd",
      "sudo systemctl enable httpd",
      "echo '<h1>Deployed via Terraform</h1>' > /var/www/html/index.html"
    ]

    connection {
      type        = "ssh"
      user        = "ec2-user"
      private_key = file("~/.ssh/id_rsa")
      host        = self.public_ip
    }
  }

  # Local-exec provisioner - run command on machine running Terraform
  provisioner "local-exec" {
    command = "echo \"Instance ${self.id} created at $(timestamp)\" >> instance_creation.log"
  }

  tags = {
    Name = "web-server-with-provisioners"
  }
}

# Security group for SSH and HTTP
resource "aws_security_group" "ssh" {
  name        = "ssh-access"
  description = "Allow SSH and HTTP inbound"

  ingress {
    description = "SSH"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]  # Restrict in production!
  }

  ingress {
    description = "HTTP"
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]  # Restrict in production!
  }

  egress {
    description = "All outbound"
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

# outputs.tf
output "public_dns" {
  description = "Public DNS of the instance"
  value       = aws_instance.web.public_dns
}

output "public_ip" {
  description = "Public IP of the instance"
  value       = aws_instance.web.public_ip
}
```

**Note**: Create a simple `index.html` file in the same directory for the file provisioner to copy.

## Exercise 10: Lifecycle Rules

**Objective**: Practice using lifecycle rules

**Task**:
1. Create an AWS S3 bucket
2. Add a lifecycle rule to prevent accidental destruction
3. Try to destroy the bucket (should fail)
4. Remove the prevent_destroy rule and try again (should succeed)
5. Practice create_before_destroy with a resource that requires it

**Solution**:
```hcl
# main.tf
provider "aws" {
  region = "us-east-1"
}

resource "aws_s3_bucket" "important_data" {
  bucket = "important-data-${random_id.suffix.hex}"
  acl    = "private"

  # Lifecycle rule to prevent destruction
  lifecycle {
    prevent_destroy = true
  }

  tags = {
    Environment = "practice"
    DataType    = "important"
  }
}

resource "random_id" "suffix" {
  byte_length = 4
}

# Example of create_before_destroy (for resources that can't be updated in place)
# Uncomment to test:
"""
resource "aws_db_instance" "example" {
  identifier         = "terraform-practice-db"
  allocated_storage  = 20
  engine             = "mysql"
  engine_version     = "5.7"
  instance_class     = "db.t2.micro"
  name               = "practicedb"
  username           = "dbuser"
  password           = "dbpassword123"
  skip_final_snapshot = true

  lifecycle {
    create_before_destroy = true
  }

  tags = {
    Environment = "practice"
  }
}
"""
```

**Testing prevent_destroy**:
```bash
terraform init
terraform apply
# Try to destroy - should fail due to prevent_destroy
terraform destroy
# You'll see an error about prevent_destroy

# To allow destruction, remove the lifecycle block or set prevent_destroy = false
# Then terraform destroy will work
```

---

*Each exercise includes both the task description and a sample solution. Try to complete the exercises on your own before looking at the solutions!*