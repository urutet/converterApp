pipeline {
  agent any
  stages {
    stage('Install Pods') {
      steps {
        sh 'pod install --deployment --repo-update'
        echo('Installing pods')
      }

    stage('Run Tests') {
      sh 'fastlane tests'
    }
  }
}
