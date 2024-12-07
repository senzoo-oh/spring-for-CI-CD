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
    stage("Deploy to GKE") {
      when {
        branch 'main'
      }
      steps {
        sh "sed -i 's/spring:latest/spring:${env.BUILD_ID}/g' Deployment.yaml"
	step([$class: 'KubernetesEngineBuilder', projectId: env.PROJECT_ID, clusterName: env.CLUSTER_NAME, location: env.LOCATION, manifestPattern: 'deployment.yaml', credentialsID: env.CREDENTIALS_ID, verifyDeployments: true])
      }
    }
  }
}
