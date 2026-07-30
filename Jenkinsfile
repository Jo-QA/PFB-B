pipeline {
    agent any

    options {
        skipDefaultCheckout(true)
    }

    environment {
        ENVIRONNEMENT_EXECUTION = 'CI'
    }

    stages {
        stage('Récupérer le code') {
            steps {
                checkout scm
            }
        }

        stage('Préparer Python') {
            steps {
                bat '''
                    python -m venv .venv
                    call .venv\\Scripts\\activate.bat
                    python -m pip install --upgrade pip
                    python -m pip install -r requirements.txt
                '''
            }
        }

        stage('Exécuter les tests Robot Framework') {
            steps {
                bat '''
                    call .venv\\Scripts\\activate.bat
                    python -m robot --outputdir results tests
                '''
            }
        }
    }

    post {
        always {
            robot outputPath: 'results'
            archiveArtifacts artifacts: 'results/**/*', allowEmptyArchive: true
        }
    }
}
