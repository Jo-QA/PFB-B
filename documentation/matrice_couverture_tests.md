# Matrice de couverture et stratégie P1 / P2 / P3

## Objectif

Cette matrice reprend les 17 cas réalisés manuellement dans le PFB A. Elle explique, pour chacun, sa priorité et son traitement dans le PFB B : automatisation Robot Framework ou conservation comme preuve manuelle.

Le but n'est pas de transformer mécaniquement chaque ligne Jira en script. Le choix repose sur le risque métier, le coût de préparation des données et la maintenance future. Homey n'ayant pas changé depuis le PFB A, les résultats manuels Jira sont retenus comme état de référence.

> Un fichier Robot par User Story ne limite pas le nombre de cas de test : `tests/US07_demande_reservation.robot` contient plusieurs scénarios US07, et `tests/US08_traiter_demande_reservation.robot` plusieurs scénarios US08.

## Stratégie retenue

| Priorité | Règle appliquée | Décision d'exécution |
| --- | --- | --- |
| P1 | Risque fort sur une exigence obligatoire, le contrôle d'accès ou la sécurité du paiement. | Automatisé systématiquement. Une anomalie connue reste automatisée, mais est isolée du pipeline vert. |
| P2 | Règle de validation ou parcours métier utile dont l'automatisation est simple et durable. | Automatisé. Les scénarios qui créent une réservation ou enregistrent un profil sont lancés volontairement avec des données de test préparées. |
| P3 | Branche de réservation imposant de créer et de nettoyer plusieurs statuts intermédiaires. | Conservé en manuel : la preuve PFB A reste traçable. Le coût de maintenance est supérieur au bénéfice dans ce périmètre. |

## US07 — Faire une demande de réservation

| ID | Cas issu du PFB A | Priorité | Choix PFB B | Justification |
| --- | --- | --- | --- | --- |
| CT01 | Demande complète avec message à l'hôte. | P1 | Automatisé, anomalie connue. | Le message est une exigence du cahier des charges. Le test vérifie que le champ existe et est obligatoire. |
| CT02 | Visiteur non connecté. | P1 | Automatisé dans Jenkins. | Contrôle d'accès critique, stable et sans donnée persistante. |
| CT03 | Date de début vide. | P2 | Automatisé. | Le calendrier doit imposer l'arrivée avant le départ ; le contrôle est simple et sans réservation créée. |
| CT04 | Date de début passée. | P2 | Automatisé. | Une date passée doit être indisponible dans le calendrier. |
| CT05 | Date de fin vide. | P2 | Automatisé + preuve manuelle. | Le script vérifie l'état « attente de départ » du calendrier ; le message de validation est confirmé manuellement, car le calendrier recouvre le bouton tant qu'une deuxième date est attendue. |
| CT06 | Date de fin égale ou antérieure au début. | P2 | Automatisé. | La deuxième date choisie est la date de départ ; Homey doit refuser un séjour de durée négative. |
| CT07 | Nombre de voyageurs vide. | P2 | Automatisé. | Homey doit refuser la demande et afficher le message indiquant qu'un voyageur est requis. |
| CT08 | Nombre de voyageurs non entier. | P2 | Automatisé. | L'interface doit empêcher la saisie libre et ne permettre que des valeurs entières. |
| CT09 | Message à l'hôte vide. | P1 | Couvert avec CT01, anomalie connue. | Sans champ message, on ne peut pas tester séparément la valeur vide. Le même contrôle P1 couvre l'existence et le caractère obligatoire du champ. |

Les neuf cas US07 sont donc couverts par huit scénarios Robot : CT01 et CT09 partagent volontairement le même contrôle, car ils dépendent de l'absence du même champ.

## US08 — Traiter une demande de réservation

