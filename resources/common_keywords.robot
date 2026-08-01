# ============================================================
# Projet de Fin de Bloc B — Homey
# Mots-clés communs à tous les scénarios
# ============================================================

*** Settings ***

Library     SeleniumLibrary

Resource    variables.robot
Resource    pages/modal_connexion.robot
Resource    pages/page_accueil.robot

*** Keywords ***

Ouvrir l'application
    ${options_chrome}=    Set Variable    ${OPTIONS_CHROME_TEST}
    IF    '${ENVIRONNEMENT_EXECUTION}' == 'CI'
        ${options_chrome}=    Set Variable    ${OPTIONS_CHROME_CI}
    END
    Open Browser
    ...    ${URL}
    ...    ${NAVIGATEUR}
    ...    options=${options_chrome}
    IF    '${ENVIRONNEMENT_EXECUTION}' != 'CI'
        Maximize Browser Window
    END
    Set Selenium Timeout    ${DELAI_ATTENTE}

Fermer l'application
    Close All Browsers

Se connecter avec un compte valide
    [Arguments]    ${username}    ${password}
    Ouvrir la fenêtre de connexion
    Saisir le nom utilisateur    ${username}
    Saisir le mot de passe    ${password}
    Valider la connexion
