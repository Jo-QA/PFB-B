# ============================================================
# Projet de Fin de Bloc B — Homey
# Page Object — Tableau de bord voyageur
# ============================================================

*** Settings ***

Library     SeleniumLibrary

Resource    ../variables.robot

*** Variables ***

${TITRE_TABLEAU_DE_BORD}    Tableau de bord - Livraison 3

*** Keywords ***

Le tableau de bord voyageur doit être affiché
    Wait Until Keyword Succeeds
    ...    ${DELAI_ATTENTE}
    ...    500ms
    ...    Location Should Contain
    ...    /dashboard/
    Title Should Be    ${TITRE_TABLEAU_DE_BORD}
