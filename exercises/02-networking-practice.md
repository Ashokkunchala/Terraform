# Terraform Networking Practice Exercises

## Exercise 1: VPC Creation

**Objective**: Create a custom VPC with networking components

**Task**:
1. Create a VPC with CIDR block 10.0.0.0/16
2. Create an Internet Gateway and attach it to the VPC
3. Create a custom route table with a route to the Internet Gateway
4. Create a subnet and associate it with the custom route table
5. Create a security group allowing HTTP and SSH access
6. Launch an EC2 instance in the subnet with the security group
7. Output the VPC ID, subnet ID, and instance public IP

**Solution**:
```hcl
provider "aws" {
  region = "us-west-2"
}

# VPC
resource "aws_vpc" "main" {
  cidr_block           = "10.0.0.0/16"
  enable_dns_hostnames = true

  tags = {
    Name = "main-vpc"
  }
}

# Internet Gateway
resource "aws_internet_gateway" "main" {
  vpc_id = aws_vpc.main.id

  tags = {
    Name = "main-igw"
  }
}

# Custom Route Table
resource "aws_route_table" "public" {
  vpc_id = aws_vpc.main.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.main.id
  }

  tags = {
    Name = "public-rt"
  }
}

# Subnet
resource "aws_subnet" "public" {
  vpc_id                  = aws_vpc.main.id
  cidr_block              = "10.0.1.0/24"
  availability_zone       = "us-west-2a"
  map_public_ip_on_launch = true

  tags = {
    Name = "public-subnet"
  }
}

# Route Table Association
resource "aws_route_table_association" "public" {
  subnet_id      = aws_subnet.public.id
  route_table_id = aws_route_table.public.id
}

# Security Group
resource "aws_security_group" "web" {
  name        = "web-sg"
  description = "Allow HTTP and SSH inbound"
  vpc_id      = aws_vpc.main.id

  ingress {
    description = "HTTP"
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    description = "SSH"
    from_port   = 22
    to_port     = 22
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

  tags = {
    Name = "web-sg"
  }
}

# EC2 Instance
resource "aws_instance" "web" {
  ami                         = "ami-0abcdef1234567890"  # Replace with valid AMI
  instance_type               = "t2.micro"
  subnet_id                   = aws_subnet.public.id
  vpc_security_group_ids      = [aws_security_group.web.id]
  associate_public_ip_address = true

  tags = {
    Name = "web-server"
  }
}

# outputs.tf
output "vpc_id" {
  description = "ID of the VPC"
  value       = aws_vpc.main.id
}

output "subnet_id" {
  description = "ID of the public subnet"
  value       = aws_subnet.public.id
}

output "instance_public_ip" {
  description = "Public IP of the web server"
  value       = aws_instance.web.public_ip
}
```

## Exercise 2: Private Subnets and NAT Gateway

**Objective**: Create a VPC with public and private subnets using NAT Gateway

**Task**:
1. Create a VPC
2. Create an Internet Gateway
3. Create 2 public subnets (in different AZs)
4. Create 2 private subnets (in different AZs)
5. Create a NAT Gateway in one of the public subnets
6. Create route tables:
   - Public route table with route to IGW
   - Private route table with route to NAT Gateway
7. Associate subnets with appropriate route tables
8. Create security groups for bastion and private instances
9. Launch a bastion host in public subnet
10. Launch a private instance in private subnet
11. Output relevant IDs and IPs

