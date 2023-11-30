pipeline{
    agent any

    stages{
        stage("checkout"){
            steps{
                git branch: 'shared_lib', url: 'https://github.com/muddassir19/jenkins_shared_lib.git'
            }
        }
    }
}