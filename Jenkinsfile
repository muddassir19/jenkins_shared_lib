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
        when { expression { param.action == 'create' } }
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

        when { expression { param.action == 'create' } }
        stage("unit test maven") {
            steps{
                script {
                    sh 'mvn test'
                }                
            }
        }

        when { expression { param.action == 'create' } }
        stage("Integration test maven") {
            steps{
                script {
                   sh 'mvn verify -DskipUnitTests'
                }                
            }
        }

        when { expression { param.action == 'create' } }
        stage("maven Build") {
            steps{
                script {
                   sh 'mvn clean package'
                }                
            }
        }
        when { expression { param.action == 'create' } }
        stage("copy file ") {
            steps{
                script{
                    
                }
            }
        }
    }
}