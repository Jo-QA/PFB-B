# Matrice de couverture fonctionnelle - Homey

## Objectif du document

Cette matrice relie les exigences des User Stories US07 et US08 aux cas de test à exécuter. Elle est le point de départ de la démarche QA : **analyse des exigences, tests manuels, puis automatisation des scénarios stables et pertinents**.

Le périmètre minimal du Projet de Fin de Bloc B est conservé :

- US07 : un cas nominal et au moins un cas d'exception automatisés ;
- US08 : le cas nominal automatisé.

La présente matrice va volontairement plus loin pour couvrir les chemins métier et détecter les écarts au cahier des charges. Les cas supplémentaires sont d'abord exécutés manuellement, puis automatisés lorsqu'ils sont stables et reproductibles.

## Légende

| Statut de couverture | Signification |
| --- | --- |
| Automatisé (CI) | Scénario déjà automatisé et exécuté dans le pipeline Jenkins. |
| À exécuter manuellement | Cas conçu, mais dont le résultat réel Homey doit encore être observé et tracé. |
| À automatiser | Cas manuel validé, prioritaire pour une future automatisation. |
| Anomalie à reproduire (hors CI) | Exigence testable pour laquelle un écart est déjà suspecté. Le test est lancé séparément afin de ne pas faire échouer durablement la régression Jenkins. |
| À confirmer | Le chemin ou le libellé exact doit être vérifié dans Homey avant de figer le test. |

> Un test non exécuté n'est ni un succès ni un échec. Il reste « à exécuter manuellement » jusqu'à l'observation de son résultat réel.

## US07 - Faire une demande de réservation

### Table de décision

| ID | Compte | Date d'arrivée | Date de départ | Voyageurs | Message à l'hôte | Résultat attendu selon l'US | Couverture actuelle |
| --- | --- | --- | --- | --- | --- | --- | --- |
| US07-CT01 | Connecté | Valide | Valide et postérieure | Entier valide | Valide | La demande est envoyée. | Automatisé (CI) |
| US07-CT02 | Non connecté | Valide | Valide et postérieure | Entier valide | Valide | La demande est refusée et la connexion est demandée. | Automatisé (CI) |
| US07-CT03 | Connecté | Vide | Valide | Entier valide | Valide | La demande est refusée ; une date d'arrivée est requise. | À exécuter manuellement |
| US07-CT04 | Connecté | Aujourd'hui ou date passée | Valide | Entier valide | Valide | La demande est refusée ; une arrivée passée ou le jour même est interdite. | À exécuter manuellement |
| US07-CT05 | Connecté | Valide | Vide | Entier valide | Valide | La demande est refusée ; une date de départ est requise. | À exécuter manuellement |
| US07-CT06 | Connecté | Valide | Égale ou antérieure à l'arrivée | Entier valide | Valide | La demande est refusée ; le départ doit être postérieur à l'arrivée. | À exécuter manuellement |
| US07-CT07 | Connecté | Valide | Valide et postérieure | Vide | Valide | La demande est refusée ; un nombre de voyageurs valide est requis. | À exécuter manuellement |
| US07-CT08 | Connecté | Valide | Valide et postérieure | Valeur non entière | Valide | La saisie non entière est refusée ou impossible par l'interface. | À confirmer |
| US07-CT09 | Connecté | Valide | Valide et postérieure | Entier valide | Vide | La demande est refusée ; le message obligatoire doit être signalé. | Anomalie à reproduire (hors CI) |

### Points de contrôle US07

- Le champ de message est une exigence métier. Son absence dans Homey ne rend pas le cas non testable : elle constitue un écart au cahier des charges si l'utilisateur peut réserver sans saisir de message.
- Le cas US07-CT09 doit vérifier deux attentes distinctes : le champ existe et il est obligatoire. Dans le projet A, ces deux écarts avaient été séparés en deux défauts ; la même séparation sera conservée si elle est constatée à nouveau.
- Pour US07-CT08, il ne faut pas modifier artificiellement le HTML de l'application. Le test doit vérifier le comportement d'un utilisateur normal : champ numérique, boutons `+` / `-`, valeur minimale et impossibilité éventuelle de saisir une décimale ou du texte.

## US08 - Traiter une demande de réservation

### Matrice des statuts et des chemins métier

