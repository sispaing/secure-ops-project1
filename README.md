
# secure-ops-project1
# vault-dynamic-credential-infra-mgmt-demo
Demo for Dynamic Credential and Infrastructure Management with Vault, AWS, and Terraform Cloud

### **Project Title:** SecureCloudOps: Dynamic Secrets Management and AWS Infrastructure Automation with HashiCorp Vault and Terraform

**Project Summary:**
This project involved setting up a secure and automated infrastructure for managing AWS resources and credentials using HashiCorp Vault and Terraform Cloud. The project focused on implementing various Vault authentication methods, dynamic secrets management, and automated infrastructure provisioning, ensuring secure and scalable operations for AWS EC2, RDS, and networking components. Below are the key steps performed:

1. **Created HCP Vault Cluster** using Vault Token as a prerequisite for securing secret storage and management.
2. **Configured Vault IAM Admin** with AWS credentials to enable Vault to manage AWS resources securely.
3. **Implemented Vault JWT Auth Method** for integrating Vault and Terraform, using Vault Tokens to authenticate and manage Terraform Provider credentials.
4. **Configured Vault AWS Secret Dynamic Role** using Terraform Provider credentials to dynamically manage short-lived AWS IAM credentials.
5. **Provisioned AWS VPC, Subnet, IGW, NGW, and Route Tables** using Vault-backed Terraform Provider credentials and AWS dynamic role secrets.
6. **Created VPC Peering** between HashiCorp Virtual Network (HVN) and AWS VPC using Vault-backed Terraform Provider credentials and AWS dynamic role secrets.
7. **Integrated Vault AWS Auth Method** using Vault-Agent for secure authentication of AWS resources.
8. **Established Vault Approle Auth Method** for secure machine-to-machine authentication in a PoC environment using Terraform credentials.
9. **Deployed AWS RDS and EC2 Instances** with Vault-backed Terraform credentials and dynamically managed AWS secret roles for automation and security.
10. **Configured Vault DB Secret Dynamic Role** for MySQL, enabling the dynamic creation of database credentials using Terraform Provider credentials for enhanced security.
11. **Configure Vault Agent in APP EC2 Instance** with Auto-Auth, and Retrieve DB Secrets with Vault Agent Template and Caching
12. **Set up Vault AWS Secret Static Role** as a Proof of Concept (PoC) to test static role-based authentication and credentials management with Terraform.

**Technologies Used:**

- HashiCorp Vault (HCP Vault Cluster, Auth Methods, Secret Management, Vault Agent)
- AWS (IAM, EC2, RDS, VPC, Subnet, VPC Peering)
- Terraform Cloud (Infrastructure as Code)
- MySQL (Database Secrets Management)
- GitHub (Terraform Version Control Workflow)

**Outcome:**
The project successfully demonstrated secure, dynamic secret management and automated infrastructure provisioning using HashiCorp Vault and Terraform. It improved security by implementing short-lived dynamic credentials and automated AWS resource deployment, reducing manual intervention and enhancing system scalability.

