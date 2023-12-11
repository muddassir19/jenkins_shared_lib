pipeline {
    agent any
    tools {
        maven 'maven3'
    }
    environment{
        WAR_FILE = "/var/lib/jenkins/workspace/ci-cd/target/myweb-0.0.7-SNAPSHOT.war"
        DOCKER_SERVER = "3.108.228.66"
        DOCKER_REPO = "muddassir19"
        DOCKER_IMAGE = "webapp"
        DOCKER_TAG = "v1"
        DOCKER_HUB_USER = "muddassir19"
        DOCKER_HUB_PASSWD_CRED = 'docker-hub-passwd'

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
                       sh 'scp ${WAR_FILE} ec2-user@${DOCKER_SERVER}:/home/ec2-user'
                       sh 'scp Dockerfile  ec2-user@${DOCKER_SERVER}:/home/ec2-user'
                       sh 'ssh -o StrictHostKeyChecking=no ec2-user@${DOCKER_SERVER} chmod -R 777 /home/ec2-user/Dockerfile'
                       

                    }
                }
            }
        }
        stage('Docker build:Docker'){
            steps{
                script{
                    sshagent(['docker-server']) {
                    
                    sh "ssh -o StrictHostKeyChecking=no ec2-user@${DOCKER_SERVER} 'cd /home/ec2-user && docker build -t ${DOCKER_REPO}/${DOCKER_IMAGE}:${DOCKER_TAG} .'"
                    sh "ssh -o StrictHostKeyChecking=no ec2-user@${DOCKER_SERVER} 'cd /home/ec2-user && docker tag  ${DOCKER_REPO}/${DOCKER_IMAGE}:${DOCKER_TAG}  ${DOCKER_REPO}/${DOCKER_IMAGE}:latest'"
                                     

                      }
                }
            }
        }
        stage('Docker image scan:Trivy'){
            steps{
                script{
                    sshagent(['docker-server']) {
                    
                    sh "ssh -o StrictHostKeyChecking=no ec2-user@${DOCKER_SERVER} 'trivy image   ${DOCKER_REPO}/${DOCKER_IMAGE}:latest > scan.txt'"
                                     

                    }
                }
            }
        }
        stage('Docker Image push:Docker-hub'){
            steps{
                script{
                    // withCredentials([usernameColonPassword(credentialsId: 'docker-hub-cred', variable: 'docker-hub')]) {
                    //     sh "docker login -u ${DOCKER_HUB_USER} -p ${docker-hub}"
                    // }
                    // sh 'docker push ${DOCKER_REPO}/${DOCKER_IMAGE}:${DOCKER_TAG}'
                    // sh 'docker push ${DOCKER_REPO}/${DOCKER_IMAGE}:latest'
                    // Use SSH to execute Docker commands on Docker-host
                    sshagent(['docker-server', DOCKER_HUB_PASSWD_CRED]) {
                        sh "ssh -o StrictHostKeyChecking=no ec2-user@${DOCKER_SERVER} \"docker login -u ${DOCKER_HUB_USER} -p \${DOCKER_HUB_PASSWD_CRED}""
                        sh "ssh -o StrictHostKeyChecking=no ec2-user@${DOCKER_SERVER} 'docker push ${DOCKER_REPO}/${DOCKER_IMAGE}:${DOCKER_TAG}'"
                        sh "ssh -o StrictHostKeyChecking=no ec2-user@${DOCKER_SERVER} 'docker push ${DOCKER_REPO}/${DOCKER_IMAGE}:latest'"
                    }                
                }
            }
        }
    }
}
