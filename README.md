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

### Initialization
To initialize Terraform in your work environment, run the following command. This will download the necessary providers and configure the backend.
```bash
terraform init
```

### Formatting and Validation
Before applying any changes, it is recommended to format the code and validate the syntax.
```bash
# Format your Terraform code
terraform fmt

# Validate the syntax of your configuration
terraform validate
```

### Planning
To preview the changes Terraform will make to your infrastructure, use the `plan` command. This is a crucial step to verify that the changes are as expected.
```bash
terraform plan
```

### Apply
To apply the changes and deploy the resources on AWS, use the `apply` command. Terraform will ask for confirmation before proceeding.
```bash
terraform apply
```
For automated environments or when you are certain of the changes, you can use the `-auto-approve` flag to skip the confirmation.
```bash
terraform apply -auto-approve
```

### Destroy
To remove all resources created by Terraform, use the `destroy` command. This action is irreversible and will delete all infrastructure managed by your configuration.
```bash
terraform destroy
```
To skip confirmation, you can use the `-auto-approve` flag.
```bash
terraform destroy -auto-approve
```
