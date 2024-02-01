def call() {}

def getCommitID() {
    return sh(script: 'git rev-parse --short HEAD', returnStdout: true).trim()
}

def buildDockerImage(DOCKER_IMAGE, DOCKER_REGISTERY) {
    script {
        def COMMIT_ID = getCommitID()
        sh "docker build -t ${DOCKER_REGISTERY}/${DOCKER_IMAGE}:${COMMIT_ID} ."
        return COMMIT_ID
    }
}

def pushDockerImage(DOCKER_IMAGE, DOCKER_REGISTERY) {
    def COMMIT_ID = getCommitID()
    withCredentials([usernamePassword(credentialsId: 'dockerhub', usernameVariable: 'DOCKER_REGISTRY_USERNAME', passwordVariable: 'DOCKER_REGISTRY_PASSWORD')]) {
        sh "echo \${DOCKER_REGISTRY_PASSWORD} | docker login -u \${DOCKER_REGISTRY_USERNAME} --password-stdin"
        sh "docker push ${DOCKER_REGISTERY}/${DOCKER_IMAGE}:${COMMIT_ID}"
        sh "docker rmi ${DOCKER_REGISTERY}/${DOCKER_IMAGE}:${COMMIT_ID}"
    }
    return COMMIT_ID
}
