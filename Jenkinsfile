@Library('jenkins_lib@main') _

def SONAR_PROJECT = 'SONARQUBE_PROJECT_NAME'
def SONAR_HOST = 'SONAR_HOST_URL'

def DOCKER_IMAGE = 'IMAGE_NAME'
def DOCKER_REGISTERY = 'DOCKERHUB_REGISTERY_NAME'


pipeline {
    agent any

    environment {
        OPENSHIFT_SERVER = 'OPENSHIFT_SERVER_URL'
        OPENSHIFT_PROJECT = 'OPENSHIFT_PROJECT_NAME'
    }

    stages {
        stage('Local Build') {
            steps {
                script {
                    localBuild()
                }
            }
        }
        stage('Unit Test') {
            steps {
                script {
                    unitTest()
                }
            }
        }
        stage('SonarQube Analysis') {
            steps {
                script {
                       sonarQube(SONAR_HOST, SONAR_PROJECT)   
                }   
            }
        }
        stage('Build docker image') {
            steps {
                script {
                    dockerize.buildDockerImage(DOCKER_IMAGE, DOCKER_REGISTERY)
                }
            }
        }
        stage('Push docker image') {
            steps {
                script {
                    COMMIT_ID = dockerize.pushDockerImage(DOCKER_IMAGE, DOCKER_REGISTERY)
                }
            }
        }
        stage('Deploy to openshift cluster') {
            steps {
                script {
                    createApp(COMMIT_ID, DOCKER_IMAGE, DOCKER_REGISTERY)
                }
            }
        }
    }
}
