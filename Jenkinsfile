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
    }
}