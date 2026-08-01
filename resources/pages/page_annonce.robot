*** Settings ***

Library    SeleniumLibrary

Resource    ../variables.robot


*** Variables ***

${BOUTON_DEMANDE_RESERVATION}    css=#request_for_reservation
${MESSAGE_LOGIN_REQUIS}           Vous devez vous connecter pour effectuer une réservation
${CHAMP_DATE_DEBUT}               css=.sidebar-booking-module.hidden-sm.hidden-xs #single-listing-date-range input[name="arrive"]
${CHAMP_DATE_FIN}                 css=.sidebar-booking-module.hidden-sm.hidden-xs #single-listing-date-range input[name="depart"]
${CALENDRIER_RESERVATION}         css=.sidebar-booking-module.hidden-sm.hidden-xs #single-booking-search-calendar
${BOUTON_MOIS_PRECEDENT}          css=.sidebar-booking-module.hidden-sm.hidden-xs #single-booking-search-calendar .listing-cal-prev
${BOUTON_MOIS_SUIVANT}            css=.sidebar-booking-module.hidden-sm.hidden-xs #single-booking-search-calendar .listing-cal-next
${NOMBRE_MAX_MOIS_CALENDRIER}     12
${CHAMP_VOYAGEURS}                xpath=//button[@id="request_for_reservation"]/ancestor::div[contains(@class, "sidebar-booking-module")]//input[@name="guests"]
${BOUTON_AJOUTER_ADULTE}          xpath=//button[@id="request_for_reservation"]/ancestor::div[contains(@class, "sidebar-booking-module")]//button[contains(@class, "adult_plus")]
${BOUTON_APPLIQUER_VOYAGEURS}     xpath=//button[@id="request_for_reservation"]/ancestor::div[contains(@class, "sidebar-booking-module")]//button[contains(@class, "apply_guests")]
${CHAMP_MESSAGE_HOTE}             xpath=//button[@id="request_for_reservation"]/ancestor::div[contains(@class, "sidebar-booking-module")]//textarea[contains(@name, "message") or contains(@id, "message")]
${CALENDRIER_ATTENDANT_DEPART}    css=.sidebar-booking-module.hidden-sm.hidden-xs #single-booking-search-calendar.depart_active


*** Keywords ***

Ouvrir l'annonce de test
    Go To    ${URL_ANNONCE_TEST}
    Wait Until Element Is Visible    ${BOUTON_DEMANDE_RESERVATION}

Ouvrir l'annonce de l'hôte de test
    Go To    ${URL_ANNONCE_HOTE_TEST}
    Wait Until Element Is Visible    ${BOUTON_DEMANDE_RESERVATION}

Demander une réservation
    Click Element    ${BOUTON_DEMANDE_RESERVATION}

La connexion doit être requise pour réserver
    Wait Until Page Contains    ${MESSAGE_LOGIN_REQUIS}

Choisir les dates de réservation
    [Arguments]    ${date_debut}    ${date_fin}
    ${date_debut_locator}=    Set Variable    css=.sidebar-booking-module.hidden-sm.hidden-xs #single-booking-search-calendar li[data-formatted-date="${date_debut}"]
    ${date_fin_locator}=      Set Variable    css=.sidebar-booking-module.hidden-sm.hidden-xs #single-booking-search-calendar li[data-formatted-date="${date_fin}"]
    Wait Until Keyword Succeeds    ${DELAI_ATTENTE}    500ms    Ouvrir le calendrier de la date d'arrivée
    Atteindre la date dans le calendrier    ${date_debut_locator}
    Click Element    ${date_debut_locator}
    Wait Until Keyword Succeeds    ${DELAI_ATTENTE}    500ms    Ouvrir le calendrier de la date de départ
    Atteindre la date dans le calendrier    ${date_fin_locator}
    Click Element    ${date_fin_locator}
    Wait Until Keyword Succeeds    ${DELAI_ATTENTE}    500ms    Element Should Be Enabled    ${BOUTON_DEMANDE_RESERVATION}

Choisir uniquement la date d'arrivée
    [Arguments]    ${date_debut}
    ${date_debut_locator}=    Set Variable    css=.sidebar-booking-module.hidden-sm.hidden-xs #single-booking-search-calendar li[data-formatted-date="${date_debut}"]
    Ouvrir le calendrier de la date d'arrivée
    Atteindre la date dans le calendrier    ${date_debut_locator}
    Click Element    ${date_debut_locator}
    Textfield Value Should Be    ${CHAMP_DATE_DEBUT}    ${date_debut}
    Textfield Value Should Be    ${CHAMP_DATE_FIN}    ${EMPTY}

