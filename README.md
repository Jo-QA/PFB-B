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
git clone ...
cd ...
pip install -r requirements.txt
```

## Exécution des tests

robot --outputdir results tests/
robot --outputdir results tests/US07_demande_reservation.robot
robot --outputdir results tests/US08_traiter_demande_reservation.robot

## Résultats

Les rapports générés après chaque exécution sont disponibles dans le dossier results/ :

- **report.html** : résumé des tests exécutés.
- **log.html** : détail de chaque étape.
- **output.xml** : résultats XML utilisés par Jenkins.

## Auteur

Jonathan Meunier
Projet réalisé dans le cadre de la préparation au titre professionnel RNCP41887 – Testeur Logiciel.

## Informations du projet

Version : 1.0.0

Dernière mise à jour : juillet 2026
