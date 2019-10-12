pipeline {
    agent {
        label "slave"
    }
    environment {
        TEST_VAR1 = 'false'
        TEST_VAR2 = 'sqlite'
        //AWS_ACCESS_KEY_ID     = credentials('jenkins-aws-secret-key-id')
        //AWS_SECRET_ACCESS_KEY = credentials('jenkins-aws-secret-access-key')
    }
    stages {
        stage('prep') {
            steps {
                sh 'echo ========================'
                sh 'echo running Prep Stage'
                sh 'python --version'
                sh 'hostname'
                sh 'pwd'
                sh 'printenv'
                sh 'echo ========================'
                // sh 'curl -sSL https://raw.githubusercontent.com/sdispater/poetry/master/get-poetry.py | python'
                // sh 'poetry -V'
                sh 'groups'
            }
        }
        stage('build') {
            steps {
                sh 'echo ========================'
                sh 'echo running Build Stage'
                // sh 'build sh or poetry or whatever'
                // sh 'exit 1'
            }
        }
        stage('test') {
            when {
                changeRequest()
            }
            steps {
                sh 'echo ========================'
                sh 'echo running Test Stage'
                // sh 'tox'
                // sh 'exit 1'
            }
        }
        stage('deploy-dev') {
            when {
                branch 'master'
            }
            steps {
                sh 'echo ========================='
                sh 'echo running deploy-dev after merge to master.'
                sh 'echo upload-to-dev-pypi, or initiate dev master highstate'
            }
        }
        stage('deploy-prod') {
            when {
                buildingTag()
            }
            steps {
                sh 'echo ========================='
                sh 'echo running deploy-pror after new tag uploaded.'
                sh 'echo upload-to-prod-pypi, or initiate prod master highstate'
            }
        }
    }
    post {
        always {
            echo 'This will always run'
        }
    }
}
