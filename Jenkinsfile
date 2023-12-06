@Library('my-shared-library') _
pipeline{
    agent any
    tools {
        maven 'maven3'
    }
    parameters{
        choice(name: 'action', choices: 'create/ndelete', description: 'choose to create/Destroy')
    }
    // how to stages condition, done by choice and when condition in every stage
    stages{
        
        stage("checkout"){
            //when { expression { params.action == 'create' } }
            steps{
                script {
                    gitCheckout(
                    branch: 'shared_lib',
                    url: 'https://github.com/muddassir19/jenkins_shared_lib.git'
                )
                }
                //git branch: 'shared_lib', url: 'https://github.com/muddassir19/jenkins_shared_lib.git'
            }
        }

        
        stage("unit test maven") {
            //when { expression { params.action == 'create' } }
            steps{
                script {
                    sh 'mvn test'
                }                
            }
        }

        stage("Integration test maven") {
            //when { expression { params.action == 'create' } }
            steps{
                script {
                   sh 'mvn verify -DskipUnitTests'
                }                
            }
        }

        
        stage("maven Build") {
            //when { expression { params.action == 'create' } }
            steps{
                script {
                   sh 'mvn clean package'
                }                
            }
        }
        
        stage("Static Code Analysis: sonarqube ") {
            //when { expression { params.action == 'create' } }
            steps{
                script{
                    //def SonarQubecredentialsID = 'sonarqube-api'
                    withCredentials([string(credentialsId: 'sonarqube', variable: 'sonarcred')]) {
                        sh 'mvn clean package sonar:sonar'
                    }
                    //staticCodeAnalysis(SonarQubecredentialsID)
                }
            }
        }
    }
}