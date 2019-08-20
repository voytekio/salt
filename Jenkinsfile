node {
    checkout scm
    stage('Build') {
        echo '================= Build stage ================='
        echo "WORKSPACE: ${env.WORKSPACE}"
        echo "JENKINS_URL: ${env.JENKINS_URL}"
        echo "HUDSON_URL: ${env.HUDSON_URL}"
        echo '--------start var list------'
        sh 'printenv'
        echo '---------end var list-------'
        sh 'hostname'
        sh 'python --version'
        sh 'groups'
        sh 'pwd'

    }
    stage('Test') {
        echo '================= Test stage ================='
        //sh 'source ~/virtualenvs/python_testing/bin/activate;which pip;tox'
    }
    stage('Deploy') {
        echo '================= Deploy stage ================='
    }
    stage('Wrapup') {
        echo '================= Wrapup stage ================='
        // archiveArtifacts 'logs/*.log'
    }
}
