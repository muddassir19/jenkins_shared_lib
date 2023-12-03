def call(){
    //sh 'mvn test'
    sh 'mvn -pl "!com.mycom.hp.comp:zonegtools,!com.mycom.hpe:testbed" -P compileWithGradle,nightly,flex-debug clear'
}