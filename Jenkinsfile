pipeline {
    agent any

    environment {
        AWS_REGION = 'us-east-1'
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
        }

        stage('Terraform Init & Validate') {
            steps {
                echo 'Initializing and validating Terraform configuration...'
                sh '''
                    terraform init
                    terraform validate
                '''
            }
        }

        stage('Terraform Plan') {
            steps {
                echo 'Generating Terraform execution plan...'
                sh '''
                    terraform plan -out=tfplan
                '''
            }
        }

        stage('Terraform Provisioning (Conditional)') {
            steps {
                echo 'Dry-run successful. Infrastructure readiness validated.'
            }
        }
    }

    post {
        always {
            echo 'Pipeline execution completed.'
        }
        success {
            echo 'CI/CD Pipeline and Terraform Validation Succeeded!'
        }
        failure {
            echo 'Pipeline failed during execution.'
        }
    }
}