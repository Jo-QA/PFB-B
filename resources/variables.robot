# ============================================================
# Projet de Fin de Bloc B — Homey
# Données de test centralisées
# ============================================================

*** Variables ***

# ------------------------------------------------------------
# Configuration générale
# ------------------------------------------------------------

${URL}                        http://livraison3.testacademy.fr/
${NAVIGATEUR}                 chrome
${DELAI_ATTENTE}              10s
${ENVIRONNEMENT_EXECUTION}    %{ENVIRONNEMENT_EXECUTION=LOCAL}

# Empêche les alertes Chrome liées au gestionnaire de mots de passe.
# Ces réglages s'appliquent uniquement au navigateur lancé par Selenium.
${OPTIONS_CHROME_TEST}        add_experimental_option('prefs', {'credentials_enable_service': False, 'profile.password_manager_enabled': False, 'profile.password_manager_leak_detection': False})
${OPTIONS_CHROME_CI}          add_argument("--headless=new"); add_argument("--window-size=1920,1080"); add_experimental_option('prefs', {'credentials_enable_service': False, 'profile.password_manager_enabled': False, 'profile.password_manager_leak_detection': False})

# ------------------------------------------------------------
# Comptes de test
# ------------------------------------------------------------

${UTILISATEUR_LOGIN}          robot
${UTILISATEUR_PASSWORD}       robot
${HOTE_LOGIN}                 HoteID1
${HOTE_PASSWORD}              HoteMDP1

# ------------------------------------------------------------
# Données de l'annonce de test
# ------------------------------------------------------------

${URL_ANNONCE_HOTE_TEST}      http://livraison3.testacademy.fr/index.php/listing/maison-de-test-place-de-letoile-paris/
${URL_ANNONCE_TEST}           ${URL_ANNONCE_HOTE_TEST}

# ------------------------------------------------------------
# Données de réservation
# ------------------------------------------------------------

# Le calendrier Homey attend les dates au format AAAA-MM-JJ.
# Les parcours qui créent une demande utilisent des séjours distincts de trois nuits.
${DATE_DEBUT_CONFIRMATION_HOTE}        2026-11-10
${DATE_FIN_CONFIRMATION_HOTE}          2026-11-13
${DATE_DEBUT_SECURITE_PAIEMENT}        2026-12-20
${DATE_FIN_SECURITE_PAIEMENT}          2026-12-23
${DUREE_SEJOUR_P2}                     3
${DELAI_MINIMUM_AVANT_SEJOUR_P2}       2
${DATE_DEBUT_CONTROLE_VALIDATION}      2026-10-10
${DATE_FIN_AVANT_DEBUT_CONTROLE}       2026-10-09
${DATE_FIN_CONTROLE_VALIDATION}        2026-10-12
${NOMBRE_VOYAGEURS}                    2
${IBAN_TEST}                           FR7612345678901234567890123
${SWIFT_TEST}                          TESTFRPPXXX
${NOM_BANQUE_TEST}                     Banque de test

# ------------------------------------------------------------
# Messages et statuts attendus
# ------------------------------------------------------------

${MESSAGE_RESERVATION_ENVOYEE}         Demande de réservation envoyée.
${MESSAGE_DATE_DEPART_INVALIDE}        La date de départ doit être supérieure à la date d'arrivée
${MESSAGE_VOYAGEURS_REQUIS}            Veuillez choisir des voyageurs
${MESSAGE_DISPONIBILITE_CONFIRMEE}     Vous avez confirmé la disponibilité pour cette réservation.
${STATUT_PAIEMENT_EN_ATTENTE}          PAIEMENT EN ATTENTE
${STATUT_RESERVE}                      RÉSERVÉ
