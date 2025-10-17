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
                // Archive the timestamped folder
                def timestamp = env.TIMESTAMP
                def zipName = "robot-results-${timestamp}.zip"
                
                // Create zip of the timestamped folder
                sh """
                    zip -r ${zipName} robot-results/${timestamp}/
                """
                
                // Archive the timestamped zip and the timestamped folder contents
                archiveArtifacts artifacts: "${zipName}, robot-results/${timestamp}/**", 
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
