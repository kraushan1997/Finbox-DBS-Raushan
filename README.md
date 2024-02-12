# Finbox-DBS-Raushan

# Infrastructure as Code (IaC) for Docker Bench Security Compliance

## Description
This project aims to develop Infrastructure as Code (IaC) using Terraform to build an Amazon Machine Image (AMI) that complies with the Docker Bench Security checks. The Docker Bench Security checks ensure the security of following components in the infrastructure.
1. Host Configuration
2. Docker Daemon Configuration
3. Docker Daemon Configuration Files
4. Container Images and Build File
5. Container Runtime
6. Docker Security Operations
7. Docker Swarm Configuration

For container images and build files, the project uses the Echo-Server project available at [Echo-Server-Raushan](https://github.com/kraushan1997/Echo-Server-Raushan.git). The provided Dockerfile has been updated and utilized for building images and running containers.

### AMI
- AMI: ami-085925f297f89fce1

## Pre-requisites
- Install and configure Terraform
- Install and configure AWS CLI. We'll need to create Access key and secret key and use in aws configure.In terraform code i'm using aws ec2 commmand so it's needed.
- Create a .pem key and reference it in the Terraform file while creating the EC2 instance.

## Actions
1. Clone the repository:
    ```bash
    git clone https://github.com/kraushan1997/Finbox-DBS-Raushan.git
    cd Finbox-DBS-Raushan
    ```
    note: Update access_key, secret_key and key_name under aws_instance. 

2. Initialize Terraform:
    ```bash
    terraform init
    ```

3. Format Terraform files:
    ```bash
    terraform fmt
    ```

4. Validate Terraform configuration:
    ```bash
    terraform validate
    ```

5. Plan Terraform changes:
    ```bash
    terraform plan
    ```

6. Apply Terraform changes:
    ```bash
    terraform apply
    ```

7. Wait for 5 minutes for the Terraform deployment to complete.

8. After deployment, SSH into the instance using the .pem key created earlier:
    ```bash
    ssh -i /path/to/your/key.pem ec2-user@<instance-public-ip>
    ```

9. Navigate to the Docker Bench Security directory:
    ```bash
    cd /finbox/docker-bench-security
    ```

10. View the scan results in the output-file.txt:
    ```bash
    cat output-file.txt
    ```

## Note
- With this Terraform code, a basic infrastructure is deployed to run an EC2 instance connected to the internet.
- While attempting to resolve all errors from the Docker Bench Security checks, check 2.12 required a custom authorization plugin. The default "authz" plugin was causing errors.
- For check 2.9 i'm providing  "userns-remap": "default" still it didn't work. i tried with ubuntu user too.
- For check 2.2 when i set "icc": false , docker is unable to restart and was causing others to fail.
