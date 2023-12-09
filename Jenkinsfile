pipeline {
    agent any
    tools {
        maven 'maven3'
    }
    environment{
        DOCKER_SERVER = "3.110.147.61"
        DOCKER_REPO = "muddassir19"
        DOCKER_IMAGE = "webapp"
        DOCKER_TAG = "v1"

    }
    stages {
        stage('checkout'){
            steps{
                script{
                    git branch: 'ci-cd-project', url: 'https://github.com/muddassir19/jenkins_shared_lib.git'
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
                       sh 'scp /var/lib/jenkins/workspace/ci-cd/target/*.war  ec2-user@${DOCKER_SERVER}:/home/ec2-user'
                       sh 'scp Dockerfile  ec2-user@${DOCKER_SERVER}:/home/ec2-user'
                       sh 'chmod -R 777 Dockerfile'
                       

                    }
                }
            }
        }
        stage('Docker build:Docker'){
            steps{
                script{
                    sshagent(['docker-server']) {
                    sh 'ssh -o StrictHostKeyChecking=no ec2-user@${DOCKER_SERVER}'
                    sh 'docker build -t ${DOCKER_REPO}/${DOCKER_IMAGE}:${DOCKER_TAG} .'
                    sh 'docker image tag  ${DOCKER_REPO}/${DOCKER_IMAGE}  ${DOCKER_REPO}/${DOCKER_IMAGE}:${DOCKER_TAG}'
                    sh 'docker image tag  ${DOCKER_REPO}/${DOCKER_IMAGE}  ${DOCKER_REPO}/${DOCKER_IMAGE}:latest '
                    

                    }
                }
            }
        }
    }
}