Ouvrir le calendrier de la date d'arrivée
    Click Element    ${CHAMP_DATE_DEBUT}
    Element Should Be Visible    ${CALENDRIER_RESERVATION}

Ouvrir le calendrier de la date de départ
    Click Element    ${CHAMP_DATE_FIN}
    Element Should Be Visible    ${CALENDRIER_RESERVATION}

Atteindre la date dans le calendrier
    [Arguments]    ${date_locator}
    FOR    ${indice}    IN RANGE    ${NOMBRE_MAX_MOIS_CALENDRIER}
        ${date_est_visible}=    Run Keyword And Return Status    Element Should Be Visible    ${date_locator}
        Exit For Loop If    ${date_est_visible}
        Element Should Be Enabled    ${BOUTON_MOIS_SUIVANT}
        Click Element    ${BOUTON_MOIS_SUIVANT}
    END
    Element Should Be Visible    ${date_locator}

Choisir le nombre de voyageurs
    [Arguments]    ${nombre_voyageurs}
    Click Element    ${CHAMP_VOYAGEURS}
    Wait Until Element Is Visible    ${BOUTON_AJOUTER_ADULTE}
    FOR    ${indice}    IN RANGE    ${nombre_voyageurs}
        Click Element    ${BOUTON_AJOUTER_ADULTE}
    END
    Click Element    ${BOUTON_APPLIQUER_VOYAGEURS}
    Wait Until Keyword Succeeds    ${DELAI_ATTENTE}    500ms    Textfield Value Should Be    ${CHAMP_VOYAGEURS}    ${nombre_voyageurs}

Le champ de message à l'hôte doit être présent et obligatoire
    Page Should Contain Element    ${CHAMP_MESSAGE_HOTE}
    ${attribut_requis}=    Get Element Attribute    ${CHAMP_MESSAGE_HOTE}    required
    Should Be Equal    ${attribut_requis}    required

La date d'arrivée doit être choisie avant la date de départ
    [Arguments]    ${date}
    Ouvrir le calendrier de la date de départ
    ${date_locator}=    Set Variable    css=.sidebar-booking-module.hidden-sm.hidden-xs #single-booking-search-calendar li[data-formatted-date="${date}"]
    Atteindre la date dans le calendrier    ${date_locator}
    Click Element    ${date_locator}
    Textfield Value Should Be    ${CHAMP_DATE_DEBUT}    ${date}
    Textfield Value Should Be    ${CHAMP_DATE_FIN}    ${EMPTY}

Le calendrier doit empêcher la sélection d'une date passée
    Ouvrir le calendrier de la date d'arrivée
    ${classes_bouton_precedent}=    Get Element Attribute    ${BOUTON_MOIS_PRECEDENT}    class
    Should Contain    ${classes_bouton_precedent}    disabled

La réservation doit être refusée si la deuxième date est antérieure à la première
    [Arguments]    ${date_debut}    ${date_fin_invalide}
    Choisir uniquement la date d'arrivée    ${date_debut}
    Ouvrir le calendrier de la date de départ
    ${date_invalide_locator}=    Set Variable    css=.sidebar-booking-module.hidden-sm.hidden-xs #single-booking-search-calendar li[data-formatted-date="${date_fin_invalide}"]
    Atteindre la date dans le calendrier    ${date_invalide_locator}
    Click Element    ${date_invalide_locator}
    Wait Until Page Contains    ${MESSAGE_DATE_DEPART_INVALIDE}

La réservation doit être refusée sans date de fin
    Choisir uniquement la date d'arrivée    ${DATE_DEBUT_CONTROLE_VALIDATION}
    Element Should Be Visible    ${CALENDRIER_ATTENDANT_DEPART}

La réservation doit être refusée sans voyageur
    Choisir les dates de réservation    ${DATE_DEBUT_CONTROLE_VALIDATION}    ${DATE_FIN_CONTROLE_VALIDATION}
    Textfield Value Should Be    ${CHAMP_VOYAGEURS}    ${EMPTY}
    Demander une réservation
    Wait Until Page Contains    ${MESSAGE_VOYAGEURS_REQUIS}

Le nombre de voyageurs doit être saisi uniquement avec un nombre entier
    ${attribut_lecture_seule}=    Get Element Attribute    ${CHAMP_VOYAGEURS}    readonly
    Should Not Be Empty    ${attribut_lecture_seule}
    Choisir le nombre de voyageurs    ${NOMBRE_VOYAGEURS}

La réservation doit être confirmée
    Wait Until Page Contains    ${MESSAGE_RESERVATION_ENVOYEE}
