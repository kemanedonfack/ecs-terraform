# Creating an ECS Cluster and Deploying Nginx with Terraform Module

## Introduction
In this article, we're diving into the world of container orchestration with AWS Elastic Container Service (ECS) and the simplicity of Terraform. Our mission is clear: create an ECS cluster and deploy Nginx efficiently using our own Terraform modules.


## Prerequisites

Before diving into the configuration of our Terraform modules, ensure the following prerequisites are met to facilitate a seamless implementation.

- **AWS Account Setup:**  Ensure you have an AWS account with the necessary permissions to create resources. 
- **Terraform Basics:** Have a basic understanding of Terraform and its fundamental concepts. 
- **Understanding Terraform Modules:**  For better comprehension, it's recommended to have read our previous article on [Terraform modules](https://blog.kemanedonfack.com/demystifying-terraform-modules/). 

## Step 1: Define Your Infrastructure

In this step, we will define our infrastructure using custom Terraform modules tailored to our specific requirements.

### Custom Terraform Modules

Before we proceed, let's acquaint ourselves with the custom Terraform modules we've crafted to elevate the modularity of our infrastructure definition.

- **ALB Module (`alb`):** Configures an Application Load Balancer (ALB) for seamless communication between our ECS cluster and external traffic.

- **ECS Module (`ecs`):** Orchestrates the setup of the ECS cluster, defining services and task definitions, ensuring the effective deployment of Nginx.

- **Security Group Module (`securitygroup`):**  Creates security groups tailored for both the ALB and ECS, ensuring a secure communication environment.




