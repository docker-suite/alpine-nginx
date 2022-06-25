versions = ['1.16', '1.17', '1.18', '1.19', '1.20', '1.21', '1.22', '1.23']

pipeline {

    agent { label 'docker-agent' }

    stages {
        stage ( "Building") {
            steps {
                script {
                    versions.each { version ->
                        docker.withRegistry('', 'docker-hub-credentials') {
                            stage("version ${version}") {
                                sh "make build v=${version}"
                                sh "make push v=${version}"
                            }
                        }
                    }
                }
            }
        }
    }

    post {
        always {
            script {
                sh 'make remove'
            }
        }
        cleanup {
            cleanWs()
        }
    }
}
