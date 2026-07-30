# ============================================================
# Projet de Fin de Bloc B - Homey
# Smoke Test - Connexion
# ============================================================


*** Settings ***

Resource   ../../resources/variables.robot
Resource   ../../resources/common_keywords.robot
Resource   ../../resources/pages/page_dashboard_voyageur.robot

Suite Setup       Ouvrir l'application
Suite Teardown    Fermer l'application
Test Tags         smoke    connexion    P1


*** Test Cases ***

Un utilisateur doit pouvoir se connecter
    [Documentation]    Vérifie l'accès au tableau de bord avec le compte voyageur de test.
    Se connecter avec un compte valide    ${UTILISATEUR_LOGIN}    ${UTILISATEUR_PASSWORD}

    Le tableau de bord voyageur doit être affiché
