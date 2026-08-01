# Projet de Fin de Bloc B — Automatisation des tests Homey

Ce dépôt contient l'automatisation des tests des User Stories **US07 — Faire une demande de réservation** et **US08 — Traiter une demande de réservation** de l'application Homey.

Le projet utilise Robot Framework, SeleniumLibrary, une architecture Page Object Model (POM), GitHub et Jenkins. Il reprend les cas manuels du PFB A et explique lesquels sont automatisés selon une stratégie P1 / P2 / P3.

## Objectifs

- Automatiser les scénarios prioritaires des US07 et US08.
- Organiser les scripts avec le modèle Page Object Model.
- Centraliser les données de test et les mots-clés communs.
- Conserver la traçabilité entre les tests manuels du PFB A et les scripts Robot.
- Exécuter automatiquement les tests avec Jenkins.

## Couverture des tests

| Périmètre | Priorité | Vérification automatisée | Décision |
| --- | --- | --- | --- |
| Connexion | Transverse | Un voyageur se connecte avec un compte valide. | Smoke test rapide. |
| US07 | P1 / P2 | Accès, message à l'hôte, dates et voyageurs. | Contrôles simples automatisés ; anomalies connues isolées. |
| US08 | P1 | Paiement sans profil hôte. | Anomalie connue, exécutable séparément. |
| US08 | P2 | Profil bancaire et parcours nominal jusqu'à `RÉSERVÉ`. | Automatisé avec des données de test préparées. |
| US08 | P3 | Annulations et refus. | Conservés en manuel : préparation et nettoyage trop coûteux. |

La [matrice de couverture fonctionnelle](documentation/matrice_couverture_tests.md) détaille les 17 cas manuels du PFB A, leur priorité et leur décision d'automatisation. La [réconciliation PFB A / PFB B](documentation/reconciliation_pfb_a_pfb_b.md) fait le lien avec les références Jira.

## Technologies utilisées

| Technologie | Rôle |
| --- | --- |
| Python | Exécuter Robot Framework. |
| Robot Framework | Écrire et exécuter les scénarios de test. |
| SeleniumLibrary | Piloter le navigateur Web. |
| Google Chrome | Navigateur de test. |
| ChromeDriver | Permettre à Selenium de piloter Chrome. |
| GitHub | Versionner et partager le projet. |
| Jenkins | Lancer les tests en intégration continue. |
| Visual Studio Code | Éditer les fichiers du projet. |

## Architecture

```text
PFB-B/
│
├── tests/
│   ├── Smoke/
│   │   └── smoke_connexion.robot
│   ├── US07_demande_reservation.robot
│   └── US08_traiter_demande_reservation.robot
│
├── resources/
│   ├── pages/                      # Un fichier par page du périmètre
│   ├── common_keywords.robot       # Actions communes
│   └── variables.robot             # Données de test centralisées
│
├── documentation/
│   ├── matrice_couverture_tests.md
│   └── reconciliation_pfb_a_pfb_b.md
│
├── results/                        # Rapports générés, ignorés par Git
├── Jenkinsfile
├── requirements.txt
├── .gitignore
└── README.md
```

Les scénarios se trouvent dans `tests/`. Ils appellent des mots-clés métiers présents dans `resources/pages/`, sans contenir de sélecteurs techniques. Cette séparation rend les tests plus lisibles et plus faciles à maintenir.

## Prérequis

- Python 3.11 ;
- Google Chrome et ChromeDriver ;
- Java, uniquement pour lancer Jenkins en local ;
- une connexion Internet vers l'environnement Homey et GitHub.

## Installation locale

```powershell
git clone https://github.com/Jo-QA/PFB-B.git
cd PFB-B
python -m venv .venv
.\.venv\Scripts\activate
python -m pip install -r requirements.txt
```

L'environnement virtuel `.venv` isole les dépendances du projet. Il évite qu'une version installée pour un autre projet modifie les résultats.

## Exécuter les tests localement

```powershell
# Contrôles P1 hors anomalies connues
python -m robot --include P1 --exclude anomalie_connue --outputdir results tests/

# Contrôles P1 et P2 hors anomalies connues
python -m robot --include P1 --include P2 --exclude anomalie_connue --outputdir results tests/

# Démonstration des anomalies connues
python -m robot --include anomalie_connue --outputdir results tests/
```

Les scénarios P2 qui créent une réservation demandent des dates libres. Les anomalies connues sont volontairement isolées : elles démontrent un écart au cahier des charges sans faire échouer le pipeline quotidien.

## Lancer Jenkins en local

Le fichier `jenkins.war` est stocké dans `C:\Users\meuni\OneDrive\Formation QA\Jenkins`.

1. Ouvrir un terminal dans ce dossier.
2. Lancer Jenkins avec la commande suivante :

   ```powershell
   java -jar jenkins.war
   ```

3. Ouvrir l'adresse indiquée dans le terminal, généralement [http://localhost:8080](http://localhost:8080).
4. Dans le tableau de bord Jenkins, ouvrir le job `Pipeline-tests-automatises-PFB-B`.

Le terminal doit rester ouvert pendant l'utilisation de Jenkins et l'exécution des builds. Le fermer arrête Jenkins ; l'interface locale et les tests en cours ne sont alors plus disponibles.

## Intégration continue avec Jenkins

Le job Jenkins récupère la dernière version du dépôt GitHub, crée un environnement Python dédié, installe les dépendances, exécute Robot Framework et archive les rapports.

Par défaut, il lance les P1 hors anomalies connues : le smoke test de connexion et le contrôle d'accès US07. Lorsqu'un nouveau commit est détecté sur GitHub, Jenkins lance automatiquement ce contrôle rapide.

Le paramètre `EXECUTER_TESTS_P2` ajoute les contrôles P2 et le parcours nominal complet. Il doit être activé après avoir préparé des dates libres, car ce parcours crée une demande, enregistre un profil bancaire fictif et marque une réservation comme payée.

Une modification enregistrée seulement dans Visual Studio Code ne déclenche pas Jenkins. Elle doit être enregistrée dans Git, puis envoyée sur GitHub avec un commit et un push.

## Résultats

Chaque exécution génère les fichiers suivants dans `results/` :

| Fichier | Contenu |
| --- | --- |
| `report.html` | Résumé des tests exécutés. |
| `log.html` | Détail de chaque étape. |
| `output.xml` | Résultat XML exploité par Jenkins. |

Dans Jenkins, le lien **Robot Results** affiche une synthèse. Les fichiers HTML sont aussi disponibles dans les artefacts du build.

## Auteur

Jonathan Meunier

Projet réalisé dans le cadre de la préparation au titre professionnel RNCP41887 — Testeur Logiciel.

Version : 1.0.0

Dernière mise à jour : août 2026
