# Terraform Modules: Deep Dive

## 📋 Table of Contents
1. [What are Terraform Modules?](#what-are-terraform-modules)
2. [Module Structure](#module-structure)
3. [Module Sources](#module-sources)
4. [Input and Output Variables](#input-and-output-variables)
5. [Module Composition Patterns](#module-composition-patterns)
6. [Versioning and Releases](#versioning-and-releases)
7. [Testing Modules](#testing-modules)
8. [Best Practices](#best-practices)
9. [Hands-on Exercises](#hands-on-exercises)

## What are Terraform Modules?

Terraform modules are self-contained packages of Terraform configurations that are managed as a group. They enable reusable, consistent infrastructure deployment across projects and teams.

### Why Use Modules?
- **Reusability**: Write once, use everywhere
- **Consistency**: Standardize infrastructure patterns
- **Encapsulation**: Hide complexity behind simple interfaces
- **Collaboration**: Share standardized components across teams
- **Maintainability**: Update in one place, propagate everywhere

## Module Structure

A well-structured Terraform module follows this convention:

```
my-module/
├── main.tf           # Primary resources
├── variables.tf      # Input variables
├── outputs.tf        # Output values
├── versions.tf       # Provider & Terraform versions
├── providers.tf      # Provider configurations (optional)
├── README.md         # Module documentation
├── examples/         # Usage examples
│   ├── simple/
│   │   ├── main.tf
│   │   ├── variables.tf
│   │   └── outputs.tf
│   └── advanced/
│       ├── main.tf
│       ├── variables.tf
│       └── outputs.tf
└── tests/            # Automated tests (if using Terratest)
    └── test_example.go
```

### Essential Files Explained:

**main.tf**: Contains the core resources that make up the module
```hcl
resource "aws_vpc" "this" {
  cidr_block           = var.vpc_cidr
  enable_dns_hostnames = true
  tags                 = var.tags
}
```

**variables.tf**: Defines inputs that users can customize
```hcl
variable "vpc_cidr" {
  description = "CIDR block for the VPC"
  type        = string
  default     = "10.0.0.0/16"
}

variable "tags" {
  description = "Tags to apply to all resources"
  type        = map(string)
  default     = {}
}
```

**outputs.tf**: Defines values that users can reference
```hcl
output "vpc_id" {
  description = "The ID of the VPC"
  value       = aws_vpc.this.id
}

output "vpc_cidr_block" {
  description = "The CIDR block of the VPC"
  value       = aws_vpc.this.cidr_block
}
```

**versions.tf**: constrains provider and Terraform versions
```hcl
terraform {
  required_version = ">= 1.0.0"
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 4.0"
    }
  }
}
```

## Module Sources

Modules can be sourced from various locations:

### 1. Local Path
```hcl
module "vpc" {
  source = "./modules/vpc"
}
```

### 2. Registry (Public or Private)
```hcl
module "vpc" {
  source  = "terraform-aws-modules/vpc/aws"
  version = "3.14.0"
}
```

### 3. Git Repository
```hcl
module "vpc" {
  source  = "git::https://github.com/terraform-aws-modules/terraform-aws-vpc.git"
  ref     = "v3.14.0"
}
```

### 4. Mercurial Repository
```hcl
module "vpc" {
  source  = "hg::https://example.com/hg/vpc"
  ref     = "v3.14.0"
}
```

### 5. HTTP URL
```hcl
module "vpc" {
  source = "https://example.com/vpc-module.tar.gz"
}
```

### 6. S3 Bucket
```hcl
module "vpc" {
  source = "s3::https://s3.amazonaws.com/my-bucket/vpc-module.zip"
}
```

## Input and Output Variables

### Input Variables
Allow customization of module behavior:

```hcl
variable "instance_type" {
  description = "EC2 instance type"
  type        = string
  default     = "t2.micro"
}

variable "enable_monitoring" {
  description = "Enable detailed monitoring"
  type        = bool
  default     = false
}

variable "subnet_ids" {
  description = "List of subnet IDs for deployment"
  type        = list(string)
}
```

#### Variable Validation (Terraform 0.13+)
```hcl
variable "instance_type" {
  description = "EC2 instance type"
  type        = string
  
  validation {
    condition     = contains(["t2.micro", "t3.micro", "t3.small"], var.instance_type)
    error_message = "Invalid instance type. Must be t2.micro, t3.micro, or t3.small."
  }
}
```

### Output Values
Export useful information from the module:

```hcl
output "instance_id" {
  description = "ID of the EC2 instance"
  value       = aws_instance.web.id
  sensitive   = false
}

output "private_key" {
  description = "SSH private key for instance access"
  value       = tls_private_key.example.private_key_pem
  sensitive   = true  # Marks output as sensitive
}

output "tags_all" {
  description = "All tags applied to resources"
  value       = merge(var.base_tags, var.additional_tags)
}
```

## Module Composition Patterns

### 1. Simple Encapsulation
Single responsibility module that does one thing well.

```
modules/
└── mysql/
    ├── main.tf
    ├── variables.tf
    └── outputs.tf
```

Usage:
```hcl
module "mysql" {
  source  = "./modules/mysql"
  version = "1.0.0"
  
  instance_class = "db.t3.medium"
  allocated_storage = 20
}
```

### 2. Layered Architecture
Building blocks stacked to create complex systems.

```
modules/
├── networking/
│   ├── main.tf
│   └── outputs.tf  # Exports VPC, subnets, etc.
├── compute/
│   ├── main.tf
│   └── outputs.tf  # Needs networking outputs as input
└── database/
    ├── main.tf
    └── outputs.tf  # Needs networking outputs as input
```

Usage:
```hcl
module "networking" {
  source = "./modules/networking"
}

module "compute" {
  source = "./modules/compute"
  
  vpc_id                 = module.networking.vpc_id
  private_subnet_ids     = module.networking.private_subnets
}

module "database" {
  source = "./modules/database"
  
  vpc_id              = module.networking.vpc_id
  private_subnet_ids  = module.networking.private_subnets
}
```

### 3. Service Mesh Pattern
Multiple services sharing common networking.

```
modules/
├── networking/
│   └── outputs.tf  # Shared networking
├── service-a/
│   └── main.tf     # Uses networking outputs
├── service-b/
│   └── main.tf     # Uses networking outputs
└── service-c/
    └── main.tf     # Uses networking outputs
```

### 4. Environment Isolation
Same modules, different configurations per environment.

```
environments/
├── dev/
│   ├── main.tf
│   └── terraform.tfvars
├── staging/
│   ├── main.tf
│   └── terraform.tfvars
└── prod/
    ├── main.tf
    └── terraform.tfvars
modules/
    ├── networking/
    ├── compute/
    └── database/
```

Each environment's main.tf:
```hcl
module "networking" {
  source = "../../modules/networking"
  # ... environment-specific vars
}

module "compute" {
  source = "../../modules/compute"
  # ... environment-specific vars
}
```

### 5. Multi-Region Deployment
Deploy same infrastructure to multiple regions.

```
modules/
└── web-app/
    ├── main.tf
    └── outputs.tf
```

Usage:
```hcl
provider "aws" {
  alias  = "us_east"
  region = "us-east-1"
}

provider "aws" {
  alias  = "eu_west"
  region = "eu-west-1"
}

module "web_app_us_east" {
  source  = "./modules/web-app"
  providers = {
    aws = aws.us_east
  }
}

module "web_app_eu_west" {
  source  = "./modules/web-app"
  providers = {
    aws = aws.eu_west
  }
}
```

## Versioning and Releases

### Semantic Versioning
Use `MAJOR.MINOR.PATCH` format:
- **MAJOR**: Incompatible API changes
- **MINOR**: Backward-compatible functionality
- **PATCH**: Backward-compatible bug fixes

### Version Constraints in consuming configurations:
```hcl
module "vpc" {
  source  = "terraform-aws-modules/vpc/aws"
  version = "3.14.0"           # Exact version
  # version = "~> 3.0"         # Any 3.x version (recommended)
  # version = ">= 3.0.0"       # 3.0.0 or newer
  # version = "> 3.0.0 < 4.0"  # Between 3.0.0 and 4.0 (exclusive)
}
```

### Publishing Modules
1. **Public Registry**: Publish to registry.terraform.io
2. **Private Registry**: Use Terraform Cloud/Enterprise or self-hosted
3. **Git Tags**: Tag releases in Git repository
4. **Object Storage**: Versioned archives in S3/GCS/etc.

### Release Process:
1. Update version in `versions.tf` or create Git tag
2. Write comprehensive release notes
3. Update examples to match new version
4. Run tests against new version
5. Publish to registry or push Git tag

## Testing Modules

### Unit Testing with Terratest
```go
func TestVPCModule(t *testing.T) {
	t.Parallel()

	// Generate unique ID to prevent naming conflicts
	uniqueID := rand.UniqueId()
	
	// Define expected values
	expectedCIDR := "10.0.0.0/16"
	expectedTags := map[string]string{
		"Environment": "test",
		"Team":        "infrastructure",
	}

	// Define module options
	opts := &terragrunt.Options{
		TerraformDir: "../",
		Vars: map[string]interface{}{
			"vpc_cidr": expectedCIDR,
			"tags":     expectedTags,
		},
	}

	// Deploy the module
	terraform.InitAndApply(t, opts)

	// Validate outputs
	actualCIDR := terraform.Output(t, opts, "vpc_cidr_block")
	if actualCIDR != expectedCIDR {
		t.Fatalf("Expected VPC CIDR %s, got %s", expectedCIDR, actualCIDR)
	}

	// Validate tags
	actualTags := terraform.OutputMap(t, opts, "tags")
	if !reflect.DeepEqual(actualTags, expectedTags) {
		t.Fatalf("Expected tags %v, got %v", expectedTags, actualTags)
	}

	// Clean up
	defer terraform.Destroy(t, opts)
}
```

### Static Analysis
- **TFLint**: Terraform linter for catching errors and enforcing best practices
- **Checkov/TFSec**: Static security analysis for infrastructure as code
- **Terraform Validate**: Built-in validation for configuration syntax

### Integration Testing
- Deploy to real cloud provider (preferably dev/test account)
- Verify resources are created correctly
- Test failure scenarios
- Clean up after tests

## Best Practices

### 1. Follow the Standard Module Structure
- Maintain consistency across all modules
- Make it easy for others to understand and use your modules

### 2. Keep Modules Focused
- Single responsibility principle: each module should do one thing well
- If a module becomes too complex, consider splitting it

### 3. Document Thoroughly
- Comprehensive README with usage examples
- Clear variable descriptions with examples
- Document any special requirements or limitations

### 4. Use Versioning Religious
- Always pin modules to specific versions in consuming configurations
- Use `~>` operator for safe updates (e.g., `"~> 3.0"`)
- Never use latest version (`==`) in production

### 5. Validate Inputs
- Use validation blocks to catch configuration errors early
- Provide meaningful error messages

### 6. Mark Sensitive Outputs
- Set `sensitive = true` for outputs containing secrets
- Prevents accidental exposure in logs and CLI output

### 7. Provide Examples
- Include at least one working example in `examples/` directory
- Show common usage patterns
- Keep examples up-to-date with module changes

### 8. Test Everything
- Write automated tests for all public interfaces
- Test both positive and negative cases
- Test with different input combinations

### 9. Handle Providers Properly
- Declare required providers in `versions.tf`
- Allow provider aliasing for multi-provider scenarios
- Document which providers are required

### 10. Plan for Evolution
- Design modules to be extensible
- Consider future needs when defining inputs/outputs
- Use sensible defaults that work for most cases

## Hands-on Exercises

### Exercise 1: Creating a Reusable VPC Module
**Objective**: Build a production-ready VPC module

**Steps**:
1. Create module directory structure
2. Define variables for CIDR, AZs, tags, etc.
3. Create VPC, Internet Gateway, NAT Gateways, Subnets
4. Define outputs for VPC ID, subnet IDs, etc.
5. Add validation for CIDR blocks
6. Create example usage
7. Write Terratest tests

**Module Structure**:
```
modules/
└── vpc/
    ├── main.tf
    ├── variables.tf
    ├── outputs.tf
    ├── versions.tf
    ├── README.md
    └── examples/
        └── simple/
            ├── main.tf
            ├── variables.tf
            └── outputs.tf
```

### Exercise 2: Module Composition
**Objective**: Build a layered web application module

**Steps**:
1. Create networking module (VPC, subnets)
2. Create security module (security groups)
3. Create compute module (EC2/ASG, ALB)
4. Create database module (RDS)
5. Create root module that composes them together
6. Ensure proper dependency management

**Composition**:
```
modules/
├── networking/
├── security/
├── compute/
├── database/
└── web-app/    # Root module that calls the above
```

### Exercise 3: Versioning and Releases
**Objective**: Practice module versioning and release process

**Steps**:
1. Create a simple module (e.g., S3 bucket)
2. Release version 1.0.0
3. Consume the module in a configuration
4. Make a backward-compatible change (add optional feature)
5. Release version 1.1.0
6. Make a breaking change (rename variable)
7. Release version 2.0.0
8. Demonstrate version constraints in consuming configurations

### Exercise 4: Testing with Terratest
**Objective**: Write automated tests for a module

**Steps**:
1. Set up Go testing environment
2. Write tests for a simple module (e.g., security group)
3. Test creation, attributes, and outputs
4. Test error conditions (invalid inputs)
5. Run tests and verify they pass
6. Introduce a bug and verify tests fail

**Test Structure**:
```
modules/
└── security-group/
    ├── main.tf
    ├── variables.tf
    ├── outputs.tf
    └── tests/
        └── test_security_group.go
```

## 📚 References
- [Terraform Module Documentation](https://developer.hashicorp.com/terraform/language/modules)
- [Module Registry](https://registry.terraform.io/)
- [Terraform Module Registry Publishing Guide](https://developer.hashicorp.com/terraform/registry/modules/publish)
- [Terratest Documentation](https://terratest.gruntwork.io/)
- [Terraform Best Practices](https://developer.hashicorp.com/terraform/tutorials/aws-get-started/aws-build)

## 💡 Pro Tips
1. **Naming Convention**: Use `terraform-<PROVIDER>-<RESOURCE>` for public modules (e.g., `terraform-aws-vpc`)
2. **Input Defaults**: Provide sensible defaults that work for 80% of use cases
3. **Output Completeness**: Export everything a consumer might reasonably need
4. **Error Handling**: Use `try` function and custom conditions for better error messages
5. **Documentation Generation**: Consider using `terraform-docs` to automatically generate README from variables/outputs
6. **Cross-Provider Modules**: Design modules to work with multiple providers when possible (using provider aliasing)
7. **Performance**: Avoid creating excessive resources in modules; consider data sources for lookups
8. **Security**: Run tfsec/checkov on your modules as part of CI/CD
9. **Backwards Compatibility**: When changing modules, think about how existing consumers will be affected
10. **Community**: Engage with the Terraform community; share your modules and learn from others

---

*Updated: September 20, 2026*