# ============================================================
# Projet de Fin de Bloc B — Homey
# Page Object — Page d'accueil
# ============================================================

*** Settings ***

Library    SeleniumLibrary

*** Variables ***

${ENTETE_BUREAU}    css=#homey_nav_sticky
${BOUTON_LOGIN}     css=#homey_nav_sticky a[data-target="#modal-login"]
${MODALE_LOGIN}     css=#modal-login

*** Keywords ***

Ouvrir la fenêtre de connexion
    Wait Until Element Is Visible    ${ENTETE_BUREAU}
    Click Element    ${BOUTON_LOGIN}
    Wait Until Element Is Visible    ${MODALE_LOGIN}
