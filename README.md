# Terraform AWS Infrastructure

## Description

This project deploys a complete AWS infrastructure using Terraform. It is organized into a modular structure with a root module and six child modules: `compute`, `database`, `lb`, `network`, `security_groups`, and `storage`.

## Project Structure

- **Root Module**: The main entry point for the Terraform configuration. It calls the child modules and passes the necessary variables.
  - `main.tf`: Defines the module calls and their interconnections.
  - `variables.tf`: Declares the input variables for the root module.
  - `outputs.tf`: Defines the outputs of the root module.
  - `terraform.tfvars`: Contains the specific values for the input variables.

- **Child Modules**:
  - `modules/network`: Creates the VPC, subnets, and other networking resources.
  - `modules/security_groups`: Defines the security groups for the different resources.
  - `modules/storage`: Creates the S3 bucket for static website hosting.
  - `modules/database`: Deploys the RDS database.
  - `modules/lb`: Configures the Application Load Balancers.
  - `modules/compute`: Deploys the EC2 instances.

## Usage

1. **Initialize Terraform**:
   ```bash
   terraform init
   ```

2. **Plan the deployment**:
   ```bash
   terraform plan
   ```

3. **Apply the configuration**:
   ```bash
   terraform apply
   ```
