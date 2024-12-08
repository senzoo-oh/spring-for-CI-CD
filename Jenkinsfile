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
    stage("Update Kubernetes Manifests") {
      steps {
        script {
          sh "sed -i 's/spring:latest/spring:${env.BUILD_ID}/g' webServerDeployment.yaml"
        }
      }
    }
    stage("Deploy to GKE") {
      when {
        branch 'main'
      }
      steps {
	script {
	  withCredentials([file(credentialsId: "${CREDENTIALS_ID}", variable: 'GKE_KEY')]) {
	    sh 'gcloud auth active-service-account --key-file=$GKE_KEY'
	    sh 'gcloud container clusters get-credentials ${CLUSTER_NAME} --zone ${LOCATION} --project ${PROJECT_ID}'
	    sh 'kubectl apply -f mysql-pv.yaml'
	    sh 'kubectl apply -f mysql-pvc.yaml'

	    sh 'kubectl apply -f springDB-secret.yaml'

	    sh 'kubectl apply -f springDBDeployment.yaml'

	    sh 'kubectl apply -f webServerDeployment.yaml'
	  }
	}
      }
    }
  }
}
