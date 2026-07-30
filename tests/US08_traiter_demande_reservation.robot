# ============================================================
# Projet de Fin de Bloc B - Homey
# US-08 - Traiter une demande de réservation
# ============================================================


*** Settings ***

Documentation       US-08 : L'hôte confirme une demande de réservation.

Resource            ../resources/variables.robot
Resource            ../resources/common_keywords.robot
Resource            ../resources/pages/page_annonce.robot
Resource            ../resources/pages/page_reservations_hote.robot

Test Setup          Ouvrir l'application
Test Teardown       Fermer l'application
Test Tags           US08    P2    reservation    hote


*** Test Cases ***

CAS NOMINAL - Un hôte doit pouvoir confirmer une demande de réservation
    [Documentation]    Vérifie qu'une demande envoyée par un voyageur passe au statut PAIEMENT EN ATTENTE après confirmation par l'hôte.
    [Tags]    connecte    happy_path
    Se connecter avec un compte valide    ${UTILISATEUR_LOGIN}    ${UTILISATEUR_PASSWORD}
    Ouvrir l'annonce de l'hôte de test
    Choisir les dates de réservation    ${DATE_DEBUT_US08}    ${DATE_FIN_US08}
    Choisir le nombre de voyageurs    ${NOMBRE_VOYAGEURS}
    Demander une réservation
    La réservation doit être confirmée
    Fermer l'application
    Ouvrir l'application
    Se connecter avec un compte valide    ${HOTE_LOGIN}    ${HOTE_PASSWORD}
    Ouvrir les réservations hôte
    Ouvrir la demande de réservation à confirmer    ${DATE_DEBUT_US08}
    Confirmer la disponibilité de la réservation
    Le statut de paiement en attente doit être affiché    ${DATE_DEBUT_US08}
