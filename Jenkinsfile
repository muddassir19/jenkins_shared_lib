pipeline {
    agent any
    tools {
        maven 'maven3'
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
        stage('Static code Analysis: Sonarqube'){
            steps{
                script{
                    withSonarQubeEnv(credentialsId: 'sonarqube') {
                        sh 'mvn sonar:sonar'
                    }
                }
            }
        }
        stage('Quality Gate Status Check: Sonarqube'){
            steps{
                script{
                    timeout(time: 1, unit: 'HOURS') {
                    waitForQualityGate abortPipeline: false, credentialsId: 'sonarqube'
                    }
                }
            }
        }
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
                       sh 'ssh -o StrictHostKeyChecking=no ec2-user@3.110.32.119'
                       sh 'scp /var/lib/jenkins/workspace/ci-cd/target/*.war  ec2-user@3.110.32.119:/home/ec2-user'

                    }
                }
            }
        }
    }
}