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
                    # Ensure robot-results directory exists
                    mkdir -p robot-results
                '''
            }
        }

        stage('Run Robot Framework Tests') {
            steps {
                script {
                    // Generate timestamp for output directory
                    def timestamp = sh(script: 'date +%Y-%m-%d_%H-%M-%S', returnStdout: true).trim()
                    // Define timestamped output directory
                    def outputDir = "robot-results/${timestamp}"
                    
                    sh """
                        # Activate virtual environment
                        . venv/bin/activate
                        # Run Robot tests with timestamped output directory
                        robot --outputdir ${outputDir} tests/
                    """
                    
                    // Store timestamp for use in post section
                    env.TIMESTAMP = timestamp
                }
            }
            post {
                always {
                    robot outputPath: "robot-results/${env.TIMESTAMP}"
                }
            }
        }
    }

    post {
        always {
            script {
                // Archive the timestamped folder contents
                def timestamp = env.TIMESTAMP
                archiveArtifacts artifacts: "robot-results/${timestamp}/**", 
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
