@Library ('my-shared-library')_
pipeline{
    agent any
    tools {
        maven 'maven3'
    }
    stages{
        stage("checkout"){
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
            steps{
                script {
                    sh 'mvn test'
                }                
            }
        }

        stage("Integration test maven") {
            steps{
                script {
                   mvnIntegrationTest() 
                }                
            }
        }
    }
}