# Activity 2: Jenkins CI/CD Pipeline with Terraform Infrastructure Provisioning

## 📌 Project Overview

This project demonstrates an end-to-end automated Continuous Integration and Continuous Deployment (CI/CD) pipeline integrated with Infrastructure as Code (IaC).

Using Jenkins and Terraform, the setup automates source code checkout from GitHub, automated unit testing using `pytest`, static HCL syntax validation, and dry-run execution planning for AWS cloud infrastructure provisioning.

---

## 🛠️ Tech Stack & Prerequisites

- **Automation Server:** Jenkins (Declarative Pipeline)
- **Infrastructure as Code (IaC):** Terraform (`>= 1.0.0`, HashiCorp AWS Provider `~> 5.0`)
- **Cloud Provider:** Amazon Web Services (AWS EC2, VPC Security Groups)
- **Application Framework:** Python 3.9 (Flask REST API & Pytest)
- **Version Control:** Git & GitHub

---

## 📁 Repository Structure

```text
jenkins-terraform-cicd-v1/
│
├── app.py              # Flask Application Source Code
├── test_app.py         # Automated Unit Tests (Pytest)
├── requirements.txt    # Python Dependencies List
├── Jenkinsfile         # Declarative CI/CD Pipeline Configuration
├── main.tf             # Terraform AWS Provider & Resource Specifications
├── variables.tf        # Terraform Input Variables Definition
├── outputs.tf          # Terraform Resource Outputs Definition
├── .gitignore          # Git Exclusion Rules (Terraform binaries & caches)
└── README.md           # Project Documentation & Execution Guide
```

---

## 🚀 CI/CD Pipeline & IaC Workflow

### 1. Application & Unit Test Verification

Run local unit tests using pytest:

```bash
python -m venv venv

# Activate virtual environment
# Windows:
venv\Scripts\activate

# Linux/Mac:
source venv/bin/activate

# Install dependencies
pip install -r requirements.txt

# Execute unit tests
pytest test_app.py
```

### 2. Terraform Infrastructure Validation Commands

Initialize the Terraform working directory and download the required HashiCorp AWS providers:

```bash
terraform init
```

Validate HCL syntax and configuration integrity:

```bash
terraform validate
```

Generate an execution plan to preview infrastructure changes:

```bash
terraform plan
```

---

## ⚙️ Declarative Pipeline Stages (Jenkinsfile)

The Jenkinsfile defines the following automated stages:

1. **Checkout Source Code:** Pulls the latest application and infrastructure code from GitHub.

2. **Install Dependencies & Unit Test:** Installs Python dependencies and executes pytest with JUnit XML test reporting.

3. **Terraform Init & Validate:** Initializes the HashiCorp AWS provider and validates Terraform configuration files.

4. **Terraform Plan:** Generates a speculative execution plan (`tfplan`) for AWS EC2 instance and Security Group resources.

5. **Terraform Provisioning (Conditional):** Validates dry-run execution readiness before proceeding with infrastructure deployment.

---

## 🎯 Conclusion

This project demonstrates how Jenkins automates the CI/CD workflow and Terraform manages cloud infrastructure through Infrastructure as Code.

It integrates automated application testing, infrastructure validation, and execution planning to create a structured and reliable DevOps workflow.
