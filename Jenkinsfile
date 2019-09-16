 
import groovy.json.JsonSlurper
def BuildVersion
def Current_version
def NextVersion
 pipeline {

     options {
         timeout(time: 30, unit: 'MINUTES')
     }
     agent { label 'slave' }
     stages {
         stage('Checkout') {
             steps {
                 script {
                     node('master'){
                         dir('Release') {
                             deleteDir()
                             checkout([$class: 'GitSCM', branches: [[name: 'Prod']], doGenerateSubmoduleConfigurations: false, extensions: [], submoduleCfg: [], userRemoteConfigs: [[credentialsId: 'git-cred-id', url: "https://github.com/intclassproject/Release.git"]]])
                             path_json_file = sh(script: "pwd", returnStdout: true).trim() + '/' + 'Prod' + '.json'
                             Current_version = Return_Json_From_File("$path_json_file").release.services.intapi.version
                             echo("Current_version Is in master: ${Current_version}")
                         }
                     }
                     
                     dir('INT_DB') {
                         deleteDir()
                         checkout([$class: 'GitSCM', branches: [[name: 'Dev']], doGenerateSubmoduleConfigurations: false, extensions: [], submoduleCfg: [], userRemoteConfigs: [[credentialsId: 'git-cred-id', url: "https://github.com/intclassproject/INT_DB.git"]]])
                         Commit_Id = sh(script: "git rev-parse --short HEAD", returnStdout: true).trim()
                         BuildVersion = Current_version + '_' + Commit_Id
                         println("Checking the build version: $BuildVersion")

                     }
                 }
             }
         }
         stage('UT') {
             steps {
                 println('Will be added soon ')

             }
         }
         stage('Build') {
             steps {
                 script {
                     dir('INT_DB') {
                         try {
                           docker.build("DB:$BuildVersion")
                           println("Docker image is successfully built")  

                         }
                         catch (exception) {
                             println "Docker image build failed"
                             currentBuild.result = 'FAILURE'
                             throw exception
                         }

                     }
                     
                 }


             }
         }
         stage('Push image to repository'){
             steps{
                 script{
                     try{
                         withCredentials([usernamePassword(credentialsId: 'docker-cred-id', passwordVariable: 'DOCKER_PASSWORD', usernameVariable: 'DOCKER_USERNAME')]) {
                                sh "docker login -u=${DOCKER_USERNAME} -p=${DOCKER_PASSWORD}"
                                sh "docker tag DB:$BuildVersion devopsint/dev:db_$BuildVersion"
                                sh "docker push devopsint/dev:db_$BuildVersion"
                                
                         }
                         }
                     catch (exception){
                         println "The image pushing to dockehub failed"
                         currentBuild.result = 'FAILURE'
                         throw exception
                     }
                 }
             }
         }

     }
 }
def Return_Json_From_File(file_name){
    return new JsonSlurper().parse(new File(file_name))
}