**Solution**:
```hcl
provider "aws" {
  region = "us-west-2"
}

# VPC
resource "aws_vpc" "main" {
  cidr_block           = "10.0.0.0/16"
  enable_dns_hostnames = true

  tags = {
    Name = "main-vpc"
  }
}

# Internet Gateway
resource "aws_internet_gateway" "main" {
  vpc_id = aws_vpc.main.id

  tags = {
    Name = "main-igw"
  }
}

# Public Subnets
resource "aws_subnet" "public" {
  count                   = 2
  vpc_id                  = aws_vpc.main.id
  cidr_block              = cidrsubnet(aws_vpc.main.cidr_block, 4, count.index)
  availability_zone       = data.aws_availability_zones.available.names[count.index]
  map_public_ip_on_launch = true

  tags = {
    Name = "public-subnet-${count.index}"
  }
}

# Private Subnets
resource "aws_subnet" "private" {
  count                   = 2
  vpc_id                  = aws_vpc.main.id
  cidr_block              = cidrsubnet(aws_vpc.main.cidr_block, 4, count.index + 2)
  availability_zone       = data.aws_availability_zones.available.names[count.index]
  map_public_ip_on_launch = false

  tags = {
    Name = "private-subnet-${count.index}"
  }
}

# Data source for availability zones
data "aws_availability_zones" "available" {
  state = "available"
}

# NAT Gateway
resource "aws_eip" "nat" {
  vpc = true

  tags = {
    Name = "nat-eip"
  }
}

resource "aws_nat_gateway" "main" {
  allocation_id = aws_eip.nat.id
  subnet_id     = element(aws_subnet.public[*].id, 0)  # Put in first public subnet

  tags = {
    Name = "main-nat"
  }
}

# Public Route Table
resource "aws_route_table" "public" {
  vpc_id = aws_vpc.main.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.main.id
  }

  tags = {
    Name = "public-rt"
  }
}

# Private Route Table
resource "aws_route_table" "private" {
  vpc_id = aws_vpc.main.id

  route {
    cidr_block = "0.0.0.0/0"
    nat_gateway_id = aws_nat_gateway.main.id
  }

  tags = {
    Name = "private-rt"
  }
}

# Route Table Associations
resource "aws_route_table_association" "public" {
  count          = 2
  subnet_id      = element(aws_subnet.public[*].id, count.index)
  route_table_id = aws_route_table.public.id
}

resource "aws_route_table_association" "private" {
  count          = 2
  subnet_id      = element(aws_subnet.private[*].id, count.index)
  route_table_id = aws_route_table.private.id
}

# Security Groups
resource "aws_security_group" "bastion" {
  name        = "bastion-sg"
  description = "Allow SSH inbound"
  vpc_id      = aws_vpc.main.id

  ingress {
    description = "SSH"
    from_port   = 22
    to_port     = 22
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

  tags = {
    Name = "bastion-sg"
  }
}

resource "aws_security_group" "private_app" {
  name        = "private-app-sg"
  description = "Allow SSH from bastion only"
  vpc_id      = aws_vpc.main.id

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

  tags = {
    Name = "private-app-sg"
  }
}

# Bastion Host
resource "aws_instance" "bastion" {
  ami                         = "ami-0abcdef1234567890"  # Replace with valid AMI
  instance_type               = "t2.micro"
  subnet_id                   = element(aws_subnet.public[*].id, 0)
  vpc_security_group_ids      = [aws_security_group.bastion.id]
  associate_public_ip_address = true

  tags = {
    Name = "bastion-host"
  }
}

# Private Instance
resource "aws_instance" "private_app" {
  ami                         = "ami-0abcdef1234567890"  # Replace with valid AMI
  instance_type               = "t2.micro"
  subnet_id                   = element(aws_subnet.private[*].id, 0)
  vpc_security_group_ids      = [aws_security_group.private_app.id]
  associate_public_ip_address = false

  tags = {
    Name = "private-app"
  }
}

# outputs.tf
output "vpc_id" {
  description = "ID of the VPC"
  value       = aws_vpc.main.id
}

output "public_subnet_ids" {
  description = "IDs of public subnets"
  value       = aws_subnet.public[*].id
}

output "private_subnet_ids" {
  description = "IDs of private subnets"
  value       = aws_subnet.private[*].id
}

output "nat_gateway_id" {
  description = "ID of the NAT Gateway"
  value       = aws_nat_gateway.main.id
}

output "bastion_public_ip" {
  description = "Public IP of bastion host"
  value       = aws_instance.bastion.public_ip
}

output "private_instance_private_ip" {
  description = "Private IP of the private instance"
  value       = aws_instance.private_app.private_ip
}
```

## Exercise 3: VPC Peering

**Objective**: Create two VPCs and establish peering between them

**Task**:
1. Create two VPCs with non-overlapping CIDR blocks
2. Create subnets in each VPC
3. Create VPC peering connection between the two VPCs
4. Update route tables in both VPCs to route traffic via the peering connection
5. Create security groups allowing communication between VPCs
6. Launch instances in each VPC
7. Output VPC IDs, peering connection ID, and instance IPs

