node {
    stage('Build') {
        echo 'Building...'
        echo "WORKSPACE: ${env.WORKSPACE}"
    }
    stage('Test') {
        echo 'Testing...'
        sh 'which pip'
        sh 'source ~/virtualenvs/python_testing/bin/activate'
        sh 'which pip'
        sh 'tox'
        sh 'deactivate'
    }
    stage('wrapup') {
        echo 'wrap up'
    }
}
