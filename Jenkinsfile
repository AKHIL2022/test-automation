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
                    # Install dependencies in venv (robotframework should be in requirements.txt)
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
                    
                    // Debug: Print timestamp and output directory
                    echo "Generated timestamp: ${timestamp}"
                    echo "Output directory: ${outputDir}"
                    
                    // Store timestamp in environment variable
                    env.TIMESTAMP = timestamp
                    
                    // Run robot command and ignore test failure exit code
                    sh """
                        # Activate virtual environment
                        . venv/bin/activate
                        # Run Robot tests with timestamped output directory
                        robot --outputdir ${outputDir} tests/
                        # Debug: List output files
                        ls -l ${outputDir} || echo "No output files generated"
                    """
                }
            }
            post {
                always {
                    script {
                        // Use local variable to ensure timestamp access
                        def outputDir = env.TIMESTAMP ? "robot-results/${env.TIMESTAMP}" : null
                        if (outputDir && fileExists(outputDir)) {
                            echo "Publishing Robot reports from ${outputDir}"
                            // Publish Robot reports
                            robot outputPath: outputDir
                        } else {
                            echo "Output directory ${outputDir} does not exist or TIMESTAMP is not set. Skipping Robot report publishing."
                        }
                    }
                }
            }
        }
    }

    post {
        always {
            script {
                // Archive the timestamped folder contents if it exists
                def outputDir = env.TIMESTAMP ? "robot-results/${env.TIMESTAMP}" : null
                if (outputDir && fileExists(outputDir)) {
                    echo "Archiving artifacts from ${outputDir}"
                    archiveArtifacts artifacts: "${outputDir}/**", 
                                    allowEmptyArchive: true, 
                                    fingerprint: true
                } else {
                    echo "No artifacts to archive: ${outputDir} does not exist or TIMESTAMP is not set."
                }
            }
        }
        success {
            echo 'Pipeline completed! View Robot reports on build page if available.'
        }
        failure {
            echo 'Pipeline execution issues - check logs and Robot reports on build page if available.'
        }
    }
}
