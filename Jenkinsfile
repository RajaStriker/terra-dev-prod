pipeline {
    agent any

    environment {
        AWS_ACCESS_KEY_ID     = credentials('c8f19f80-4420-44f1-bf6c-0bb6038ac477')
        AWS_SECRET_ACCESS_KEY = credentials('50366b85-078e-4b4e-a9b1-8b31a116e884')
        AWS_SESSION_TOKEN     = credentials('52876e70-6684-47f4-b834-9657d1dfce58')
        GIT_CREDENTIALS       = credentials('github-credentials-id')
        PATH                  = "/usr/bin:${env.PATH}"
    }

    parameters {
        choice(name: 'ENV', choices: ['dev', 'prod'], description: 'Choose the environment to deploy')
    }

    stages {
        stage('Checkout') {
            steps {
                git credentialsId: 'github-credentials-id', url: 'https://github.com/RajaStriker/terra-dev-prod.git'
            }
        }

        stage('Angular Build') {
            steps {
                script {
                    dir('angular-app') {  // Change 'angular-app' to your actual Angular project directory
                        // Install dependencies
                        sh 'npm install'

                        // Build Angular project
                        sh 'ng build --prod'
                    }
                }
            }
        }

        stage('Terraform Init') {
            steps {
                script {
                    if (params.ENV == 'dev') {
                        dir('terraform/dev') {
                            sh 'terraform init'
                        }
                    } else if (params.ENV == 'prod') {
                        dir('terraform/prod') {
                            sh 'terraform init'
                        }
                    }
                }
            }
        }

        stage('Manual Approval for Dev') {
            when {
                expression { params.ENV == 'dev' }
            }
            steps {
                script {
                    input message: "Manual approval required to proceed with Terraform Apply in the dev environment. Do you want to continue?", 
                          ok: "Proceed"
                }
            }
        }

        stage('Terraform Apply') {
            steps {
                script {
                    if (params.ENV == 'dev') {
                        dir('terraform/dev') {
                            sh 'terraform apply -auto-approve'
                        }
                    } else if (params.ENV == 'prod') {
                        dir('terraform/prod') {
                            sh 'terraform apply -auto-approve'
                        }
                    }
                }
            }
        }

        stage('Deploy to S3') {
            steps {
                script {
                    // Define the S3 bucket based on the environment
                    def s3Bucket = (params.ENV == 'dev') ? 'your-dev-bucket-name' : 'your-prod-bucket-name'

                    // Sync the Angular build files to the S3 bucket
                    dir('angular-app/dist/your-angular-app') {  // Change 'your-angular-app' to your Angular build folder name
                        sh """
                        aws s3 sync . s3://${s3Bucket} --acl public-read
                        """
                    }
                }
            }
        }

        stage('Configure S3 Website Hosting') {
            steps {
                script {
                    def s3Bucket = (params.ENV == 'dev') ? 'your-dev-bucket-name' : 'your-prod-bucket-name'

                    // Configure S3 for static website hosting using AWS CLI
                    sh """
                    aws s3 website s3://${s3Bucket}/ --index-document index.html --error-document error.html
                    """
                }
            }
        }
    }

    post {
        always {
            cleanWs()
        }
    }
}

