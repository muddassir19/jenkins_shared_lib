pipeline{
    agent any

    stages{
        stage("checkout"){
            steps{
                gitCheckout(
                    branch: "shared_lib"
                    url: "https://github.com/muddassir19/jenkins_shared_lib.git"
                )
                //git branch: 'shared_lib', url: 'https://github.com/muddassir19/jenkins_shared_lib.git'
            }
        }
    }
}