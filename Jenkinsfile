pipeline {
    agent any
    environment {
        PYTHONPATH = "${WORKSPACE}"
    }
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
        }
    }
    
    post {
        always {
            script {
                // Publish Robot reports
                robot outputPath: 'robot-results'
                // Generate timestamp for artifacts
                def timestamp = sh(script: 'date +%Y-%m-%d_%H-%M-%S', returnStdout: true).trim()
                def zipName = "robot-results-${timestamp}.zip"
                // Create zip of all artifacts
                sh """
                zip -r ${zipName} robot-results/
                """
                // Archive the timestamped zip (for single download) and unzipped contents
                archiveArtifacts artifacts: "${zipName}, robot-results/**",
                allowEmptyArchive: true,
                fingerprint: true
            }
        }
        success {
            echo 'All Robot tests passed! View Robot reports on build page.'
        }
        failure {
            echo 'Robot tests failed - check Robot reports on build page and artifacts.'
        }
    }
}
