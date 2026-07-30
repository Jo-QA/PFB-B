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
| US07 | P1 | Cas nominal / happy path | Un voyageur connecté envoie une demande de réservation. | La demande est confirmée par Homey. |
| US07 | P1 | Cas bloquant / unhappy path | Un visiteur non connecté tente de réserver. | Homey demande une connexion. |
| US08 | P2 | Cas nominal / happy path | L'hôte confirme une demande envoyée par un voyageur. | Le statut devient `PAIEMENT EN ATTENTE`. |

Les scénarios US07 et US08 correspondent au périmètre demandé pour le projet de fin de bloc. Le smoke test est conservé comme contrôle rapide de la fonctionnalité de connexion.

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

robot --outputdir results tests/
robot --outputdir results tests/US07_demande_reservation.robot
robot --outputdir results tests/US08_traiter_demande_reservation.robot

## Intégration continue avec Jenkins

Le projet est exécuté automatiquement par le job Jenkins **Pipeline-tests-automatises-PFB-B**.

Le pipeline suit les étapes suivantes :

1. Jenkins récupère la dernière version du projet sur GitHub.
2. Il crée un environnement Python dédié et installe les dépendances.
3. Il exécute l'ensemble des tests Robot Framework.
4. Il publie les rapports de test et les conserve en pièces jointes du build.

Jenkins vérifie GitHub chaque minute. Lorsqu'un nouveau commit est détecté, un build est lancé automatiquement. Une modification enregistrée uniquement dans VS Code ne déclenche donc pas le pipeline : elle doit d'abord être validée puis envoyée sur GitHub avec un commit et un push.

Le fichier `Jenkinsfile`, présent à la racine du dépôt, décrit ce pipeline. Le versionner avec le projet permet de garder la configuration d'intégration continue lisible, reproductible et traçable.

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
