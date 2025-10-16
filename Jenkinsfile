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
                script {
                    // Generate timestamp for folder name
                    def timestamp = sh(script: 'date +%Y-%m-%d_%H-%M-%S', returnStdout: true).trim()
                    // Create timestamped output directory inside robot-results
                    def resultDir = "robot-results/test-results-${timestamp}"
                    
                    sh """
                        # Activate virtual environment
                        . venv/bin/activate
                        # Create the specific results directory
                        mkdir -p ${resultDir}
                        # Run Robot tests with output to the timestamped directory
                        # Use absolute path and ensure output goes exactly where we want
                        cd ${resultDir} && robot --outputdir . --log log.html --report report.html --output output.xml ../../tests/
                    """
                }
            }
        }
    }
    
    post {
        always {
            script {
                // Find the most recent results folder
                def latestDir = sh(
                    script: 'ls -td robot-results/test-results-* | head -1',
                    returnStdout: true
                ).trim()
                
                echo "Publishing Robot results from: ${latestDir}"
                
                // Publish Robot reports from the latest directory
                robot outputPath: "${latestDir}"
                
                // Archive all robot-results directory
                archiveArtifacts artifacts: "robot-results/**",
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
