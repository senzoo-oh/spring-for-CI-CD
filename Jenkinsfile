pipeline {
  agent any
  environment {
    PROJECT_ID = 'open-source-442205'
    CLUSTER_NAME = 'k8s'
    LOCATION = 'asia-northeast3-a'
    CREDENTIALS_ID = 'gke'
  }
  stages {
    stage("git clone") {
      steps {
        checkout scm
      }
    }
    stage("build image") {
      steps {
        script {
          spring = docker.build("senzoo/spring:${env.BUILD_ID}")
	}
      }
    }
    stage("push image") {
      steps {
        script {
          docker.withRegistry('https://registry.hub.docker.com', 'dockerhub') {
            spring.push("latest")
            spring.push("${env.BUILD_ID}")
          }
        }
      }
    }
  }
}
