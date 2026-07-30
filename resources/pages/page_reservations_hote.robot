*** Settings ***

Library    SeleniumLibrary

Resource    ../variables.robot


*** Variables ***

${URL_RESERVATIONS_HOTE}             ${URL}index.php/reservations/
${STATUT_DEMANDE_NOUVELLE}           NOUVEAU
${BOUTON_CONFIRMER_DISPONIBILITE}    xpath=//button[contains(@class, "confirm-offsite-reservation") and not(contains(@class, "btn-half-width"))]


*** Keywords ***

Ouvrir les réservations hôte
    Go To    ${URL_RESERVATIONS_HOTE}
    Wait Until Page Contains    Gérer

Ouvrir la demande de réservation à confirmer
    [Arguments]    ${date_arrivee}
    ${lien_confirmer}=    Set Variable
    ...    xpath=//tr[.//td[normalize-space()="${STATUT_DEMANDE_NOUVELLE}"] and .//td[normalize-space()="${date_arrivee}"]]//a[normalize-space()="Confirmer"]
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
    Ouvrir les réservations hôte
    Wait Until Element Is Visible    ${ligne_reservation}
