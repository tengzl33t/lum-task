# Lum Task

This repository contains code to deploy infrastructure in AWS to complete Lum Task.

## Core Requirements
#### Infrastructure as Code
- [ ] All AWS infrastructure must be defined and managed using Terraform.
- [x] ~~Require that the DynamoDB table uses Server-Side Encryption (SSE)~~ Enabled by default and can't be switched off.
#### Multi-Environment Setup
- [ ] Your Terraform configuration should support two distinct environments: staging and prod.
- [x] Use Terraform variables to manage differences between the environments. You should be able to deploy a specific environment by using a .tfvars file.
#### Resource Naming Convention
- [ ] All AWS resources you create must follow the naming convention: env-resource-name.
#### AWS Resources to Create
- [ ] DynamoDB Table: A single table to store request data (e.g., staging-requests-db).
- [ ] API Gateway: An HTTP endpoint exposing a /health route that accepts GET or POST requests. Prevent DDoS attacks by adding throttling mechanisms
- [ ] Lambda Function: A function (preferably in Python or Node.js) triggered by the /health endpoint (e.g., staging-health-check-function).
- [ ] IAM Role: A dedicated IAM role for the Lambda function with least-privilege permissions to execute, write logs to CloudWatch, and write items to the DynamoDB table. 
  - [ ] [Optional] A dedicated IAM role for the deployment process. Both roles should show sensible scoping and permission choices.

## Application Logic Requirements
- [ ] Log to CloudWatch: Print a log message to CloudWatch containing the incoming request event.
- [ ] Save to DynamoDB: Generate a unique ID, and save the request details as an item in the DynamoDB table.
- [ ] Respond to API Gateway: Return a 200 OK status with a JSON body.