**Solution**:
```hcl
provider "aws" {
  region = "us-west-2"
}

# VPC 1
resource "aws_vpc" "vpc1" {
  cidr_block           = "10.0.0.0/16"
  enable_dns_hostnames = true

  tags = {
    Name = "vpc1"
  }
}

# VPC 2
resource "aws_vpc" "vpc2" {
  cidr_block           = "10.1.0.0/16"
  enable_dns_hostnames = true

  tags = {
    Name = "vpc2"
  }
}

# Subnets for VPC 1
resource "aws_subnet" "vpc1_public" {
  vpc_id                  = aws_vpc.vpc1.id
  cidr_block              = "10.0.1.0/24"
  availability_zone       = "us-west-2a"
  map_public_ip_on_launch = true

  tags = {
    Name = "vpc1-public-subnet"
  }
}

# Subnets for VPC 2
resource "aws_subnet" "vpc2_public" {
  vpc_id                  = aws_vpc.vpc2.id
  cidr_block              = "10.1.1.0/24"
  availability_zone       = "us-west-2a"
  map_public_ip_on_launch = true

  tags = {
    Name = "vpc2-public-subnet"
  }
}

# Internet Gateways
resource "aws_internet_gateway" "vpc1_igw" {
  vpc_id = aws_vpc.vpc1.id

  tags = {
    Name = "vpc1-igw"
  }
}

resource "aws_internet_gateway" "vpc2_igw" {
  vpc_id = aws_vpc.vpc2.id

  tags = {
    Name = "vpc2-igw"
  }
}

# VPC Peering Connection
resource "aws_vpc_peering_connection" "peering" {
  vpc_id      = aws_vpc.vpc1.id
  peer_vpc_id = aws_vpc.vpc2.id

  auto_accept = true

  tags = {
    Name = "peering-vpc1-vpc2"
  }
}

# Route Tables for VPC 1
resource "aws_route_table" "vpc1_public" {
  vpc_id = aws_vpc.vpc1.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.vpc1_igw.id
  }

  route {
    cidr_block = aws_vpc.vpc2.cidr_block
    vpc_peering_connection_id = aws_vpc_peering_connection.peering.id
  }

  tags = {
    Name = "vpc1-public-rt"
  }
}

# Route Tables for VPC 2
resource "aws_route_table" "vpc2_public" {
  vpc_id = aws_vpc.vpc2.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.vpc2_igw.id
  }

  route {
    cidr_block = aws_vpc.vpc1.cidr_block
    vpc_peering_connection_id = aws_vpc_peering_connection.peering.id
  }

  tags = {
    Name = "vpc2-public-rt"
  }
}

# Route Table Associations
resource "aws_route_table_association" "vpc1_public" {
  subnet_id      = aws_subnet.vpc1_public.id
  route_table_id = aws_route_table.vpc1_public.id
}

resource "aws_route_table_association" "vpc2_public" {
  subnet_id      = aws_subnet.vpc2_public.id
  route_table_id = aws_route_table.vpc2_public.id
}

# Security Groups
resource "aws_security_group" "vpc1_instance" {
  name        = "vpc1-instance-sg"
  description = "Allow SSH and inter-VPC communication"
  vpc_id      = aws_vpc.vpc1.id

  ingress {
    description = "SSH"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]  # Restrict in production!
  }

  ingress {
    description = "Allow from VPC2"
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    security_groups = [aws_security_group.vpc2_instance.id]
  }

  egress {
    description = "All outbound"
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "vpc1-instance-sg"
  }
}

resource "aws_security_group" "vpc2_instance" {
  name        = "vpc2-instance-sg"
  description = "Allow SSH and inter-VPC communication"
  vpc_id      = aws_vpc.vpc2.id

  ingress {
    description = "SSH"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]  # Restrict in production!
  }

  ingress {
    description = "Allow from VPC1"
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    security_groups = [aws_security_group.vpc1_instance.id]
  }

  egress {
    description = "All outbound"
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "vpc2-instance-sg"
  }
}

# Instances
resource "aws_instance" "vpc1_instance" {
  ami                         = "ami-0abcdef1234567890"  # Replace with valid AMI
  instance_type               = "t2.micro"
  subnet_id                   = aws_subnet.vpc1_public.id
  vpc_security_group_ids      = [aws_security_group.vpc1_instance.id]
  associate_public_ip_address = true

  tags = {
    Name = "vpc1-instance"
  }
}

resource "aws_instance" "vpc2_instance" {
  ami                         = "ami-0abcdef1234567890"  # Replace with valid AMI
  instance_type               = "t2.micro"
  subnet_id                   = aws_subnet.vpc2_public.id
  vpc_security_group_ids      = [aws_security_group.vpc2_instance.id]
  associate_public_ip_address = true

  tags = {
    Name = "vpc2-instance"
  }
}

# outputs.tf
output "vpc1_id" {
  description = "ID of VPC 1"
  value       = aws_vpc.vpc1.id
}

output "vpc2_id" {
  description = "ID of VPC 2"
  value       = aws_vpc.vpc2.id
}

output "peering_connection_id" {
  description = "ID of the VPC peering connection"
  value       = aws_vpc_peering_connection.peering.id
}

output "vpc1_instance_public_ip" {
  description = "Public IP of instance in VPC 1"
  value       = aws_instance.vpc1_instance.public_ip
}

output "vpc2_instance_public_ip" {
  description = "Public IP of instance in VPC 2"
  value       = aws_instance.vpc2_instance.public_ip
}
```

## Exercise 4: Advanced Networking - Transit Gateway

**Objective**: Practice with AWS Transit Gateway for hub-and-spoke networking

**Task**:
1. Create a Transit Gateway
2. Create 3 VPCs (spokes)
3. Create VPC attachments to the Transit Gateway for each VPC
4. Create route tables in the Transit Gateway
5. Associate VPC attachments with Transit Gateway route tables
6. Propagate VPC routes to Transit Gateway route tables
7. Create route tables in each VPC to route traffic via Transit Gateway
8. Launch instances in each VPC
9. Output relevant IDs and IPs

**Note**: This exercise introduces more advanced networking concepts.

