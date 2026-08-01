# ============================================================
# Projet de Fin de Bloc B — Homey
# Page Object — Profil de paiement
# ============================================================

*** Settings ***

Library     SeleniumLibrary

Resource    ../variables.robot

*** Variables ***

${URL_PROFIL_PAIEMENT}                ${URL}index.php/profile/?dpage=payment-method
${OPTION_VIREMENT_BANCAIRE}           xpath=//label[contains(@class, "radio-tab") and .//input[@name="payout_method" and @value="wire"]]
${BLOC_VIREMENT_BANCAIRE}             css=#wire_transfer
${CHAMP_IBAN}                          css=#bank_account
${CHAMP_SWIFT}                         css=#swift
${CHAMP_NOM_BANQUE}                    css=#bank_name
${BOUTON_ENREGISTRER_VIREMENT}        css=#wire_transfer .homey_save_payout_method

*** Keywords ***

Ouvrir le profil de paiement
    Go To    ${URL_PROFIL_PAIEMENT}
    Wait Until Element Is Visible    ${OPTION_VIREMENT_BANCAIRE}

Configurer un virement bancaire de test
    Click Element    ${OPTION_VIREMENT_BANCAIRE}
    Wait Until Element Is Visible    ${BLOC_VIREMENT_BANCAIRE}
    Input Text    ${CHAMP_IBAN}        ${IBAN_TEST}
    Input Text    ${CHAMP_SWIFT}       ${SWIFT_TEST}
    Input Text    ${CHAMP_NOM_BANQUE}  ${NOM_BANQUE_TEST}
    Click Element    ${BOUTON_ENREGISTRER_VIREMENT}
    Wait Until Element Is Visible    ${BLOC_VIREMENT_BANCAIRE}

Les champs du virement bancaire doivent être affichés
    Element Should Be Visible    ${CHAMP_IBAN}
    Element Should Be Visible    ${CHAMP_SWIFT}
    Element Should Be Visible    ${CHAMP_NOM_BANQUE}