| ID | Cas issu du PFB A | Priorité | Choix PFB B | Justification |
| --- | --- | --- | --- | --- |
| CT01 | Parcours nominal complet jusqu'au statut `RESERVE`. | P2 | Automatisé. | Le script vérifie les transitions `NOUVEAU` → `PAIEMENT EN ATTENTE` → `RESERVE` ; l'interface affiche ce dernier statut sous la forme `RÉSERVÉ`, côté hôte et voyageur. |
| CT02 | Annulation directe. | P3 | Manuel. | La branche nécessite une demande au statut `NOUVEAU`, une action voyageur et le contrôle sur deux espaces. |
| CT03 | Refus direct avec motif. | P3 | Manuel. | Même état initial que CT02, avec en plus le motif de refus à préparer et à contrôler. |
| CT04 | Annulation avant paiement. | P3 | Manuel. | Préparation d'une demande confirmée mais non payée ; données persistantes et remise à zéro coûteuse. |
| CT05 | Refus avant paiement. | P3 | Manuel. | Même coût de préparation que CT04, pour une branche terminale différente. |
| CT06 | Annulation après réservation. | P3 | Manuel. | Nécessite un séjour passé par toutes les transitions, puis une remise à zéro complète des données. |
| CT07 | Création d'un profil de paiement par virement. | P2 | Automatisé. | Le formulaire est stable et c'est une précondition du parcours nominal complet. Rejoué le 30/07/2026 : conforme. |
| CT08 | Paiement impossible sans profil hôte. | P1 | Automatisé, anomalie connue. | Risque de sécurité fonctionnelle : un paiement ne doit jamais être validé sans profil de paiement. Rejoué le 30/07/2026 : échec fonctionnel confirmé, le bouton « Marquer comme payé » reste visible sans profil hôte. |

Les cinq cas P3 restent dans le plan de test manuel. Ainsi, tous les chemins du schéma US08 sont couverts dans le projet, mais seuls les parcours dont le rapport valeur / maintenance est favorable sont automatisés.

## Anomalies connues et données de test

| Référence | Écart au cahier des charges | Traitement Robot |
| --- | --- | --- |
| HOMEY-34 / HOMEY-35 | Champ de message absent ; une demande peut donc être envoyée sans message. | Test P1 `anomalie_connue`, rejoué le 30/07/2026 : absence du champ confirmée. |
| HOMEY-38 | L'hôte peut marquer le paiement comme reçu sans profil bancaire. | Test P1 `anomalie_connue`, rejoué le 30/07/2026 : anomalie confirmée. |

Le test de sécurité du paiement doit être lancé avant le parcours nominal P2, car ce dernier enregistre un profil bancaire fictif pour `HoteID1`. Cette contrainte est normale : sans API ou remise à zéro de base de données, l'environnement ne peut pas isoler automatiquement ce type de donnée persistante.

## Jenkins et exécution

1. Jenkins exécute à chaque mise à jour les P1 non marqués `anomalie_connue` : smoke connexion et contrôle d'accès US07.
2. Le paramètre `EXECUTER_TESTS_P2` ajoute les contrôles P2 verts et les scénarios P2 à données persistantes.
3. Les anomalies connues sont exécutables séparément pour démontrer les défauts, sans faire échouer le pipeline quotidien.
4. Les P3 sont rejoués manuellement à partir des preuves Jira du PFB A lorsque l'on souhaite revoir une branche d'annulation ou de refus.

## Bilan de couverture

| Élément | Nombre |
| --- | ---: |
| Cas manuels PFB A analysés | 17 |
| Cas manuels P1 sélectionnés à l'automatisation | 4 |
| Cas manuels P2 sélectionnés à l'automatisation | 8 |
| Cas manuels P3 conservés en manuel | 5 |
| Scénarios Robot métier | 11 |
| Fichiers de test, un par User Story | 2 |

La différence entre 12 cas manuels sélectionnés et 11 scénarios Robot est volontaire : CT01 et CT09 US07 sont couverts par le même contrôle du champ message obligatoire.

La justification détaillée de chaque référence Jira est disponible dans [la réconciliation PFB A / PFB B](reconciliation_pfb_a_pfb_b.md).
