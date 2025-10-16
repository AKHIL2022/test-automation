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
                    # Install Python3 and pip3 (Ubuntu/Debian-based agent)
                    apt-get update
                    apt-get install -y python3 python3-pip
                    # Verify installations
                    python3 --version
                    pip3 --version
                    # Install dependencies from requirements.txt
                    pip3 install -r requirements.txt
                '''
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
