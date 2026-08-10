# ============================================================
# Projet de Fin de Bloc B —  Homey
# Page Object — Page d'accueil
# ============================================================

*** Settings ***

Library    SeleniumLibrary

Resource    ../variables.robot

*** Variables ***

${ENTETE_BUREAU}    css=#homey_nav_sticky
${BOUTON_LOGIN}     css=#homey_nav_sticky a[data-target="#modal-login"]
${MODALE_LOGIN}     css=#modal-login

*** Keywords ***

Ouvrir la fenêtre de connexion
    Wait Until Element Is Visible    ${ENTETE_BUREAU}    ${DELAI_ATTENTE}
    Tenter d'ouvrir la fenêtre de connexion
    ${modale_est_visible}=    Run Keyword And Return Status
    ...    Wait Until Element Is Visible
    ...    ${MODALE_LOGIN}
    ...    ${DELAI_ATTENTE}
    IF    not ${modale_est_visible}
        Log    Le premier clic sur Login n'a pas ouvert la modale ; une seule nouvelle tentative est effectuée.    WARN
        Tenter d'ouvrir la fenêtre de connexion
        Wait Until Element Is Visible    ${MODALE_LOGIN}    ${DELAI_ATTENTE}
    END

Tenter d'ouvrir la fenêtre de connexion
    ${modale_est_visible}=    Run Keyword And Return Status
    ...    Element Should Be Visible
    ...    ${MODALE_LOGIN}
    IF    not ${modale_est_visible}
        Wait Until Element Is Visible    ${BOUTON_LOGIN}    ${DELAI_ATTENTE}
        Wait Until Element Is Enabled    ${BOUTON_LOGIN}    ${DELAI_ATTENTE}
        Click Element    ${BOUTON_LOGIN}
    END
