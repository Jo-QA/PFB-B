# ============================================================
# Projet de Fin de Bloc B — Homey
# Page Object — Réservations hôte et voyageur
# ============================================================

*** Settings ***

Library     SeleniumLibrary

Resource    ../variables.robot

*** Variables ***

${URL_RESERVATIONS}                   ${URL}index.php/reservations/
${STATUT_DEMANDE_NOUVELLE}            NOUVEAU
${BOUTON_CONFIRMER_DISPONIBILITE}     xpath=//button[contains(@class, "confirm-offsite-reservation") and not(contains(@class, "btn-half-width"))]
${BOUTON_MARQUER_COMME_PAYE}          css=a.mark-as-paid
${BOUTON_CONFIRMER_PAIEMENT}          xpath=//button[normalize-space()="Confirmer"]

*** Keywords ***

Ouvrir les réservations
    Go To    ${URL_RESERVATIONS}
    Wait Until Page Contains    Gérer

Ouvrir la demande de réservation à confirmer
    [Arguments]    ${date_arrivee}
    ${lien_confirmer}=    Set Variable
    ...    xpath=//tr[.//td[normalize-space()="${STATUT_DEMANDE_NOUVELLE}"] and .//td[normalize-space()="${date_arrivee}"]]//a[normalize-space()="Confirmer"]
    Ouvrir les réservations
    Wait Until Element Is Visible    ${lien_confirmer}
    Click Element    ${lien_confirmer}
    Wait Until Element Is Visible    ${BOUTON_CONFIRMER_DISPONIBILITE}

Confirmer la disponibilité de la réservation
    Click Element    ${BOUTON_CONFIRMER_DISPONIBILITE}
    Wait Until Page Contains    ${MESSAGE_DISPONIBILITE_CONFIRMEE}

Le statut de paiement en attente doit être affiché
    [Arguments]    ${date_arrivee}
    ${ligne_reservation}=    Set Variable
    ...    xpath=//tr[.//td[normalize-space()="${STATUT_PAIEMENT_EN_ATTENTE}"] and .//td[normalize-space()="${date_arrivee}"]]
    Ouvrir les réservations
    Wait Until Element Is Visible    ${ligne_reservation}

Ouvrir le détail d'une réservation au paiement en attente
    [Arguments]    ${date_arrivee}
    ${lien_details}=    Set Variable
    ...    xpath=//tr[.//td[normalize-space()="${STATUT_PAIEMENT_EN_ATTENTE}"] and .//td[normalize-space()="${date_arrivee}"]]//a[normalize-space()="Détails"]
    Ouvrir les réservations
    Wait Until Element Is Visible    ${lien_details}
    Click Element    ${lien_details}

Le paiement doit être bloqué sans profil hôte
    Element Should Not Be Visible    ${BOUTON_MARQUER_COMME_PAYE}

Marquer la réservation comme payée
    Wait Until Element Is Visible    ${BOUTON_MARQUER_COMME_PAYE}
    Click Element    ${BOUTON_MARQUER_COMME_PAYE}
    Wait Until Element Is Visible    ${BOUTON_CONFIRMER_PAIEMENT}
    Click Element    ${BOUTON_CONFIRMER_PAIEMENT}
    Wait Until Element Is Not Visible    ${BOUTON_CONFIRMER_PAIEMENT}

Le statut réservé doit être affiché
    [Arguments]    ${date_arrivee}
    ${ligne_reservation}=    Set Variable
    ...    xpath=//tr[contains(normalize-space(), "${STATUT_RESERVE}") and .//td[normalize-space()="${date_arrivee}"]]
    Ouvrir les réservations
    Wait Until Element Is Visible    ${ligne_reservation}
