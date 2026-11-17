
# ⚙️ Automated CI/CD Pipeline & Infrastructure as Code — Jenkins + Terraform

![Python](https://img.shields.io/badge/Python-3.10-blue?logo=python)
![Flask](https://img.shields.io/badge/Flask-3.0.0-black?logo=flask)
![Pytest](https://img.shields.io/badge/Pytest-7.4.3-0A9EDC?logo=pytest)
![Jenkins](https://img.shields.io/badge/Jenkins-2.580.2-D24939?logo=jenkins)
![Terraform](https://img.shields.io/badge/Terraform-%3E%3D1.0.0-7B42BC?logo=terraform)
![AWS Provider](https://img.shields.io/badge/AWS%20Provider-~%3E5.0-FF9900?logo=amazonaws)

> **Course:** Cloud Native DevOps — Activity 2  
> **Student:** Yash Dhananjay Dalavi | **PRN:** `202301100017` | **Roll No:** `CCF54`  
> **Branch:** B.Tech Computer Engineering (Software Engineering), MIT Academy of Engineering, Pune  
> **Video Demonstration:** [Watch Walkthrough on Google Drive](https://drive.google.com/file/d/1HCISbMJTyYQORGIWkIRLO_3TqtnzvKKYJ/view?usp=sharing)

---

## 📌 Project Overview

This repository implements an end-to-end **Continuous Integration and Continuous Deployment (CI/CD)** pipeline integrated with **Infrastructure as Code (IaC)** using **Jenkins** and **Terraform**.

### Key Features

- **Automated SCM Polling (`Poll SCM`):** Jenkins automatically polls the `main` branch of this GitHub repository every 2 minutes (`H/2 * * * *`) to detect new commits and trigger pipeline execution.
- **Isolated Build & Automated Quality Gate:** Provisions a clean Python virtual environment (`venv`), installs dependencies, runs automated unit tests via `pytest`, and publishes JUnit XML test reports (`test-reports/results.xml`) directly in the Jenkins dashboard.
- **Modular Terraform IaC & Plan Archiving:** Initializes the HashiCorp AWS provider (`~> 5.0`), validates HCL syntax (`terraform validate`), generates a deterministic execution plan (`tfplan.txt`), and archives it as a Jenkins build artifact.
- **Offline CI Validation Mode (`offline_mode=true`):** Bypasses live AWS STS credential checks inside the CI container while fully validating provider schemas, resource graphs, and security group ingress/egress rules before safely gating `terraform apply`.

---

## 🏗️ CI/CD & IaC Pipeline Architecture

```text
[ Developer Commit (GitHub: main) ]
                 |
                 v
          (Poll SCM: H/2 * * * *)
                 |
                 v
┌──────────────────────────────────────────────────────────────────────┐
│                     JENKINS DECLARATIVE PIPELINE                     │
│                                                                      │
│  Stage 1: Checkout Source Code ──► git checkout scm (main branch)    │
│                 |                                                    │
│                 v                                                    │
│  Stage 2: Build & Unit Test    ──► python3 -m venv venv              │
│                 |                  pytest --junitxml=results.xml     │
│                 v                                                    │
│  Stage 3: Terraform Validate   ──► terraform init -input=false       │
│                 |                  terraform validate                │
│                 v                                                    │
│  Stage 4: Terraform Plan       ──► terraform plan -out=tfplan        │
│                 |                  archiveArtifacts 'tfplan.txt'     │
│                 v                                                    │
│  Stage 5: Readiness Check      ──► Verify plan & gate live apply     │
│                                                                      │
└──────────────────────────────────────────────────────────────────────┘
```

---

## 📂 Repository Structure

| File | Purpose |
|---|---|
| `app.py` | Lightweight Python Flask REST microservice exposing `GET /` with JSON deployment metadata. |
| `test_app.py` | Automated pytest unit test suite validating HTTP 200 OK status and JSON payload content. |
| `requirements.txt` | Pinned Python dependencies (`flask==3.0.0`, `pytest==7.4.3`). |
| `Jenkinsfile` | 5-stage Declarative Jenkins Pipeline with `pollSCM`, JUnit test reporting, and artifact archiving. |
| `main.tf` | Terraform AWS provider setup (with offline_mode support), `aws_security_group`, and `aws_instance`. |
| `variables.tf` | Input variable definitions for `aws_region`, `instance_type`, `ami_id`, and `offline_mode`. |
| `outputs.tf` | Output definitions exporting `instance_id` and `instance_public_ip`. |
| `.terraform.lock.hcl` | Dependency lock file ensuring deterministic HashiCorp AWS provider (`v5.100.0`) builds. |
| `.gitignore` | Excludes `.terraform/` provider binaries, `terraform.tfstate*`, `tfplan`, and `venv/` from Git. |

---

## 🔌 Microservice & Cloud Infrastructure Specs

### 1. Flask Microservice Endpoint (`app.py`)

- **Endpoint:** `GET /`
- **Port:** `5000`
- **Response:** HTTP 200 OK

```json
{
  "message": "Jenkins CI/CD Pipeline with Terraform Automation",
  "status": "Success",
  "environment": "Production"
}
```

### 2. Provisioned AWS Resources (`main.tf`)

**Security Group (`aws_security_group.web_sg` — `jenkins-tf-web-sg`):**

| Type | Protocol | Port | Source / Destination | Purpose |
|---|---|---|---|---|
| Ingress | TCP | 80 | `0.0.0.0/0` | Standard HTTP traffic |
| Ingress | TCP | 5000 | `0.0.0.0/0` | Flask microservice traffic |
| Egress | All | All | `0.0.0.0/0` | Outbound package updates |

**Compute Instance (`aws_instance.web_server` — `Jenkins-Terraform-WebServer`):**

| Property | Configuration |
|---|---|
| Instance Type | `t2.micro` |
| AMI ID | `ami-0c7217cdde317cfec` |
| Operating System | Ubuntu Server |
| AWS Region | `us-east-1` |

---

## 🚀 Local Execution & Verification Guide

### 1. Run Application & Unit Tests Locally

```bash
# Create and activate virtual environment
python -m venv venv

# Windows
venv\Scripts\activate

# Linux/macOS
source venv/bin/activate

# Install dependencies
pip install -r requirements.txt

# Run automated unit tests
pytest test_app.py -v
```

### 2. Validate & Plan Terraform Locally (Offline Mode)

```bash
# Initialize Terraform and download HashiCorp AWS provider
terraform init

# Validate HCL syntax and configuration consistency
terraform validate

# Generate execution plan without live AWS credentials
terraform plan -var="offline_mode=true"
```

### 3. Jenkins Pipeline Configuration

1. Create a Pipeline job (`jenkins-terraform-cicd-v1`) on Jenkins (`http://localhost:8080`).
2. Under **Build Triggers**, enable **Poll SCM** with schedule:

   ```text
   H/2 * * * *
   ```

3. Under **Pipeline**, select **Pipeline script from SCM**.
4. Select **Git** as the SCM.
5. Enter the repository URL:

   ```text
   https://github.com/yash-D-Dalavi/jenkins-terraform-cicd-v1
   ```

6. Set the branch specifier to:

   ```text
   */main
   ```

7. Set the script path to:

   ```text
   Jenkinsfile
   ```

8. Trigger a build or push a commit to `main` to verify all 5 stages, JUnit test results (1/1 passed), and the archived `tfplan.txt` artifact.

**Expected Terraform Plan Output:**

```text
Plan: 2 to add, 0 to change, 0 to destroy.
```

---

## 🛠️ Challenges & Engineering Solutions

### 1. Offline AWS Plan Validation in CI

Running `terraform plan` inside a local Dockerized Jenkins container failed without active AWS IAM keys.

**Solution:** Added a parameterized `offline_mode` variable in `variables.tf`, linked to the following provider settings in `main.tf`:

- `skip_credentials_validation`
- `skip_requesting_account_id`
- `skip_metadata_api_check`

Configured through `TF_VAR_offline_mode='true'` in `Jenkinsfile`.

This allows offline configuration validation and planning without live AWS credential checks.

### 2. Large Provider Binary Exclusion

Prevented GitHub's 100 MB file-size rejection by ignoring `.terraform/` provider binaries in `.gitignore` while committing `.terraform.lock.hcl` for reproducible `terraform init` runs.

### 3. Clean Rebase Syncing

Resolved non-fast-forward Git push conflicts by committing local pipeline updates before running:

```bash
git pull origin main --rebase
```

---

## ✅ Conclusion

This project demonstrates the practical implementation of an automated DevOps workflow by integrating Jenkins CI/CD with Terraform Infrastructure as Code.

It covers automated source code polling, isolated Python builds, unit testing, JUnit reporting, Terraform initialization and validation, execution plan generation, artifact archiving, and AWS infrastructure configuration.

The implementation provides a foundation for building reliable, repeatable, and automated cloud infrastructure deployment workflows.

---
