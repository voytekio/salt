node {
    stage('Build') {
        echo 'Building...'
        echo "WORKSPACE: ${env.WORKSPACE}"
    }
    stage('Test') {
        echo 'Testing...'
        sh 'tox'
    }
}
