pipeline {
    agent {
        label 'my-laptop'  // Make sure this matches the label assigned to your Jenkins node
    }
    environment {
        // Update environment variables with your AWS credentials
        AWS_ACCESS_KEY_ID = 'c8f19f80-4420-44f1-bf6c-0bb6038ac477'
        AWS_SECRET_ACCESS_KEY = '50366b85-078e-4b4e-a9b1-8b31a116e884'
        AWS_SESSION_TOKEN = '52876e70-6684-47f4-b834-9657d1dfce58'
        TERRAFORM_VERSION = '1.3.7'  // Specify the Terraform version if needed
    }
    stages {
        stage('Checkout Code') {
            steps {
                // Checkout code from the repository
                git url: 'https://github.com/RajaStriker/terra-dev-prod.git', branch: 'main', credentialsId: 'github-credentials-id'
            }
        }
        stage('Build Angular App') {
            steps {
                script {
                    // Change directory to Angular app
                    dir('angular-app') {
                        // Install dependencies
                        sh 'npm install'
                        // Build the Angular application
                        sh 'ng build --prod'
                    }
                }
            }
        }
        stage('Terraform Plan and Apply') {
            steps {
                script {
                    // Initialize Terraform for dev environment
                    dir('terraform/dev') {
                        sh 'terraform init'
                        sh 'terraform plan'
                        // Manual approval for dev environment
                        input message: 'Approve changes for DEV environment?', ok: 'Apply'
                        sh 'terraform apply -auto-approve'
                    }
                }
            }
        }
        stage('Terraform Plan and Apply Prod') {
            when {
                branch 'main'
            }
            steps {
                script {
                    // Initialize Terraform for prod environment
                    dir('terraform/prod') {
                        sh 'terraform init'
                        sh 'terraform plan'
                        sh 'terraform apply -auto-approve'
                    }
                }
            }
        }
        stage('Upload Angular App to S3') {
            steps {
                script {
                    // Upload the Angular build to S3 bucket
                    sh 'aws s3 sync angular-app/dist/ s3://striker-dev --delete'
                }
            }
        }
    }
    post {
        success {
            echo 'Build and deployment completed successfully.'
        }
        failure {
            echo 'Build or deployment failed.'
        }
    }
}

