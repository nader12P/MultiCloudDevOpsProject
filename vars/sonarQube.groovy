def call(SONAR_HOST, SONAR_PROJECT) {
    def SONAR_SCANNER_HOME = tool "SONARQUBE_TOOL_INSTALLATION_NAME"
    
    withCredentials([string(credentialsId: 'SONARQUBE_CREDENTIAL_ID', variable: 'SONAR_TOKEN')]) {
        sh "${SONAR_SCANNER_HOME}/bin/sonar-scanner -X -Dsonar.projectKey=${SONAR_PROJECT} -Dsonar.host.url=${SONAR_HOST} -Dsonar.login=${SONAR_TOKEN} -Dsonar.scm.provider=git  -Dsonar.java.binaries=build/classes" 
    }
    sh 'rm -rf build'
}