**Solution**:
```hcl
provider "aws" {
  region = "us-west-2"
}

# Transit Gateway
resource "aws_ec2_transit_gateway" "tgw" {
  description = "Transit Gateway for hub-and-spoke"

  tags = {
    Name = "main-tgw"
  }
}

# Transit Gateway Route Table
resource "aws_ec2_transit_gateway_route_table" "tgw_rt" {
  transit_gateway_id = aws_ec2_transit_gateway.tgw.id

  tags = {
    Name = "tgw-route-table"
  }
}

# Create 3 VPCs (spokes)
locals {
  spoke_cidrs = [
    "10.0.0.0/16",
    "10.1.0.0/16",
    "10.2.0.0/16"
  ]
}

resource "aws_vpc" "spokes" {
  for_each = toset(local.spoke_cidrs)

  cidr_block           = each.value
  enable_dns_hostnames = true

  tags = {
    Name = "spoke-${each.key}"
  }
}

# Subnets for each VPC
resource "aws_subnet" "spokes" {
  for_each = {
    for idx, cidr in local.spoke_cidrs : idx => cidr
  }

  vpc_id                  = element(aws_vpc.spokes[*].id, each.key)
  cidr_block              = cidrsubnet(each.value, 4, 0)
  availability_zone       = "us-west-2a"
  map_public_ip_on_launch = true

  tags = {
    Name = "spoke-${each.key}-subnet"
  }
}

# Internet Gateways for each VPC
resource "aws_internet_gateway" "spokes" {
  for_each = aws_vpc.spokes

  vpc_id = each.value.id

  tags = {
    Name = "igw-${each.key}"
  }
}

# VPC Attachments to Transit Gateway
resource "aws_ec2_transit_gateway_vpc_attachment" "attachments" {
  for_each = aws_vpc.spokes

  subnet_id         = element(aws_subnet.spokes[*].id, each.key)
  transit_gateway_id = aws_ec2_transit_gateway.tgw.id

  tags = {
    Name = "tgw-attachment-${each.key}"
  }
}

# Associate VPC attachments with Transit Gateway route table
resource "aws_ec2_transit_gateway_route_table_association" "associations" {
  for_each = aws_ec2_transit_gateway_vpc_attachment.attachments

  transit_gateway_route_table_id = aws_ec2_transit_gateway_route_table.tgw_rt.id
  transit_gateway_attachment_id  = each.value.id
}

# Propagate VPC routes to Transit Gateway route table
resource "aws_ec2_transit_gateway_route_table_propagation" "propagations" {
  for_each = aws_ec2_transit_gateway_vpc_attachment.attachments

  transit_gateway_route_table_id = aws_ec2_transit_gateway_route_table.tgw_rt.id
  transit_gateway_attachment_id  = each.value.id
}

# Route Tables in each VPC to route via Transit Gateway
resource "aws_route_table" "spokes" {
  for_each = aws_vpc.spokes

  vpc_id = each.value.id

  route {
    cidr_block = "0.0.0.0/0"
    # This is a simplified route - in practice, you'd need to get the TGW attachment ID
    # For this exercise, we'll use a placeholder
    # transit_gateway_id = aws_ec2_transit_gateway.tgw.id
    # Note: Actual implementation would require getting the attachment ID properly
  }

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = element(aws_internet_gateway.spokes[*].id, each.key)
  }

  tags = {
    Name = "spoke-${each.key}-rt"
  }
}

# Route Table Associations in each VPC
resource "aws_route_table_association" "spokes" {
  for_each = aws_subnet.spokes

  subnet_id      = each.value.id
  route_table_id = element(aws_route_table.spokes[*].id, each.key)
}

# Security Groups (allow SSH from anywhere for simplicity)
resource "aws_security_group" "spokes" {
  for_each = aws_vpc.spokes

  name        = "spoke-${each.key}-sg"
  description = "Allow SSH inbound"
  vpc_id      = each.value.id

  ingress {
    description = "SSH"
    from_port   = 22
    to_port     = 22
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

  tags = {
    Name = "spoke-${each.key}-sg"
  }
}

# Instances in each VPC
resource "aws_instance" "spokes" {
  for_each = aws_subnet.spokes

  ami                         = "ami-0abcdef1234567890"  # Replace with valid AMI
  instance_type               = "t2.micro"
  subnet_id                   = each.value.id
  vpc_security_group_ids      = [element(aws_security_group.spokes[*].id, each.key)]
  associate_public_ip_address = true

  tags = {
    Name = "spoke-${each.key}-instance"
  }
}

# outputs.tf
output "transit_gateway_id" {
  description = "ID of the Transit Gateway"
  value       = aws_ec2_transit_gateway.tgw.id
}

output "transit_gateway_route_table_id" {
  description = "ID of the Transit Gateway Route Table"
  value       = aws_ec2_transit_gateway_route_table.tgw_rt.id
}

output "vpc_ids" {
  description = "IDs of the spoke VPCs"
  value       = [for vpc in aws_vpc.spokes : vpc.id]
}

output "instance_public_ips" {
  description = "Public IDs of instances in spoke VPCs"
  value       = [for instance in aws_instance.spokes : instance.public_ip]
}
```

> **Note**: The Transit Gateway exercise is simplified for clarity. In a production implementation, you would need to properly handle the Transit Gateway attachments and routing, which requires more complex data lookups.

## Exercise 5: DNS with Route 53

**Objective**: Practice creating DNS records with Route 53

**Task**:
1. Create a Route 53 hosted zone for a domain (use a test domain or subdomain)
2. Create an A record pointing to an EC2 instance's public IP
3. Create a CNAME record for www subdomain
4. Create a TXT record for verification purposes
5. Create an alias record pointing to an AWS resource (like an ELB)
6. Output the hosted zone ID and record details

