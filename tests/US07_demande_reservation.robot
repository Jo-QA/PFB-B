# ============================================================
# Projet de Fin de Bloc B - Homey
# US-07 - Demande de réservation
# ============================================================


*** Settings ***

Documentation       US-07 : Faire une demande de réservation.

Resource            ../resources/variables.robot
Resource            ../resources/common_keywords.robot
Resource            ../resources/pages/page_annonce.robot

Test Setup          Ouvrir l'application
Test Teardown       Fermer l'application
Test Tags           US07    reservation


*** Test Cases ***

P1 - Le formulaire de demande doit comporter un message obligatoire à l'hôte
    [Documentation]    US07-CT01 et CT09 / HOMEY-5, HOMEY-16, HOMEY-34 et HOMEY-35. Les deux cas sont couverts par le même contrôle : le champ message doit exister et être obligatoire.
    [Tags]    P1    anomalie_connue
    Se connecter avec un compte valide    ${UTILISATEUR_LOGIN}    ${UTILISATEUR_PASSWORD}
    Ouvrir l'annonce de test
    Le champ de message à l'hôte doit être présent et obligatoire

P1 - Un visiteur non connecté doit être invité à se connecter
    [Documentation]    US07-CT02 / HOMEY-6. Le contrôle d'accès est un scénario de sécurité prioritaire et stable.
    [Tags]    P1    non_connecte    unhappy_path
    Ouvrir l'annonce de test
    Demander une réservation
    La connexion doit être requise pour réserver

P2 - Le premier jour choisi doit devenir la date d'arrivée
    [Documentation]    US07-CT03 / HOMEY-7. Quel que soit le champ utilisé pour ouvrir le calendrier, le premier jour choisi est la date d'arrivée.
    [Tags]    P2    validation
    Se connecter avec un compte valide    ${UTILISATEUR_LOGIN}    ${UTILISATEUR_PASSWORD}
    Ouvrir l'annonce de test
    La date d'arrivée doit être choisie avant la date de départ    ${DATE_DEBUT_CONTROLE_VALIDATION}

P2 - Une date passée ne doit pas être réservable
    [Documentation]    US07-CT04 / HOMEY-8. Le calendrier doit rendre les jours passés indisponibles.
    [Tags]    P2    validation
    Se connecter avec un compte valide    ${UTILISATEUR_LOGIN}    ${UTILISATEUR_PASSWORD}
    Ouvrir l'annonce de test
    Le calendrier doit empêcher la sélection d'une date passée

P2 - La date de fin est obligatoire avant une demande
    [Documentation]    US07-CT05 / HOMEY-10. Sans deuxième date, Homey conserve le calendrier dans l'état d'attente de départ. Le message de validation associé est vérifié manuellement.
    [Tags]    P2    validation
    Se connecter avec un compte valide    ${UTILISATEUR_LOGIN}    ${UTILISATEUR_PASSWORD}
    Ouvrir l'annonce de test
    La réservation doit être refusée sans date de fin

P2 - La date de fin doit être postérieure à la date d'arrivée
    [Documentation]    US07-CT06 / HOMEY-11. La deuxième date choisie est la date de départ ; Homey doit la refuser si elle précède la première.
    [Tags]    P2    validation
    Se connecter avec un compte valide    ${UTILISATEUR_LOGIN}    ${UTILISATEUR_PASSWORD}
    Ouvrir l'annonce de test
    La réservation doit être refusée si la deuxième date est antérieure à la première    ${DATE_DEBUT_CONTROLE_VALIDATION}    ${DATE_FIN_AVANT_DEBUT_CONTROLE}

P2 - Un nombre de voyageurs est obligatoire avant une demande
    [Documentation]    US07-CT07 / HOMEY-13. Sans voyageur, Homey doit refuser la demande et afficher le message métier prévu.
    [Tags]    P2    validation
    Se connecter avec un compte valide    ${UTILISATEUR_LOGIN}    ${UTILISATEUR_PASSWORD}
    Ouvrir l'annonce de test
    La réservation doit être refusée sans voyageur

P2 - Le nombre de voyageurs doit être un entier
    [Documentation]    US07-CT08 / HOMEY-14. L'interface doit empêcher la saisie libre d'une valeur non entière.
    [Tags]    P2    validation
    Se connecter avec un compte valide    ${UTILISATEUR_LOGIN}    ${UTILISATEUR_PASSWORD}
    Ouvrir l'annonce de test
    Le nombre de voyageurs doit être saisi uniquement avec un nombre entier
