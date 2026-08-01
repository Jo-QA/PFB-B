# ============================================================
# Projet de Fin de Bloc B — Homey
# Page Object — Modale de connexion
# ============================================================

*** Settings ***

Library    SeleniumLibrary

*** Variables ***

${CHAMP_USERNAME}             css=#modal-login input[name="username"]
${CHAMP_PASSWORD}             css=#modal-login input[name="password"]
${BOUTON_VALIDER_LOGIN}       css=#modal-login button.homey_login_button
${CONTENEUR_MODALE_LOGIN}     css=#modal-login

*** Keywords ***

Saisir le nom utilisateur
    [Arguments]    ${username}
    Input Text    ${CHAMP_USERNAME}    ${username}

Saisir le mot de passe
    [Arguments]    ${password}
    Input Password    ${CHAMP_PASSWORD}    ${password}

Valider la connexion
    Click Button    ${BOUTON_VALIDER_LOGIN}
    Wait Until Element Is Not Visible    ${CONTENEUR_MODALE_LOGIN}

La modale de connexion doit être affichée
    Wait Until Element Is Visible    ${CONTENEUR_MODALE_LOGIN}
