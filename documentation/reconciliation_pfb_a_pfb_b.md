# Réconciliation des tests manuels PFB A avec le PFB B

## Rôle du document

La vidéo Jira du PFB A conserve 17 cas de test manuels : 9 pour US07 et 8 pour US08. Les résultats affichés sont retenus comme actuels, car l'application Homey n'a pas évolué depuis cette campagne.

Ce tableau fait le lien entre chaque preuve manuelle et sa décision PFB B. Il évite deux erreurs fréquentes : oublier un cas PFB A ou prétendre qu'un scénario manuel est automatisé alors qu'il ne l'est pas.

| Référence Jira | Cas manuel PFB A | Résultat PFB A | Priorité | Décision PFB B |
| --- | --- | --- | --- | --- |
| HOMEY-5 | Demande complète avec tous les champs valides. | Échec | P1 | Automatisé dans `US07_demande_reservation.robot` : le champ message exigé est absent, écart rejoué et confirmé le 30/07/2026. |
| HOMEY-6 | Demande non transmise sans connexion. | Échec | P1 | Automatisé dans `US07_demande_reservation.robot`. |
| HOMEY-7 | Date de début vide. | Échec | P2 | Automatisé : arrivée imposée avant départ. |
| HOMEY-8 | Date de début passée. | Échec | P2 | Automatisé : la navigation vers le mois précédent est désactivée, ce qui empêche de sélectionner une date passée. |
| HOMEY-10 | Date de fin vide. | Échec initial | P2 | Revalidé pendant le PFB B : Homey bloque la demande avec un message de validation ; automatisé. |
| HOMEY-11 | Date de fin égale ou antérieure. | Échec initial | P2 | Revalidé pendant le PFB B : Homey bloque une deuxième date antérieure avec un message de validation ; automatisé. |
| HOMEY-13 | Nombre de voyageurs vide. | Échec initial | P2 | Revalidé pendant le PFB B : Homey bloque la demande avec le message voyageur requis ; automatisé. |
| HOMEY-14 | Nombre de voyageurs non entier. | Échec | P2 | Automatisé : l'interface interdit la saisie libre. |
| HOMEY-16 | Message à l'hôte vide. | Échec | P1 | Couvert avec HOMEY-5 par le contrôle du champ obligatoire absent, écart rejoué et confirmé le 30/07/2026. |
| HOMEY-23 | Réservation complète jusqu'à `RESERVE`. | Échec | P2 | Automatisé : création, confirmation, paiement et contrôle côté voyageur. L'interface affiche le statut sous la forme `RÉSERVÉ`. |
| HOMEY-25 | Paiement impossible sans profil hôte. | Échec | P1 | Automatisé, anomalie connue dans `US08_traiter_demande_reservation.robot`. Rejoué le 30/07/2026 : le bouton « Marquer comme payé » est visible sans profil de paiement ; l'écart est confirmé. |
| HOMEY-26 | Annulation directe. | Conforme | P3 | Conservé en manuel : état `NOUVEAU` et nettoyage des données requis. |
| HOMEY-27 | Annulation avant paiement. | Conforme | P3 | Conservé en manuel : état `PAIEMENT EN ATTENTE` requis. |
| HOMEY-28 | Annulation après réservation. | Conforme | P3 | Conservé en manuel : parcours complet jusqu'à `RESERVE` requis. |
| HOMEY-29 | Refus direct avec motif. | Conforme | P3 | Conservé en manuel : état `NOUVEAU`, motif et vérification sur deux espaces. |
| HOMEY-30 | Refus avant paiement. | Conforme | P3 | Conservé en manuel : état `PAIEMENT EN ATTENTE` requis. |
| HOMEY-31 | Création d'un profil de paiement. | Conforme | P2 | Automatisé dans `US08_traiter_demande_reservation.robot`, rejoué avec succès le 30/07/2026. |

## Traduction d'un cas manuel dans Robot Framework

| Question du cahier des charges | Mise en œuvre dans le projet |
| --- | --- |
| Quelle est la précondition ? | `Test Setup`, connexion avec le compte concerné, profil de paiement et annonce de test lorsque nécessaire. |
| Quelles sont les actions ? | Mots-clés des Page Objects : `page_annonce.robot`, `page_reservations.robot` et `page_profil_paiement.robot`. |
| Quel est le résultat attendu ? | Assertions Robot visibles : champ présent, date indisponible, statut, bouton absent ou connexion obligatoire. |
| Quel est le contexte de données ? | Variables centralisées dans `resources/variables.robot`. |

## Limite assumée

Les annulations et refus restent des cas P3 manuels. Ils ne sont pas exclus de la couverture fonctionnelle : ils sont tracés, disposent d'un résultat PFB A et correspondent aux cinq branches terminales du schéma de réservation. Leur automatisation demanderait de créer puis de nettoyer de nombreuses réservations dans différents statuts, sans mécanisme de remise à zéro de l'environnement.