**Solution**:
```hcl
provider "aws" {
  region = "us-west-2"
}

# Create a simple EC2 instance for testing
resource "aws_instance" "web" {
  ami                         = "ami-0abcdef1234567890"  # Replace with valid AMI
  instance_type               = "t2.micro"
  associate_public_ip_address = true

  tags = {
    Name = "web-for-dns"
  }
}

# For this exercise, we'll create a hosted zone for a subdomain
# In practice, you would use a domain you own
resource "aws_route53_zone" "primary" {
  name         = "example-test.tfpractice.com"  # Change to a domain you control or use a subdomain
  comment      = "Managed by Terraform"

  tags = {
    Environment = "practice"
  }
}

# A record pointing to EC2 instance
resource "aws_route53_record" "a_record" {
  zone_id = aws_route53_zone.primary.id
  name    = "web.example-test.tfpractice.com"
  type    = "A"
  ttl     = "300"
  records = [aws_instance.web.public_ip]
}

# CNAME record for www
resource "aws_route53_record" "cname_record" {
  zone_id = aws_route53_zone.primary.id
  name    = "www.web.example-test.tfpractice.com"
  type    = "CNAME"
  ttl     = "300"
  records = ["web.example-test.tfpractice.com"]
}

# TXT record for verification
resource "aws_route53_record" "txt_record" {
  zone_id = aws_route53_zone.primary.id
  name    = "verify.example-test.tfpractice.com"
  type    = "TXT"
  ttl     = "300"
  records = ["\"verification=abc123def456\""]  # TXT values must be quoted
}

# Example of an ALB and alias record (commented out for simplicity)
"""
resource "aws_lb" "web_alb" {
  name               = "web-alb"
  internal           = false
  load_balancer_type = "application"
  security_groups    = [aws_security_group.alb.id]
  subnets            = [aws_subnet.public[*].id]

  tags = {
    Environment = "practice"
  }
}

resource "aws_lb_target_group" "web_tg" {
  name     = "web-tg"
  port     = 80
  protocol = "HTTP"
  vpc_id   = aws_vpc.main.id

  health_check {
    path                = "/"
    protocol            = "HTTP"
    matcher             = "200-299"
    interval            = 30
    timeout             = 5
    healthy_threshold   = 2
    unhealthy_threshold = 2
  }
}

resource "aws_lb_listener" "web_http" {
  load_balancer_arn = aws_lb.web_alb.arn
  port              = "80"
  protocol          = "HTTP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.web_tg.arn
  }
}

resource "aws_route53_record" "alias_record" {
  zone_id = aws_route53_zone.primary.id
  name    = "app.example-test.tfpractice.com"
  type    = "A"

  alias {
    name                   = aws_lb.web_alb.dns_name
    zone_id                = aws_lb.web_alb.zone_id
    evaluate_target_health = true
  }
}
"""

# outputs.tf
output "hosted_zone_id" {
  description = "ID of the Route 53 hosted zone"
  value       = aws_route53_zone.primary.id
}

output "hosted_zone_name" {
  description = "Name of the Route 53 hosted zone"
  value       = aws_route53_zone.primary.name
}

output "a_record_fqdn" {
  description = "FQDN of the A record"
  value       = aws_route53_record.a_record.fqdn
}

output "cname_record_fqdn" {
  description = "FQDN of the CNAME record"
  value       = aws_route53_record.cname_record.fqdn
}

output "txt_record_fqdn" {
  description = "FQDN of the TXT record"
  value       = aws_route53_record.txt_record.fqdn
}
```

## Exercise 6: Elastic Load Balancing

**Objective**: Practice creating different types of load balancers

**Task**:
1. Create a VPC with public subnets
2. Create an Application Load Balancer (ALB)
3. Create target groups for the ALB
4. Create EC2 instances and register them with target groups
5. Create listeners for the ALB (HTTP and HTTPS if possible)
6. Create security groups for the ALB and instances
7. Create a Network Load Balancer (NLB) for comparison
8. Output the DNS names of both load balancers

