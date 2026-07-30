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
${DATE_DEBUT}              2026-10-20
${DATE_FIN}                2026-10-22
${DATE_DEBUT_US08}         2026-11-05
${DATE_FIN_US08}           2026-11-07
${NOMBRE_VOYAGEURS}        2
${MESSAGE_RESERVATION}     Bonjour, je souhaite réserver ce logement.


# ------------------------------------------------------------
# Messages attendus
# ------------------------------------------------------------

${MESSAGE_RESERVATION_ENVOYEE}    Demande de réservation envoyée.
${MESSAGE_DISPONIBILITE_CONFIRMEE}    Vous avez confirmé la disponibilité pour cette réservation.
${STATUT_PAIEMENT_EN_ATTENTE}    PAIEMENT EN ATTENTE
