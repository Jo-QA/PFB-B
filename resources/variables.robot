# ============================================================
# Projet de Fin de Bloc B - Homey
# Variables globales
# ============================================================


*** Variables ***

# ------------------------------------------------------------
# Configuration générale
# ------------------------------------------------------------

${URL}              http://livraison3.testacademy.fr/
${NAVIGATEUR}       chrome
${DELAI_ATTENTE}    10s
${ENVIRONNEMENT_EXECUTION}    %{ENVIRONNEMENT_EXECUTION=LOCAL}
# Le navigateur de test ne doit pas afficher les alertes du gestionnaire de mots de passe.
# Ces préférences ne s'appliquent qu'à la session Chrome lancée par Selenium.
${OPTIONS_CHROME_TEST}    add_experimental_option('prefs', {'credentials_enable_service': False, 'profile.password_manager_enabled': False, 'profile.password_manager_leak_detection': False})
${OPTIONS_CHROME_CI}      add_argument("--headless=new"); add_argument("--window-size=1920,1080"); add_experimental_option('prefs', {'credentials_enable_service': False, 'profile.password_manager_enabled': False, 'profile.password_manager_leak_detection': False})


# ------------------------------------------------------------
# Comptes de test
# ------------------------------------------------------------

${UTILISATEUR_LOGIN}       robot
${UTILISATEUR_PASSWORD}    robot
${HOTE_LOGIN}              HoteID1
${HOTE_PASSWORD}           HoteMDP1


# ------------------------------------------------------------
# Données d'annonce
# ------------------------------------------------------------

${URL_ANNONCE_HOTE_TEST}    http://livraison3.testacademy.fr/index.php/listing/maison-de-test-place-de-letoile-paris/
${URL_ANNONCE_TEST}         ${URL_ANNONCE_HOTE_TEST}


# ------------------------------------------------------------
# Données de réservation
# ------------------------------------------------------------

# Le calendrier Homey expose les dates au format AAAA-MM-JJ.
# Les deux parcours qui créent une demande utilisent des séjours distincts de trois nuits.
${DATE_DEBUT_CONFIRMATION_HOTE}             2026-11-10
${DATE_FIN_CONFIRMATION_HOTE}               2026-11-13
${DATE_DEBUT_SECURITE_PAIEMENT}             2026-12-20
${DATE_FIN_SECURITE_PAIEMENT}               2026-12-23
# Créneau validé lors de la campagne P2. Recréer l'annonce de test avant de le rejouer.
${DATE_DEBUT_PARCOURS_COMPLET}               2026-12-15
${DATE_FIN_PARCOURS_COMPLET}                 2026-12-18
${DATE_DEBUT_CONTROLE_VALIDATION}            2026-10-10
${DATE_FIN_AVANT_DEBUT_CONTROLE}             2026-10-09
${DATE_FIN_CONTROLE_VALIDATION}              2026-10-12
${NOMBRE_VOYAGEURS}                         2
${IBAN_TEST}                                FR7612345678901234567890123
${SWIFT_TEST}                               TESTFRPPXXX
${NOM_BANQUE_TEST}                          Banque de test


# ------------------------------------------------------------
# Messages attendus
# ------------------------------------------------------------

${MESSAGE_RESERVATION_ENVOYEE}    Demande de réservation envoyée.
${MESSAGE_DATE_DEPART_INVALIDE}    La date de départ doit être supérieure à la date d'arrivée
${MESSAGE_VOYAGEURS_REQUIS}    Veuillez choisir des voyageurs
${MESSAGE_DISPONIBILITE_CONFIRMEE}    Vous avez confirmé la disponibilité pour cette réservation.
${STATUT_PAIEMENT_EN_ATTENTE}    PAIEMENT EN ATTENTE
${STATUT_RESERVE}                RÉSERVÉ
