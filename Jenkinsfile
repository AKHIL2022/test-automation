pipeline {
    agent any
    environment {
        TIMESTAMP = "${sh(script: 'date +%Y-%m-%d_%H-%M-%S', returnStdout: true).trim()}"
        OUTPUT_DIR = "robot-results/mhs-reporting/${TIMESTAMP}"
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
                    # Install dependencies in venv (robotframework should be in requirements.txt)
                    pip install -r requirements.txt
                '''
            }
        }

        stage('Run Robot Framework Tests') {
            steps {
                script {
                    sh """
                        # Activate virtual environment
                        . venv/bin/activate
                        # Run Robot tests with timestamped output directory
                        robot --outputdir ${env.OUTPUT_DIR} tests/
                    """
                }
            }
        }
    }

    post {
        always {
            script {
                    echo "Publishing Robot reports from ${env.OUTPUT_DIR}"
                    robot outputPath: env.OUTPUT_DIR
                    echo "Archiving artifacts from ${env.OUTPUT_DIR}"
                    archiveArtifacts artifacts: "${env.OUTPUT_DIR}/**", 
                                    allowEmptyArchive: true, 
                                    fingerprint: true
            }
        }
        success {
            echo 'Tests Passed! View Robot reports.'
        }
        failure {
            echo 'Tests Failed! View Robot reports.'
        }
    }
}
