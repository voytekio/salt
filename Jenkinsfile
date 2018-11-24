node {
    checkout scm
    stage('Build') {
        echo 'Building...'
        echo "WORKSPACE: ${env.WORKSPACE}"
        echo "JENKINS_URL: ${env.JENKINS_URL}"
        echo "HUDSON_URL: ${env.HUDSON_URL}"
        echo '--------start var list------'
        sh 'printenv'
        echo '---------end var list-------'
    }
    stage('Test') {
        echo 'Testing...'
        sh 'source ~/virtualenvs/python_testing/bin/activate;which pip;tox'
    }
    stage('wrapup') {
        echo 'wrap up'
        archiveArtifacts 'logs/*.log'
    }
}
