pipeline {
    agent any
    tools {
        maven 'maven3'
    }
    environment{
        WAR_FILE = "/var/lib/jenkins/workspace/ci-cd/target/myweb-0.0.7-SNAPSHOT.war"
        DOCKER_SERVER = "13.127.65.143"
        REGION = "ap-south-1"
        AWS_ACCOUNT_ID = "924308295341"
        ECR_REPO_NAME = "javawebapp"
        ACCESS_KEY = credentials('AWS_ACCESS_KEY_ID')
        SECRET_KEY = credentials('AWS_SECRET_KEY_ID')
        EKS_CLUSTER = "demo-cluster1"

    }
    stages {
        stage('checkout'){
            steps{
                script{
                    git branch: 'ci-cd-ecr', url: 'https://github.com/muddassir19/jenkins_shared_lib.git'
                }
            }
        }
        // stage('unit test maven'){
        //     steps{
        //         script{
        //             sh 'mvn test'
        //         }
        //     }
        // }
        // stage('Integration test'){
        //     steps{
        //         script{
        //             sh 'mvn verify -DskipUnitTests'
        //         }
        //     }
        // }
        // // stage('Static code Analysis: Sonarqube'){
        // //     steps{
        // //         script{
        // //             withSonarQubeEnv(credentialsId: 'sonarqube') {
        // //                 sh 'mvn sonar:sonar'
        // //             }
        // //         }
        // //     }
        // // }
        // // stage('Quality Gate Status Check: Sonarqube'){
        // //     steps{
        // //         script{
        // //             timeout(time: 1, unit: 'HOURS') {
        // //             waitForQualityGate abortPipeline: false, credentialsId: 'sonarqube'
        // //             }
        // //         }
        // //     }
        // // }
        // stage('Maven Build: maven'){
        //     steps{
        //         script{
        //             sh 'mvn clean install'
        //         }
        //     }
        // }
        // stage('copy file to docker-sever: sshagent'){
        //     steps{
        //         script{
        //             sshagent(['docker-server']) {
        //                sh 'ssh -o StrictHostKeyChecking=no ec2-user@${DOCKER_SERVER}'
        //                sh 'scp ${WAR_FILE} ec2-user@${DOCKER_SERVER}:/home/ec2-user'
        //                sh 'scp Dockerfile  ec2-user@${DOCKER_SERVER}:/home/ec2-user'
        //                sh 'ssh -o StrictHostKeyChecking=no ec2-user@${DOCKER_SERVER} chmod -R 777 /home/ec2-user/Dockerfile'
                       

        //             }
        //         }
        //     }
        // }
        // stage('Docker Image Build: ECR'){
        //     steps{
        //         script{
        //             try{
        //                 sshagent(['docker-server']) {
        //                      // Use SSH to execute Docker build commands on docker-host
        //                     sh "ssh -o StrictHostKeyChecking=no ec2-user@${DOCKER_SERVER} 'cd /home/ec2-user && docker build -t ${ECR_REPO_NAME} .'"
        //                     sh "ssh -o StrictHostKeyChecking=no ec2-user@${DOCKER_SERVER} 'cd /home/ec2-user && docker tag ${ECR_REPO_NAME}:latest ${AWS_ACCOUNT_ID}.dkr.ecr.${REGION}.amazonaws.com/${ECR_REPO_NAME}:latest'"
        //                 }
        //             } catch (Exception buildError) {
        //                 // Catch any exception that occurs during the Docker build
        //                 echo "Error during Docker build: ${buildError.message}"
        //                 currentBuild.result = 'FAILURE'
        //             }
        //         }
        //     }
        // }
        // stage('Docker image scan:Trivy'){
        //     steps{
        //         script{
        //             sshagent(['docker-server']) {
        //             sh "ssh -o StrictHostKeyChecking=no ec2-user@${DOCKER_SERVER} 'trivy image  ${AWS_ACCOUNT_ID}.dkr.ecr.${REGION}.amazonaws.com/${ECR_REPO_NAME}:latest > scanecr.txt'"
        //             sh "ssh -o StrictHostKeyChecking=no ec2-user@${DOCKER_SERVER} 'cat scanecr.txt'"
        //             }
        //         }
        //     }
        // }
       
        // stage('Docker Image push: ECR-REG'){
        //     steps{
        //         script{ 
        //             sshagent(['docker-server']) {
        //                 sh """ssh -o StrictHostKeyChecking=no ec2-user@${DOCKER_SERVER} "aws ecr get-login-password --region ${REGION} | docker login --username AWS --password-stdin ${AWS_ACCOUNT_ID}.dkr.ecr.${REGION}.amazonaws.com" """
        //                 sh "ssh -o StrictHostKeyChecking=no ec2-user@${DOCKER_SERVER} 'docker push ${AWS_ACCOUNT_ID}.dkr.ecr.${REGION}.amazonaws.com/${ECR_REPO_NAME}:latest'"

        //                 // Try to remove the previous Docker images
        //                 try{
        //                     sh "ssh -o StrictHostKeyChecking=no ec2-user@${DOCKER_SERVER} 'docker rmi ${ECR_REPO_NAME}:latest ${AWS_ACCOUNT_ID}.dkr.ecr.${REGION}.amazonaws.com/${ECR_REPO_NAME}:latest || true'"
        //                 } catch (Exception removeError) {
        //                     echo "Error removing previous Docker images: ${removeError.message}"
        //                 }
        //             }                    
        //         }
        //     }
        // }
        stage('Create Eks cluster: Terraform'){
            steps{
                script{
                    dir('eks_module') {
                        sh "terraform init"
                        sh  "terraform fmt"
                        sh  "terraform plan -var 'access_key=$ACCESS_KEY' -var 'secret_key=$SECRET_KEY' -var 'region=$REGION' --var-file=./config/terraform.tfvars"
                        sh  "terraform apply -var 'access_key=$ACCESS_KEY' -var 'secret_key=$SECRET_KEY' -var 'region=$REGION' --var-file=./config/terraform.tfvars --auto-approve"
                        
                    }   
                }
            }
        }
        stage('Destroy EKS cluster'){
            steps{
                script{
                    dir('eks_module'){
                        sh "terraform destroy --auto-approve"
                    }
                }
            }
        }
        // stage('Connect to Eks:EKS'){
        //     steps{
        //         script{
        //             sh "aws configure set aws_access_key_id $ACCESS_KEY"
        //             sh "aws configure set aws_secret_access_key $SECRET_KEY"
        //             sh "aws configure set region $REGION"
        //             sh "aws eks --region $REGION update-kubeconfig --name $EKS_CLUSTER"
        //         }
        //     }
        // }
        // stage('Deployment on EKS cluster:K8S'){
        //     steps{
        //         script{
        //             def apply = false

        //             try{
        //                 input message: 'please confirm to deploy on eks', ok: 'Ready to apply the config ?'
        //                 apply = true
        //             } catch(err){
        //                 apply = false
        //                 currentBuild.result = 'UNSTABLE'
        //             }
        //             if(apply){
        //                 sh "kubectl apply -f ."
        //             }
        //         }
        //     }
        // }
    }
}