pipeline {
    agent any

    stages {
        stage('Checkout') {
            steps {
                git branch: 'main', 
                    url: 'https://github.com/AKHIL2022/test-automation.git'
            }
        }

        stage('Setup') {
            steps {
                sh '''
                    # Create virtual environment
                    python3 -m venv venv
                    # Activate virtual environment
                    . venv/bin/activate
                    # Verify Python and pip in venv
                    python --version
                    pip --version
                    # Install dependencies in venv
                    pip install -r requirements.txt
                '''
            }
        }

        stage('Run Robot Framework Tests') {
            steps {
                sh '''
                    # Activate virtual environment
                    . venv/bin/activate
                    # Run Robot tests
                    robot --outputdir robot-results tests/
                '''
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
