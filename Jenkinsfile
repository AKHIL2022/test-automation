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
                    # Install pyenv to manage Python versions (no root needed)
                    if [ ! -d ~/.pyenv ]; then
                        curl https://pyenv.run | bash
                    fi
                    # Set up environment variables for pyenv
                    export PATH="$HOME/.pyenv/bin:$PATH"
                    eval "$(pyenv init --path)"
                    eval "$(pyenv init -)"
                    # Install Python 3.12 if not already installed
                    pyenv install 3.12.3 -s  # -s skips if already installed
                    pyenv global 3.12.3
                    # Verify Python and pip
                    python3 --version
                    pip3 --version
                    # Install dependencies from requirements.txt
                    pip3 install -r requirements.txt
                '''
            }
        }

        stage('Run Robot Framework Tests') {
            steps {
                sh '''
                    export PATH="$HOME/.pyenv/bin:$PATH"
                    eval "$(pyenv init --path)"
                    eval "$(pyenv init -)"
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
