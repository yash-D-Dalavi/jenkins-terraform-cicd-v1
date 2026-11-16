pipeline {
    agent any
    options {
        timestamps()
    }
    triggers {
        pollSCM('H/2 * * * *')
    }
    environment {
        AWS_REGION          = 'us-east-1'
        TF_VAR_offline_mode = 'true'
    }
    stages {
        stage('Checkout Source Code') {
            steps {
                echo 'Retrieving source code from GitHub Repository...'
                checkout scm
            }
        }
        stage('Install Dependencies & Unit Test') {
            steps {
                echo 'Running automated unit tests with pytest...'
                sh '''
                    python3 -m venv venv
                    . venv/bin/activate
                    pip install --upgrade pip
                    pip install -r requirements.txt
                    pytest test_app.py --junitxml=test-reports/results.xml
                '''
            }
            post {
                always {
                    junit 'test-reports/results.xml'
                }
            }
        }
        stage('Terraform Init & Validate') {
            steps {
                echo 'Initializing and validating Terraform configuration...'
                sh '''
                    terraform init -input=false
                    terraform validate
                '''
            }
        }
        stage('Terraform Plan') {
            steps {
                echo 'Generating Terraform execution plan...'
                sh '''
                    terraform plan -input=false -out=tfplan
                    terraform show -no-color tfplan > tfplan.txt
                '''
                archiveArtifacts artifacts: 'tfplan.txt'
            }
        }
        stage('Provisioning Readiness Check') {
            steps {
                echo 'Plan validated. terraform apply skipped: AWS credentials unavailable in CI environment.'
            }
        }
    }
    post {
        success {
            echo 'CI/CD Pipeline and Terraform Validation Succeeded!'
        }
        failure {
            echo 'Pipeline failed during execution.'
        }
    }
}