**Solution**:
```hcl
provider "aws" {
  region = "us-west-2"
}

# VPC
resource "aws_vpc" "main" {
  cidr_block           = "10.0.0.0/16"
  enable_dns_hostnames = true

  tags = {
    Name = "main-vpc"
  }
}

# Public Subnets (2 for ALB/NLB redundancy)
resource "aws_subnet" "public" {
  count                   = 2
  vpc_id                  = aws_vpc.main.id
  cidr_block              = cidrsubnet(aws_vpc.main.cidr_block, 4, count.index)
  availability_zone       = data.aws_availability_zones.available.names[count.index]
  map_public_ip_on_launch = true

  tags = {
    Name = "public-subnet-${count.index}"
  }
}

# Data source for availability zones
data "aws_availability_zones" "available" {
  state = "available"
}

# Security Group for ALB
resource "aws_security_group" "alb" {
  name        = "alb-sg"
  description = "Allow HTTP inbound"
  vpc_id      = aws_vpc.main.id

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

  tags = {
    Name = "alb-sg"
  }
}

# Security Group for EC2 instances
resource "aws_security_group" "instance" {
  name        = "instance-sg"
  description = "Allow traffic from ALB only"
  vpc_id      = aws_vpc.main.id

  ingress {
    description = "HTTP from ALB"
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    security_groups = [aws_security_group.alb.id]
  }

  egress {
    description = "All outbound"
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "instance-sg"
  }
}

# Application Load Balancer
resource "aws_lb" "alb" {
  name               = "web-alb"
  internal           = false
  load_balancer_type = "application"
  security_groups    = [aws_security_group.alb.id]
  subnets            = aws_subnet.public[*].id

  enable_deletion_protection = false

  tags = {
    Environment = "practice"
  }
}

# Target Group for ALB
resource "aws_lb_target_group" "alb_tg" {
  name     = "web-alb-tg"
  port     = 80
  protocol = "HTTP"
  vpc_id   = aws_vpc.main.id

  health_check {
    path                = "/"
    protocol            = "HTTP"
    matcher             = "200-299"
    interval            = 30
    timeout             = 5
    healthy_threshold   = 2
    unhealthy_threshold = 2
  }

  tags = {
    Environment = "practice"
  }
}

# Listener for ALB
resource "aws_lb_listener" "alb_http" {
  load_balancer_arn = aws_lb.alb.arn
  port              = "80"
  protocol          = "HTTP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.alb_tg.arn
  }
}

# EC2 Instances
resource "aws_instance" "web" {
  count                  = 2
  ami                    = "ami-0abcdef1234567890"  # Replace with valid AMI
  instance_type          = "t2.micro"
  subnet_id              = element(aws_subnet.public[*].id, count.index)
  vpc_security_group_ids = [aws_security_group.instance.id]

  tags = {
    Name = "web-instance-${count.index}"
  }
}

# Register instances with target group
resource "aws_lb_target_group_attachment" "alb_attach" {
  count                = 2
  target_group_arn     = aws_lb_target_group.alb_tg.arn
  target_id            = element(aws_instance.web[*].id, count.index)
  port                 = 80
}

# Network Load Balancer (for comparison)
resource "aws_lb" "nlb" {
  name               = "web-nlb"
  internal           = false
  load_balancer_type = "network"
  security_groups    = [aws_security_group.alb.id]  # Can reuse or create separate
  subnets            = aws_subnet.public[*].id

  enable_deletion_protection = false

  tags = {
    Environment = "practice"
  }
}

# Target Group for NLB
resource "aws_lb_target_group" "nlb_tg" {
  name     = "web-nlb-tg"
  port     = 80
  protocol = "TCP"
  vpc_id   = aws_vpc.main.id

  health_check {
    protocol            = "TCP"
    port                = "traffic-port"
    interval            = 30
    timeout             = 5
    healthy_threshold   = 2
    unhealthy_threshold = 2
  }

  tags = {
    Environment = "practice"
  }
}

# Listener for NLB
resource "aws_lb_listener" "nlb_tcp" {
  load_balancer_arn = aws_lb.nlb.arn
  port              = "80"
  protocol          = "TCP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.nlb_tg.arn
  }
}

# Register instances with NLB target group
resource "aws_lb_target_group_attachment" "nlb_attach" {
  count                = 2
  target_group_arn     = aws_lb_target_group.nlb_tg.arn
  target_id            = element(aws_instance.web[*].id, count.index)
  port                 = 80
}

# outputs.tf
output "alb_dns_name" {
  description = "DNS name of the Application Load Balancer"
  value       = aws_lb.alb.dns_name
}

output "nlb_dns_name" {
  description = "DNS name of the Network Load Balancer"
  value       = aws_lb.nlb.dns_name
}

output "alb_target_group_arn" {
  description = "ARN of the ALB target group"
  value       = aws_lb_target_group.alb_tg.arn
}

output "nlb_target_group_arn" {
  description = "ARN of the NLB target group"
  value       = aws_lb_target_group.nlb_tg.arn
}
```

## Exercise 7: NAT Instance vs NAT Gateway Comparison

**Objective**: Compare NAT Instance and NAT Gateway implementations

**Task**:
1. Create a VPC with public and private subnets
2. Implement NAT using a NAT Gateway in one configuration
3. Implement NAT using a NAT Instance in another configuration
4. Compare costs, performance, and management overhead
5. Output relevant details for both implementations

