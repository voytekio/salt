node {
    stage('Build') {
        echo 'Building...'
        echo "WORKSPACE: ${env.WORKSPACE}"
        sh 'source ~/virtualenvs/python_testing/bin/activate'
    }
    stage('Test') {
        echo 'Testing...'
        sh 'tox'
    }
    stage('wrapup') {
        echo 'wrap up'
        sh 'deactivate'
    }
}
