def storage="/mnt/artifacts"
pipeline {
options {
 timeout(time: 30, unit: 'MINUTES')
}
agent { label 'docker' }
 stages {
  stage('Checkout') {
   steps {
    script {
     checkout([$class: 'GitSCM', branches: [[name: '*/yuri']], doGenerateSubmoduleConfigurations: false, extensions: [], submoduleCfg: [], userRemoteConfigs: [[credentialsId: 'git', url: 'https://github.com/intclassproject/INT_DB.git']]])
      Commit_Id = sh(script: "git rev-parse --short HEAD", returnStdout: true).trim()
    }
   }
  }
  stage('Build') {
   steps {
    script {
     sh "docker build . -t intdb:${Commit_Id}"
     //take latesr version from prod.json and add commit id to it -- use this as dev version during the ci
     // add try catch
    }
   }
  }
  stage('Save to docker image to repo') {
   steps {
    script {
     sh "mkdir -p ${storage}/dev"
     sh "docker save intapi:${Commit_Id} > ${storage}/dev/intapi_${Commit_Id}.tar"
     }
    }
   }
  }
}