**Solution** (NAT Gateway version - comment out NAT Instance section to compare):
```hcl
provider "aws" {
  region = "us-west-2"
}

# VPC
resource "aws_vpc" "main" {
  cidr_block           = "10.0.0.0/16"
  enable_dns_hostnames = true

  tags = {
    Name = "main-vpc"
  }
}

# Public Subnet
resource "aws_subnet" "public" {
  vpc_id                  = aws_vpc.main.id
  cidr_block              = "10.0.1.0/24"
  availability_zone       = "us-west-2a"
  map_public_ip_on_launch = true

  tags = {
    Name = "public-subnet"
  }
}

# Private Subnet
resource "aws_subnet" "private" {
  vpc_id                  = aws_vpc.main.id
  cidr_block              = "10.0.2.0/24"
  availability_zone       = "us-west-2a"
  map_public_ip_on_launch = false

  tags = {
    Name = "private-subnet"
  }
}

# Internet Gateway
resource "aws_internet_gateway" "main" {
  vpc_id = aws_vpc.main.id

  tags = {
    Name = "main-igw"
  }
}

# ========== NAT GATEWAY APPROACH ==========
# Elastic IP for NAT Gateway
resource "aws_eip" "nat" {
  vpc = true

  tags = {
    Name = "nat-eip"
  }
}

# NAT Gateway
resource "aws_nat_gateway" "main" {
  allocation_id = aws_eip.nat.id
  subnet_id     = aws_subnet.public.id

  tags = {
    Name = "main-nat"
  }
}

# ========== NAT INSTANCE APPROACH (comment out to compare) ==========
"""
# Create NAT instance security group
resource "aws_security_group" "nat_instance" {
  name        = "nat-instance-sg"
  description = "Allow NAT traffic"
  vpc_id      = aws_vpc.main.id

  ingress {
    description = "HTTP from private subnet"
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = [aws_subnet.private.cidr_block]
  }

  ingress {
    description = "HTTPS from private subnet"
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = [aws_subnet.private.cidr_block]
  }

  ingress {
    description = "SSH from anywhere (for maintenance)"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]  # Restrict in production!
  }

  egress {
    description = "All outbound to internet"
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "nat-instance-sg"
  }
}

# NAT Instance
resource "aws_instance" "nat" {
  ami                         = "ami-0abcdef1234567890"  # Replace with valid AMI
  instance_type               = "t2.micro"
  subnet_id                   = aws_subnet.public.id
  vpc_security_group_ids      = [aws_security_group.nat_instance.id]
  associate_public_ip_address = true
  source_dest_check           = false  # Required for NAT instance

  tags = {
    Name = "nat-instance"
  }
}
"""

# Route Tables
# Public Route Table
resource "aws_route_table" "public" {
  vpc_id = aws_vpc.main.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.main.id
  }

  tags = {
    Name = "public-rt"
  }
}

# Private Route Table
resource "aws_route_table" "private" {
  vpc_id = aws_vpc.main.id

  # Use NAT Gateway if configured, otherwise use NAT Instance
  # NAT Gateway version:
  route {
    cidr_block = "0.0.0.0/0"
    nat_gateway_id = aws_nat_gateway.main.id
  }

  # NAT Instance version (uncomment if using NAT Instance):
  # route {
  #   cidr_block = "0.0.0.0/0"
  #   instance_id = aws_instance.nat.id
  # }

  tags = {
    Name = "private-rt"
  }
}

# Route Table Associations
resource "aws_route_table_association" "public" {
  subnet_id      = aws_subnet.public.id
  route_table_id = aws_route_table.public.id
}

resource "aws_route_table_association" "private" {
  subnet_id      = aws_subnet.private.id
  route_table_id = aws_route_table.private.id
}

# Instance in private subnet to test NAT
resource "aws_instance" "private_test" {
  ami                         = "ami-0abcdef1234567890"  # Replace with valid AMI
  instance_type               = "t2.micro"
  subnet_id                   = aws_subnet.private.id
  associate_public_ip_address = false
  vpc_security_group_ids      = [aws_security_group.instance.id]

  tags = {
    Name = "private-test-instance"
  }
}

# Security group for test instance
resource "aws_security_group" "instance" {
  name        = "instance-sg"
  description = "Allow outbound internet"
  vpc_id      = aws_vpc.main.id

  ingress {
    description = "SSH from anywhere (for testing)"
    from_port   = 22
    to_port     = 22
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

  tags = {
    Name = "instance-sg"
  }
}

# outputs.tf
output "nat_gateway_id" {
  description = "ID of the NAT Gateway (if used)"
  value       = aws_nat_gateway.main.id
}

output "nat_instance_id" {
  description = "ID of the NAT Instance (if used)"
  # value       = aws_instance.nat.id  # Uncomment if using NAT Instance
  value       = "NAT Instance not configured - uncomment in code to use"
}

output "public_subnet_id" {
  description = "ID of the public subnet"
  value       = aws_subnet.public.id
}

output "private_subnet_id" {
  description = "ID of the private subnet"
  value       = aws_subnet.private.id
}

output "vpc_id" {
  description = "ID of the VPC"
  value       = aws_vpc.main.id
}
```

## Exercise 8: AWS PrivateLink / VPC Endpoints

**Objective**: Practice creating VPC endpoints for AWS services

**Task**:
1. Create a VPC with private subnets
2. Create an S3 gateway endpoint
3. Create an interface endpoint for AWS Systems Manager (SSM)
4. Create an interface endpoint for Amazon CloudWatch Logs
5. Create EC2 instances in private subnets (no NAT)
6. Verify that instances can access S3 and AWS services via the endpoints
7. Output endpoint IDs and details

