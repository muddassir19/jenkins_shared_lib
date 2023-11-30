@Library('my-shared-library') _
pipeline{
    agent any

    stages{
        stage("checkout"){
            steps{
                script {
                    gitCheckout(
                    branch: 'shared_lib'
                    url: 'https://github.com/muddassir19/jenkins_shared_lib.git'
                )
                }
                //git branch: 'shared_lib', url: 'https://github.com/muddassir19/jenkins_shared_lib.git'
            }
        }
    }
}