| ID | Statut initial | Acteur | Action | Statut attendu hôte | Statut attendu voyageur | Couverture actuelle |
| --- | --- | --- | --- | --- | --- | --- |
| US08-CT01 | NOUVEAU | Hôte | Confirmer la disponibilité | Paiement en attente | Disponible / paiement attendu | Automatisé (CI) |
| US08-CT02 | NOUVEAU | Hôte | Refuser avec un motif | REFUSÉ | REFUSÉ ; motif visible si exigé | À exécuter manuellement |
| US08-CT03 | NOUVEAU | Voyageur | Annuler la demande | ANNULÉ | ANNULÉ | À exécuter manuellement |
| US08-CT04 | Paiement en attente | Voyageur | Annuler avant paiement | ANNULÉ | ANNULÉ | À exécuter manuellement |
| US08-CT05 | Paiement en attente | Hôte | Refuser avant paiement | REFUSÉ | REFUSÉ | À exécuter manuellement |
| US08-CT06 | Paiement en attente | Voyageur | Payer / marquer comme payé | RÉSERVÉ | RÉSERVÉ | À exécuter manuellement |
| US08-CT07 | RÉSERVÉ | Voyageur | Annuler après paiement | ANNULÉ | ANNULÉ | À exécuter manuellement |
| US08-CT08 | Hôte connecté | Hôte | Créer ou modifier le profil de paiement | Profil enregistré ; sous-formulaire bancaire affiché selon le mode choisi | Sans objet | À exécuter manuellement |
| US08-CT09 | Paiement en attente, hôte sans profil de paiement | Voyageur | Tenter de payer | Paiement bloqué et message explicite | Paiement impossible | Anomalie à reproduire (hors CI) |

### Correspondance avec le schéma fonctionnel

```text
Demande du voyageur
        ↓
     NOUVEAU
     ├── voyageur annule ───────────────→ ANNULÉ       (US08-CT03)
     ├── hôte refuse ───────────────────→ REFUSÉ       (US08-CT02)
     └── hôte confirme ─────→ PAIEMENT EN ATTENTE      (US08-CT01)
                               ├── voyageur annule ───→ ANNULÉ (US08-CT04)
                               ├── hôte refuse ───────→ REFUSÉ (US08-CT05)
                               └── voyageur paie ─────→ RÉSERVÉ (US08-CT06)
                                                          └── voyageur annule → ANNULÉ (US08-CT07)
```

Le libellé actuellement observé dans Homey est `PAIEMENT EN ATTENTE`. Les exigences et la présentation A utilisent aussi l'expression `ATTENTE DE PAIEMENT`. Le test doit valider le **sens métier du statut**, puis utiliser le libellé réellement affiché par Homey dans ses assertions automatisées.

### Paiement et profil hôte

Les cas US08-CT08 et US08-CT09 font partie de la couverture fonctionnelle car le paiement est une condition de la transition vers `RÉSERVÉ`.

- Les données bancaires utilisées en test seront fictives et dédiées à l'environnement de formation ; aucune donnée bancaire personnelle ne sera saisie.
- US08-CT09 est un test de sécurité fonctionnelle : un hôte sans moyen de paiement configuré ne doit pas pouvoir recevoir un paiement.
- Dans le projet A, ce défaut avait été identifié comme critique. Dans le projet B, il devra être **reproduit** avant d'être déclaré à nouveau en échec.

## Stratégie d'exécution et d'automatisation

### Ordre de travail

1. Relire la matrice et vérifier que chaque cas correspond bien au texte de l'US.
2. Exécuter manuellement les cas encore non observés et relever le statut, les messages et les captures utiles.
3. Créer les défauts pour les écarts réellement constatés.
4. Automatiser les scénarios manuels stables : annulations, refus, paiement et contrôles de saisie.
5. Ajouter les scénarios de régression au pipeline Jenkins.

### Gestion des données de test

- Chaque chemin terminal utilise ses propres dates de trois nuits afin qu'une réservation n'en bloque pas une autre.
- Les parcours qui modifient définitivement un statut (`ANNULÉ`, `REFUSÉ`, `RÉSERVÉ`) doivent démarrer avec une nouvelle demande de réservation.
- Avant une démonstration complète ou un build Jenkins de soutenance, l'annonce de test est recréée pour retrouver un calendrier vierge.

### Règle pour les anomalies connues

Une anomalie reproduite doit être documentée, mais elle ne doit pas rendre la régression Jenkins rouge à chaque commit.

Lorsque les tests US07-CT09 et US08-CT09 seront automatisés, ils seront placés dans une suite dédiée et marqués avec le tag `anomalie_connue`. Le pipeline de régression les exclura tant que l'anomalie existera. Après correction par l'équipe produit, ils rejoindront la suite principale et devront devenir verts.

## Bilan de couverture initial

| Domaine | Cas identifiés | Déjà automatisés | À exécuter / automatiser | Anomalies à reproduire |
| --- | ---: | ---: | ---: | ---: |
| US07 - Demande de réservation | 9 | 2 | 6 | 1 |
| US08 - Cycle de réservation et paiement | 9 | 1 | 7 | 1 |
| **Total** | **18** | **3** | **13** | **2** |

Cette matrice est une photographie de la couverture à l'instant présent. Elle sera mise à jour après chaque exécution manuelle, automatisation ou défaut confirmé.
