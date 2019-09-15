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
  stage('Test the container is runnable') {
   steps {
    script {
     sh "$(cat README.md | head -1):${Commit_Id} && if [ ?$ -eq 0 ]; then echo 'Launch SUCCESS' && docker stop mongodb; else exit 1; fi"
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
