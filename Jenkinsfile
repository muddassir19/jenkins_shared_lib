@Library('my-shared-library') _
pipeline{
    agent any
    tools {
        maven 'Maven 3.9.5'
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
                    mvnTest()
                }                
            }
        }
    }
}