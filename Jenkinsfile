pipeline {
  agent any
  stages {
    stage('Install Pods') {
      steps {
        sh 'pod install --deployment --repo-update'
        
      }
    }
    stage('Run Tests') {
      steps {
       sh 'fastlane tests'
      }
    }
  }
}
