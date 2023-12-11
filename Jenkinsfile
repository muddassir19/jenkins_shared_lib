pipeline {
    agent any
    tools {
        maven 'maven3'
    }
    environment{
        WAR_FILE = "/var/lib/jenkins/workspace/ci-cd/target/myweb-0.0.7-SNAPSHOT.war"
        DOCKER_SERVER = "3.108.228.66"
        REGION = "ap-south-1"
        AWS_ACCOUNT_ID = "924308295341"
        ECR_REPO_NAME = "javawebapp"
        

    }
    stages {
        stage('checkout'){
            steps{
                script{
                    git branch: 'ci-cd-ecr', url: 'https://github.com/muddassir19/jenkins_shared_lib.git'
                }
            }
        }
        stage('unit test maven'){
            steps{
                script{
                    sh 'mvn test'
                }
            }
        }
        stage('Integration test'){
            steps{
                script{
                    sh 'mvn verify -DskipUnitTests'
                }
            }
        }
        // stage('Static code Analysis: Sonarqube'){
        //     steps{
        //         script{
        //             withSonarQubeEnv(credentialsId: 'sonarqube') {
        //                 sh 'mvn sonar:sonar'
        //             }
        //         }
        //     }
        // }
        // stage('Quality Gate Status Check: Sonarqube'){
        //     steps{
        //         script{
        //             timeout(time: 1, unit: 'HOURS') {
        //             waitForQualityGate abortPipeline: false, credentialsId: 'sonarqube'
        //             }
        //         }
        //     }
        // }
        stage('Maven Build: maven'){
            steps{
                script{
                    sh 'mvn clean install'
                }
            }
        }
        stage('copy file to docker-sever: sshagent'){
            steps{
                script{
                    sshagent(['docker-server']) {
                       sh 'ssh -o StrictHostKeyChecking=no ec2-user@${DOCKER_SERVER}'
                       sh 'scp ${WAR_FILE} ec2-user@${DOCKER_SERVER}:/home/ec2-user'
                       sh 'scp Dockerfile  ec2-user@${DOCKER_SERVER}:/home/ec2-user'
                       sh 'ssh -o StrictHostKeyChecking=no ec2-user@${DOCKER_SERVER} chmod -R 777 /home/ec2-user/Dockerfile'
                       

                    }
                }
            }
        }
        stage('Docker Image Build: ECR'){
            steps{
                script{
                    try{
                        sshagent(['docker-server']) {
                             // Use SSH to execute Docker build commands on docker-host
                            sh "ssh -o StrictHostKeyChecking=no ec2-user@${DOCKER_SERVER} 'cd /home/ec2-user && docker build -t ${ECR_REPO_NAME} .'"
                            sh "ssh -o StrictHostKeyChecking=no ec2-user@${DOCKER_SERVER} 'cd /home/ec2-user && docker tag ${ECR_REPO_NAME}:latest ${AWS_ACCOUNT_ID}.dkr.ecr.${REGION}.amazonaws.com/${ECR_REPO_NAME}:latest'"
                        }
                    } catch (Exception buildError) {
                        // Catch any exception that occurs during the Docker build
                        echo "Error during Docker build: ${buildError.message}"
                        currentBuild.result = 'FAILURE'
                    }
                }
            }
        }
        stage('Docker image scan:Trivy'){
            steps{
                script{
                    sshagent(['docker-server']) {
                    sh "ssh -o StrictHostKeyChecking=no ec2-user@${DOCKER_SERVER} 'trivy image  ${AWS_ACCOUNT_ID}.dkr.ecr.${REGION}.amazonaws.com/${ECR_REPO_NAME}:latest > scanecr.txt'"
                    sh "ssh -o StrictHostKeyChecking=no ec2-user@${DOCKER_SERVER} 'cat scanecr.txt'"
                    }
                }
            }
        }
       
        stage('Docker Image push: ECR-REG'){
            steps{
                script{ 
                    sshagent(['docker-server']) {
                        sh """ssh -o StrictHostKeyChecking=no ec2-user@${DOCKER_SERVER} "aws ecr get-login-password --region ${REGION} | docker login --username AWS --password-stdin ${AWS_ACCOUNT_ID}.dkr.ecr.${REGION}.amazonaws.com" """
                        sh "ssh -o StrictHostKeyChecking=no ec2-user@${DOCKER_SERVER} 'docker push ${AWS_ACCOUNT_ID}.dkr.ecr.${REGION}.amazonaws.com/${ECR_REPO_NAME}:latest'"

                        // Try to remove the previous Docker images
                        try{
                            sh "ssh -o StrictHostKeyChecking=no ec2-user@${DOCKER_SERVER} 'docker rmi ${ECR_REPO_NAME}:latest ${AWS_ACCOUNT_ID}.dkr.ecr.${REGION}.amazonaws.com/${ECR_REPO_NAME}:latest || true'"
                        } catch (Exception removeError) {
                            echo "Error removing previous Docker images: ${removeError.message}"
                        }
                    }                    
                }
            }
        }
    }
}