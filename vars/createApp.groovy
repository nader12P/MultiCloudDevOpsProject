def call(COMMIT_ID, DOCKER_IMAGE, DOCKER_REGISTERY) {
    withCredentials([file(credentialsId: 'OPENSHIFT_CREDENTIAL_ID', variable: 'OPENSHIFT_SECRET')]) {
        sh "oc project \${OPENSHIFT_PROJECT} --kubeconfig=$OPENSHIFT_SECRET"
        sh "oc delete dc,svc,deploy,ingress,route ${DOCKER_IMAGE} --kubeconfig=$OPENSHIFT_SECRET|| true"
        sh "oc new-app ${DOCKER_REGISTERY}/${DOCKER_IMAGE}:${COMMIT_ID} --kubeconfig=$OPENSHIFT_SECRET"
        sh "oc expose svc/${DOCKER_IMAGE} --kubeconfig=$OPENSHIFT_SECRET"
    }
}