**Solution**:
```hcl
provider "aws" {
  region = "us-west-2"
}

# VPC
resource "aws_vpc" "main" {
  cidr_block           = "10.0.0.0/16"
  enable_dns_hostnames = true
  enable_dns_support   = true

  tags = {
    Name = "main-vpc"
  }
}

# Private Subnets (2 for redundancy)
resource "aws_subnet" "private" {
  count                   = 2
  vpc_id                  = aws_vpc.main.id
  cidr_block              = cidrsubnet(aws_vpc.main.cidr_block, 4, count.index)
  availability_zone       = data.aws_availability_zones.available.names[count.index]
  map_public_ip_on_launch = false  # Important: No public IPs

  tags = {
    Name = "private-subnet-${count.index}"
  }
}

# Data source for availability zones
data "aws_availability_zones" "available" {
  state = "available"
}

# S3 Gateway Endpoint
resource "aws_vpc_endpoint" "s3" {
  vpc_id              = aws_vpc.main.id
  service_name        = "com.amazonaws.${var.region}.s3"
  vpc_endpoint_type   = "Gateway"

  route_table_ids = [aws_route_table.private[*].id]  # Associate with private subnet route tables

  tags = {
    Name = "s3-endpoint"
  }
}

# Interface Endpoint for SSM
resource "aws_vpc_endpoint" "ssm" {
  vpc_id             = aws_vpc.main.id
  service_name       = "com.amazonaws.${var.region}.ssm"
  vpc_endpoint_type  = "Interface"
  subnet_ids         = aws_subnet.private[*].id
  security_group_ids = [aws_security_group.endpoint.id]

  private_dns_enabled = true

  tags = {
    Name = "ssm-endpoint"
  }
}

# Interface Endpoint for EC2 Messages (required for SSM)
resource "aws_vpc_endpoint" "ec2messages" {
  vpc_id             = aws_vpc.main.id
  service_name       = "com.amazonaws.${var.region}.ec2messages"
  vpc_endpoint_type  = "Interface"
  subnet_ids         = aws_subnet.private[*].id
  security_group_ids = [aws_security_group.endpoint.id]

  private_dns_enabled = true

  tags = {
    Name = "ec2messages-endpoint"
  }
}

# Interface Endpoint for CloudWatch Logs
resource "aws_vpc_endpoint" "cloudwatchlogs" {
  vpc_id             = aws_vpc.main.id
  service_name       = "com.amazonaws.${var.region}.logs"
  vpc_endpoint_type  = "Interface"
  subnet_ids         = aws_subnet.private[*].id
  security_group_ids = [aws_security_group.endpoint.id]

  private_dns_enabled = true

  tags = {
    Name = "cloudwatchlogs-endpoint"
  }
}

# Security Group for VPC Endpoints
resource "aws_security_group" "endpoint" {
  name        = "vpc-endpoint-sg"
  description = "Allow traffic to VPC endpoints"
  vpc_id      = aws_vpc.main.id

  # Allow HTTPS from the VPC itself
  ingress {
    description = "HTTPS from VPC"
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = [aws_vpc.main.cidr_block]
  }

  egress {
    description = "All outbound"
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "vpc-endpoint-sg"
  }
}

# Route Table for Private Subnets
resource "aws_route_table" "private" {
  count                   = 2
  vpc_id                  = aws_vpc.main.id

  route {
    cidr_block = "0.0.0.0/0"
    # No NAT gateway/internet gateway - traffic goes via endpoints
    # Blackhole route for non-AWS traffic (optional)
    # blackhole = true
  }

  tags = {
    Name = "private-rt-${count.index}"
  }
}

# Route Table Associations
resource "aws_route_table_association" "private" {
  count          = 2
  subnet_id      = element(aws_subnet.private[*].id, count.index)
  route_table_id = element(aws_route_table.private[*].id, count.index)
}

# EC2 Instances in private subnets
resource "aws_instance" "private" {
  count                  = 2
  ami                    = "ami-0abcdef1234567890"  # Replace with valid AMI (Amazon Linux 2 recommended)
  instance_type          = "t2.micro"
  subnet_id              = element(aws_subnet.private[*].id, count.index)
  associate_public_ip_address = false

  # For SSM access, ensure the instance has the right IAM role
  # iam_instance_profile = aws_iam_instance_profile.ssm_access.name

  tags = {
    Name = "private-instance-${count.index}"
  }
}

# Security Group for EC2 instances (allow SSM communication)
resource "aws_security_group" "instance" {
  name        = "instance-sg"
  description = "Allow SSM communication"
  vpc_id      = aws_vpc.main.id

  # Allow HTTPS to the VPC endpoints (managed by the endpoint SG)
  # Actually, instances don't need special SGs to communicate with endpoints
  # as long as routing works and endpoint SGs allow it

  egress {
    description = "All outbound"
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "instance-sg"
  }
}

# outputs.tf
output "vpc_id" {
  description = "ID of the VPC"
  value       = aws_vpc.main.id
}

output "s3_endpoint_id" {
  description = "ID of the S3 Gateway Endpoint"
  value       = aws_vpc_endpoint.s3.id
}

output "ssm_endpoint_id" {
  description = "ID of the SSM Interface Endpoint"
  value       = aws_vpc_endpoint.ssm.id
}

output "ec2messages_endpoint_id" {
  description = "ID of the EC2Messages Interface Endpoint"
  value       = aws_vpc_endpoint.ec2messages.id
}

output "cloudwatchlogs_endpoint_id" {
  description = "ID of the CloudWatch Logs Interface Endpoint"
  value       = aws_vpc_endpoint.cloudwatchlogs.id
}

output "private_subnet_ids" {
  description = "IDs of the private subnets"
  value       = aws_subnet.private[*].id
}
```

---

*Each exercise includes both the task description and a sample solution. Try to complete the exercises on your own before looking at the solutions!*