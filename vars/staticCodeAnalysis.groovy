def call(credID){
    withSonarQubeEnv(credentialsId: 'credID') {
        sh 'mvn clean package sonar:sonar'
    }
}