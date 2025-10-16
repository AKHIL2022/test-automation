pipeline {
    agent any

    stages {
        stage('Checkout') {
            steps {
                checkout scm
            }
        }

        stage('Setup') {
            steps {
                sh 'pip install -r requirements.txt'
            }
        }

        stage('Run Robot Framework Tests') {
            steps {
                sh 'robot --outputdir robot-results tests/'
            }
            post {
                always {
                    robot 'robot-results/output.xml'  // Native Robot report
                }
            }
        }
    }

    post {
        always {
            // Archive downloadable artifacts: Only Robot reports
            archiveArtifacts artifacts: 'robot-results/**', 
                             allowEmptyArchive: true, 
                             fingerprint: true
        }
        success {
            echo 'All Robot tests passed! View Robot reports on build page.'
        }
        failure {
            echo 'Robot tests failed - check Robot reports on build page and artifacts.'
        }
    }
}
