pipeline {
    agent any

    stages {
        stage('Check Python and pip version') {
            steps {
                script {
                    try {
                        // Check Python version
                        def pythonVersion = sh(script: 'python3 --version', returnStdout: true).trim()
                        echo "✅ Python is installed: ${pythonVersion}"
                        
                        // Check pip version
                        def pipVersion = sh(script: 'pip3 --version', returnStdout: true).trim()
                        echo "✅ pip is installed: ${pipVersion}"
                        // Check venv
                        def venv = sh(script: 'python3 -m venv --help', returnStdout: true).trim()
                        echo "✅ venv is installed: ${venv}"                        
                    } catch (Exception e) {
                        error "❌ Python or pip is not installed: ${e.message}"
                    }
                }
            }
        }

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
