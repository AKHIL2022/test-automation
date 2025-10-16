pipeline {
    agent any

    stages {
        stage('Checkout') {
            steps {
                checkout scm
            }
        }

        stage('Setup') {
            steps {
                sh 'pip install -r requirements.txt'
            }
        }

        stage('Run Robot Framework Tests') {
            steps {
                dir('allure-results') {
                    deleteDir()  // Clean previous Allure results
                }
                sh '''
                    robot \
                        --listener robotframework_allure.AllureListener \
                        --outputdir robot-results \
                        tests/
                '''
            }
            post {
                always {
                    robot 'robot-results/output.xml'  // Native Robot report
                }
            }
        }

        stage('Generate Allure Report') {
            steps {
                script {
                    // Generate Allure HTML from XML results
                    sh 'allure generate allure-results/ -o allure-report/ --clean'
                }
            }
            post {
                always {
                    // Publish Allure to Jenkins build page
                    allure includeProperties: false, 
                           jdk: '', 
                           results: [[path: 'allure-results']], 
                           reportBuildPolicy: 'ALWAYS', 
                           reportPublishPolicy: 'ALWAYS'
                }
            }
        }
    }

    post {
        always {
            // Archive downloadable artifacts: Robot reports + Allure HTML/zip
            zip zipFile: 'allure-report.zip', dir: 'allure-report/', glob: '**/*'
            archiveArtifacts artifacts: 'robot-results/**, allure-results/**, allure-report.zip', 
                             allowEmptyArchive: true, 
                             fingerprint: true
        }
        success {
            echo 'All Robot tests passed! View Allure report on build page.'
        }
        failure {
            echo 'Robot tests failed - check Allure/Robot reports on build page and artifacts.'
        }
    }
}