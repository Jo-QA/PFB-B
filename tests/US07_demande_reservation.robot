# ============================================================
# Projet de Fin de Bloc B - Homey
# US-07 - Demande de réservation
# ============================================================


*** Settings ***

Documentation       US-07 : Faire une demande de réservation.

Resource            ../resources/variables.robot
Resource            ../resources/common_keywords.robot
Resource            ../resources/pages/page_annonce.robot
Resource            ../resources/pages/page_dashboard_voyageur.robot

Test Setup          Ouvrir l'application
Test Teardown       Fermer l'application
Test Tags           US07    P1    reservation


*** Test Cases ***

CAS NOMINAL - Un voyageur connecté doit pouvoir demander une réservation
    [Documentation]    Vérifie qu'un voyageur connecté peut envoyer une demande pour des dates disponibles.
    [Tags]    connecte    happy_path
    Se connecter avec un compte valide    ${UTILISATEUR_LOGIN}    ${UTILISATEUR_PASSWORD}
    Le tableau de bord voyageur doit être affiché
    Ouvrir l'annonce de test
    Choisir les dates de réservation    ${DATE_DEBUT}    ${DATE_FIN}
    Choisir le nombre de voyageurs    ${NOMBRE_VOYAGEURS}
    Demander une réservation
    La réservation doit être confirmée

CAS BLOQUANT - Un visiteur non connecté doit être invité à se connecter
    [Documentation]    Vérifie que la demande de réservation est protégée par une authentification.
    [Tags]    non_connecte    unhappy_path
    Ouvrir l'annonce de test
    Demander une réservation
    La connexion doit être requise pour réserver
