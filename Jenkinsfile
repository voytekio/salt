node {
    checkout scm
    stage('Build') {
        echo 'Building...'
        echo "WORKSPACE: ${env.WORKSPACE}"
        echo "JENKINS_URL: ${env.JENKINS_URL}"
        echo "HUDSON_URL: ${env.HUDSON_URL}"
    }
    stage('Test') {
        echo 'Testing...'
        sh 'which pip'
        sh 'source ~/virtualenvs/python_testing/bin/activate;which pip;tox'
    }
    stage('wrapup') {
        echo 'wrap up'
    }
}
