pipeline {
    agent any

    parameters {
        booleanParam(
            name: 'EXECUTER_TESTS_P2',
            defaultValue: false,
            description: 'Lance aussi les scénarios P2, dont le parcours complet qui enregistre un profil bancaire fictif et crée une réservation. Préparer des données de test avant ce lancement.'
        )
    }

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
                script {
                    def optionsRobot = '--include P1 --exclude anomalie_connue'
                    if (params.EXECUTER_TESTS_P2) {
                        optionsRobot = '--include P1 --include P2 --exclude anomalie_connue'
                    }
                    bat """
                        call .venv\\Scripts\\activate.bat
                        python -m robot ${optionsRobot} --outputdir results tests
                    """
                }
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
