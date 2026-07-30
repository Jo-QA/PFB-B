# Projet de Fin de Bloc B – Automatisation des tests de l'application Homey

Ce dépôt contient les scripts d'automatisation réalisés dans le cadre du Projet de Fin de Bloc B de la formation Testeur Logiciel.
L'objectif est d'automatiser les scénarios de test des User Stories US-07 et US-08 de l'application Homey à l'aide de Robot Framework et SeleniumLibrary, puis d'intégrer leur exécution dans un pipeline d'intégration continue avec Jenkins.

## Sommaire

- Présentation
- Objectifs
- Technologies utilisées
- Architecture
- Prérequis
- Installation
- Exécution des tests
- Résultats
- Auteur

## Objectifs

- Automatiser les User Stories US-07 et US-08
- Utiliser Robot Framework
- Structurer le projet selon le Page Object Model
- Versionner le projet avec GitHub
- Exécuter automatiquement les tests via Jenkins

## Couverture des tests

| Référence | Priorité | Type de scénario | Vérification automatisée | Résultat attendu |
| --------- | -------- | ---------------- | ------------------------ | ---------------- |
| Smoke connexion | Transverse | Smoke test | Un voyageur se connecte avec un compte valide. | Le tableau de bord voyageur est affiché. |
| US07 | P1 / P2 | Demande et contrôles de saisie | Message obligatoire, contrôle d'accès, dates et voyageurs. | Les règles simples sont automatisées ; les anomalies connues sont isolées. |
| US08 | P1 | Sécurité du paiement | Un hôte sans profil de paiement ne peut pas marquer une réservation comme payée. | Anomalie connue, conservée hors Jenkins. |
| US08 | P2 | Parcours nominal et profil de paiement | Profil bancaire, confirmation, paiement puis statut `RESERVE`. | Le cycle nominal est vérifié côté hôte et voyageur. |
| US08 | P3 | Annulations et refus | Les cinq branches terminales du schéma de réservation. | Conservées en manuel : préparation et nettoyage de données coûteux. |

Les scénarios US07 et US08 correspondent au périmètre demandé pour le projet de fin de bloc. Le smoke test est conservé comme contrôle rapide de la fonctionnalité de connexion.

La couverture détaillée, incluant les cas d'exception, les transitions de statuts et les anomalies à reproduire, est disponible dans la [matrice de couverture fonctionnelle](documentation/matrice_couverture_tests.md). La [réconciliation PFB A / PFB B](documentation/reconciliation_pfb_a_pfb_b.md) conserve le lien entre les 17 cas manuels réalisés dans Jira et leur reprise progressive en automatisation.

## Technologies utilisées

| Technologie        | Rôle                         |
| ------------------ | ---------------------------- |
| Python             | Langage d'exécution          |
| Robot Framework    | Framework d'automatisation   |
| SeleniumLibrary    | Automatisation des tests Web |
| Google Chrome      | Navigateur de test           |
| ChromeDriver       | Pilotage du navigateur       |
| GitHub             | Gestion de versions          |
| Jenkins            | Intégration Continue         |
| Antigravity IDE    | Développement                |


## Architecture

```text
Projet fin de bloc B/
│
├── tests/
├── resources/
│   ├── pages/
│   ├── variables.robot
│   └── common_keywords.robot
│
├── results/
├── README.md
├── requirements.txt
├── Jenkinsfile
└── .gitignore
```

## Architecture des tests

Le projet est organisé selon le modèle **Page Object Model (POM)**.

Cette architecture permet de séparer :
- les scénarios de test ;
- les actions réalisées sur les pages ;
- les variables et données de test.

## Prérequis

- Python 3.11
- Google Chrome
- ChromeDriver
- Robot Framework
- Connexion Internet

## Installation

```bash
git clone https://github.com/Jo-QA/PFB-B.git
cd PFB-B
pip install -r requirements.txt
```

## Exécution des tests

robot --include P1 --exclude anomalie_connue --outputdir results tests/
robot --include P1 --include P2 --exclude anomalie_connue --outputdir results tests/
robot --include anomalie_connue --outputdir results tests/

## Intégration continue avec Jenkins

Le projet est exécuté automatiquement par le job Jenkins **Pipeline-tests-automatises-PFB-B**.

Le pipeline suit les étapes suivantes :

1. Jenkins récupère la dernière version du projet sur GitHub.
2. Il crée un environnement Python dédié et installe les dépendances.
3. Il exécute par défaut les tests P1 non concernés par une anomalie connue.
4. Il publie les rapports de test et les conserve en pièces jointes du build.

Jenkins vérifie GitHub chaque minute. Lorsqu'un nouveau commit est détecté, un build est lancé automatiquement. Une modification enregistrée uniquement dans VS Code ne déclenche donc pas le pipeline : elle doit d'abord être validée puis envoyée sur GitHub avec un commit et un push.

Le fichier `Jenkinsfile`, présent à la racine du dépôt, décrit ce pipeline. Le versionner avec le projet permet de garder la configuration d'intégration continue lisible, reproductible et traçable.

Le paramètre Jenkins **EXECUTER_TESTS_P2** ajoute les contrôles P2 et le parcours nominal complet. Il doit être activé après avoir préparé des dates libres, car ce parcours crée une demande, enregistre un profil bancaire fictif et marque une réservation comme payée. Les anomalies connues restent exclues du pipeline afin qu'un défaut identifié ne fasse pas échouer chaque build.

## Résultats

Les rapports générés après chaque exécution sont disponibles dans le dossier results/ :

- **report.html** : résumé des tests exécutés.
- **log.html** : détail de chaque étape.
- **output.xml** : résultats XML utilisés par Jenkins.

Dans Jenkins, le lien **Robot Results** d'un build permet de consulter la synthèse des tests, tandis que les fichiers `report.html` et `log.html` sont disponibles dans les artefacts archivés.

## Auteur

Jonathan Meunier
Projet réalisé dans le cadre de la préparation au titre professionnel RNCP41887 – Testeur Logiciel.

## Informations du projet

Version : 1.0.0

Dernière mise à jour : juillet 2026
