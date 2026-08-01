# ============================================================
# Projet de Fin de Bloc B — Homey
# Smoke test — Connexion
# ============================================================

*** Settings ***

Resource          ../../resources/variables.robot
Resource          ../../resources/common_keywords.robot
Resource          ../../resources/pages/page_dashboard_voyageur.robot

Suite Setup       Ouvrir l'application
Suite Teardown    Fermer l'application
Test Tags         smoke    connexion    P1

*** Test Cases ***

Un utilisateur doit pouvoir se connecter
    [Documentation]    Vérifie qu'un voyageur accède à son tableau de bord avec des identifiants valides.
    Se connecter avec un compte valide    ${UTILISATEUR_LOGIN}    ${UTILISATEUR_PASSWORD}
    Le tableau de bord voyageur doit être affiché
