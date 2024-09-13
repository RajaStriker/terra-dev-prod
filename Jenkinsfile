pipeline {
    agent any

    environment {
        // Using Jenkins credentials for AWS and GitHub
        AWS_ACCESS_KEY_ID     = credentials('aws-access-key-id')
        AWS_SECRET_ACCESS_KEY = credentials('aws-secret-access-key')
        GIT_CREDENTIALS       = credentials('github-credentials-id')
    }

    stages {
        stage('Checkout') {
            steps {
                // Cloning the repo with credentials
                git credentialsId: 'github-credentials-id', url: 'https://github.com/RajaStriker/terra-dev-prod.git'
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

        stage('Terraform Plan') {
            steps {
                script {
                    if (params.ENV == 'dev') {
                        dir('terraform/dev') {
                            sh 'terraform plan'
                        }
                    } else if (params.ENV == 'prod') {
                        dir('terraform/prod') {
                            sh 'terraform plan'
                        }
                    }
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
    }

    triggers {
        // Trigger the pipeline when a change is pushed to the Git repository
        pollSCM('H/5 * * * *') // Polling every 5 minutes for changes
    }

    parameters {
        // The user can select the environment (dev or prod)
        choice(name: 'ENV', choices: ['dev', 'prod'], description: 'Choose the environment to deploy')
    }

    post {
        always {
            // Clean up workspace after build
            cleanWs()
        }
    }
}

