pipeline {
    agent any
    stages {
        stage('Build') {
            steps {
                echo '------------Stage: Build-----------'
                echo "WORKSPACE: ${env.WORKSPACE}"
                echo "JENKINS_URL: ${env.JENKINS_URL}"
                echo '------------start var list-----------'
                sh 'printenv'
                echo '------------end var list-----------'
            }
        }
        stage('Test') {
            steps {
                echo '----------Stage: Test------------'
                echo 'empty for now.'
            }
        }
        stage('Wrap-up') {
            steps {
                echo '----------Stage: Wrap-up-----------'
                echo 'empty for now.'
            }
        }
    }
}
