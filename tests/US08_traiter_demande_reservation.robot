# ============================================================
# Projet de Fin de Bloc B — Homey
# US08 — Traiter une demande de réservation
# ============================================================

*** Settings ***

Documentation     Vérifie le traitement d'une demande par l'hôte, du profil de paiement au statut final.

Resource          ../resources/variables.robot
Resource          ../resources/common_keywords.robot
Resource          ../resources/pages/page_annonce.robot
Resource          ../resources/pages/page_profil_paiement.robot
Resource          ../resources/pages/page_reservations.robot

Test Setup        Ouvrir l'application
Test Teardown     Fermer l'application
Test Tags         US08    reservation    hote

*** Test Cases ***

P1 - Le paiement doit être bloqué sans profil de paiement hôte
    [Documentation]    US08-CT08 / HOMEY-25 et HOMEY-38. Précondition : HoteID1 ne possède pas de profil de paiement.
    [Tags]    P1    anomalie_connue    etat_mutable
    Se connecter avec un compte valide    ${UTILISATEUR_LOGIN}    ${UTILISATEUR_PASSWORD}
    Ouvrir l'annonce de l'hôte de test
    Choisir les dates de réservation    ${DATE_DEBUT_SECURITE_PAIEMENT}    ${DATE_FIN_SECURITE_PAIEMENT}
    Choisir le nombre de voyageurs    ${NOMBRE_VOYAGEURS}
    Demander une réservation
    La réservation doit être confirmée
    Fermer l'application
    Ouvrir l'application
    Se connecter avec un compte valide    ${HOTE_LOGIN}    ${HOTE_PASSWORD}
    Ouvrir la demande de réservation à confirmer    ${DATE_DEBUT_SECURITE_PAIEMENT}
    Confirmer la disponibilité de la réservation
    Ouvrir le détail d'une réservation au paiement en attente    ${DATE_DEBUT_SECURITE_PAIEMENT}
    Le paiement doit être bloqué sans profil hôte

P2 - L'hôte doit pouvoir configurer un virement bancaire de test
    [Documentation]    US08-CT07 / HOMEY-31. Le formulaire s'affiche après le choix du virement et les données fictives sont enregistrées.
    [Tags]    P2    profil_paiement    etat_mutable
    Se connecter avec un compte valide    ${HOTE_LOGIN}    ${HOTE_PASSWORD}
    Ouvrir le profil de paiement
    Configurer un virement bancaire de test
    Les champs du virement bancaire doivent être affichés

P2 - Une réservation doit atteindre le statut réservé après paiement
    [Documentation]    US08-CT01 / HOMEY-23. Le parcours passe de NOUVEAU à PAIEMENT EN ATTENTE, puis à RÉSERVÉ après le paiement.
    [Tags]    P2    connecte    happy_path    etat_mutable
    Se connecter avec un compte valide    ${UTILISATEUR_LOGIN}    ${UTILISATEUR_PASSWORD}
    Ouvrir l'annonce de l'hôte de test
    Choisir les dates de réservation    ${DATE_DEBUT_PARCOURS_COMPLET}    ${DATE_FIN_PARCOURS_COMPLET}
    Choisir le nombre de voyageurs    ${NOMBRE_VOYAGEURS}
    Demander une réservation
    La réservation doit être confirmée
    Fermer l'application
    Ouvrir l'application
    Se connecter avec un compte valide    ${HOTE_LOGIN}    ${HOTE_PASSWORD}
    Ouvrir le profil de paiement
    Configurer un virement bancaire de test
    Ouvrir la demande de réservation à confirmer    ${DATE_DEBUT_PARCOURS_COMPLET}
    Confirmer la disponibilité de la réservation
    Le statut de paiement en attente doit être affiché    ${DATE_DEBUT_PARCOURS_COMPLET}
    Ouvrir le détail d'une réservation au paiement en attente    ${DATE_DEBUT_PARCOURS_COMPLET}
    Marquer la réservation comme payée
    Le statut réservé doit être affiché    ${DATE_DEBUT_PARCOURS_COMPLET}
    Fermer l'application
    Ouvrir l'application
    Se connecter avec un compte valide    ${UTILISATEUR_LOGIN}    ${UTILISATEUR_PASSWORD}
    Le statut réservé doit être affiché    ${DATE_DEBUT_PARCOURS_COMPLET}
