[La version française suit.](#référentiel-terraform-pour-les-mesures-de-performance-dalerte-covid)

# Covid Alert Metrics Terraform

> **COVID Alert is now retired**: For more information, visit the [Government of Canada COVID Alert home page](https://www.canada.ca/en/public-health/services/diseases/coronavirus-disease-covid-19/covid-alert.html).

This is the Terraform and Terragrunt repository used to manage the Metrics Application Programming Interface (API) infrastructure in the Amazon Web Services (AWS) cloud platform.  

The [Covid Alert App](https://github.com/cds-snc/covid-alert-app#covid-alert-mobile-app) sends anonymous usage data to the Metrics API `/save-metrics` endpoint which is then converted to data comma-separated values (CSV) files by the [Covid Alert Metrics ETL](https://github.com/cds-snc/covid-alert-metrics-etl#covid-alert-metrics-extract-transform-and-load-etl) project.

## Infrastructure
This project creates and manages the following AWS resources in the Staging and Production environments:

* API Gateway which provides the `/save-metrics` endpoint.
* Lambda functions process metrics data payloads from the Covid Alert App.
* DynamoDB tables to store raw and aggregated metrics data.
* Elastic Container Registries (ECR) and an Elastic Container Service (ECS) Fargate cluster to store the [Covid Alert Metrics ETL](https://github.com/cds-snc/covid-alert-metrics-etl#covid-alert-metrics-extract-transform-and-load-etl) Docker images and process the metrics data.
* S3 buckets to store the generated metrics CSV files.
* Route53 Domain Name System (DNS) record for the `metrics` subdomain.
* Virtual Private Cloud (VPC) configuration.
* Identity and Access Management (IAM) roles and policies.
* CloudWatch log groups and alarm.

## Setup
1. Install [Docker](https://docs.docker.com/get-docker/).
1. Install [VS Code](https://code.visualstudio.com/) and the [Remote Containers extension](https://marketplace.visualstudio.com/items?itemName=ms-vscode-remote.remote-containers).
1. Using the Remote Containers status bar, open the project folder in a container.  VS Code has a [tutorial on using devcontainers](https://code.visualstudio.com/docs/remote/containers-tutorial) if you get stuck.
1. Once the devcontainer finishes building, you will have a Terraform and Terragrunt development environment.
1. Export your AWS credentials.
1. Change directories into the `env/staging` or `env/production` folder, depending on which environment you are working on.
1. Run `terragrunt run-all plan` to see infrastructure changes.
1. Run `terragrunt run-all apply` to apply infrastructure changes.

### Note
For `env/production` changes, you also need to specify the tagged version of the code you want to run:
```sh
export INFRASTRUCTURE_VERSION=2.0.3
terragrunt run-all plan
terragrunt run-all apply
```

# Référentiel Terraform pour les mesures de performance d’Alerte COVID

> **Alerte COVID a été mis hors service** : Pour en savoir davantage, visitez la [page d'accueil d’Alerte COVID du gouvernement du Canada](https://www.canada.ca/fr/sante-publique/services/maladies/maladie-coronavirus-covid-19/alerte-covid.html).

Il s’agit du référentiel Terraform et Terragrunt utilisé pour gérer l’infrastructure de l’API des mesures de performance dans la plate-forme d’infonuagique Amazon Web Services (AWS). 

[L’application Alerte COVID](https://github.com/cds-snc/covid-alert-app#application-mobile-alerte-covid) envoie des données d’utilisation anonymes au point de terminaison `/save-metrics` de l’API des mesures de performance qui sont ensuite converties en fichiers de valeurs séparées par des virgules (CSV) par le projet [Extraction, transformation et chargement des mesures d’Alerte COVID (ETL)](https://github.com/cds-snc/covid-alert-metrics-etl#extraction-transformation-et-chargement-etl-des-mesures-de-performance-dalerte-covid).

## Infrastructure
Ce projet crée et gère les ressources AWS suivantes dans les environnements de préparation et de production :

* Passerelle API qui fournit le point de terminaison `/save-metrics`.
* Les fonctions Lambda traitent les données des mesures de performance envoyées par l’application Alerte COVID.
* Tables DynamoDB pour stocker les données de mesures brutes et agrégées.
* Elastic Container Registries (ECR) et un groupe Fargate Elastic Container Service (ECS) pour stocker les images Docker du projet [ETL des mesures de performance d’Alerte COVID](https://github.com/cds-snc/covid-alert-metrics-etl#extraction-transformation-et-chargement-etl-des-mesures-de-performance-dalerte-covid) et traiter les données de mesures.
* Des compartiments S3 pour stocker les fichiers CSV de mesures générés.
* Enregistrement du système de noms de domaine (DNS) Route53 pour le sous-domaine `metrics`.
* Configuration du nuage privé virtuel (VPC).
* Rôles et stratégies de gestion des identités et des accès (IAM).
* Groupes et alertes de journal CloudWatch.

## Configuration
1. Installer [Docker](https://docs.docker.com/get-docker/).
1. Installer [VS Code](https://code.visualstudio.com/) et [l’extension Remote Containers](https://marketplace.visualstudio.com/items?itemName=ms-vscode-remote.remote-containers).
1. À l’aide de la barre d’état Remote Containers, ouvrez le dossier du projet dans un conteneur. VS Code propose un [tutoriel sur l’utilisation de devcontainers](https://code.visualstudio.com/docs/remote/containers-tutorial) en cas de difficultés.
1. Une fois le devcontainer généré, l’environnement de développement Terraform et Terragrunt est prêt à utiliser.
1. Exporter les identifiants AWS.
1. Modifier les répertoires pour créer des dossiers `env/staging` ou `env/production`, selon l’environnement dans lequel on souhaite travailler.
1. Exécuter `terragrunt run-all plan` pour voir les changements d’infrastructure.
1. Exécuter `terragrunt run-all apply` pour appliquer les modifications apportées à l’infrastructure.

### Note :
Pour les modifications dans le dossier `env/production`, il faut aussi préciser la version balisée du code que vous souhaitez exécuter :
```sh
export INFRASTRUCTURE_VERSION=2.0.3
terragrunt run-all plan
terragrunt run-all apply
```
