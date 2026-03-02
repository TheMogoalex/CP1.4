pipeline {
  agent none
  options { timestamps(); skipDefaultCheckout(true) }

  stages {

    stage('CI - develop (staging)') {
      when { branch 'develop' }
      stages {
        stage('Get Code') { agent any; steps { checkout scm; sh 'whoami && hostname' } }
        stage('Static (agent static)') { agent { label 'static' }; steps { checkout scm; sh 'whoami && hostname'; sh 'bash pipelines/PIPELINE-FULL-STAGING/static_test.sh' } }
        stage('Unit') { agent any; steps { checkout scm; sh 'bash pipelines/PIPELINE-FULL-STAGING/setup.sh'; sh 'bash pipelines/PIPELINE-FULL-STAGING/unit_test.sh' } }
        stage('Build') { agent any; steps { checkout scm; sh 'bash pipelines/common-steps/build.sh' } }
        stage('Deploy') { agent any; steps { checkout scm; sh 'bash pipelines/common-steps/deploy.sh' } }
        stage('Rest (agent rest)') {
          agent { label 'rest' }
          steps {
            checkout scm
            script {
              def BASE_URL = sh(script: "aws cloudformation describe-stacks --stack-name cp14-mogo-staging --region us-east-1 --query 'Stacks[0].Outputs[?OutputKey==`BaseUrlApi`].OutputValue' --output text", returnStdout: true).trim()
              sh "bash pipelines/common-steps/integration.sh ${BASE_URL}"
            }
          }
        }
      }
    }

    stage('CD - master (production)') {
      when { branch 'master' }
      stages {
        stage('Get Code') { agent any; steps { checkout scm; sh 'whoami && hostname' } }
        stage('Build') { agent any; steps { checkout scm; sh 'bash pipelines/common-steps/build.sh' } }
        stage('Deploy') { agent any; steps { checkout scm; sh 'bash pipelines/common-steps/deploy.sh' } }
        stage('Rest RO (agent rest)') {
          agent { label 'rest' }
          steps {
            checkout scm
            script {
              def BASE_URL = sh(script: "aws cloudformation describe-stacks --stack-name cp14-mogo-production --region us-east-1 --query 'Stacks[0].Outputs[?OutputKey==`BaseUrlApi`].OutputValue' --output text", returnStdout: true).trim()
              sh "bash pipelines/common-steps/integration_readonly.sh ${BASE_URL}"
            }
          }
        }
      }
    }
  }

  post {
    always {
        node('built-in') {
            cleanWs()
        }
    }
  }
}