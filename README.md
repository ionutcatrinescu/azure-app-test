# azure-app-test



Local run : 

docker-compose up --build

If any issues appear and require a rerun, clean up the containers and volumes, then rebuild everything to ensure a clean start: 

docker-compose down -v
docker-compose up --build

The -v flag ensures volumes are removed, which forces PostgreSQL to reinitialize and apply the init.sql script.


Terraform Run: 

Initialize Terraform:

terraform init

Plan the deployment using environment-specific variables:

terraform plan -var-file=dev.tfvars

Apply the deployment:

terraform apply -var-file=dev.tfvars

You can re-use the same Terraform definition by swapping .tfvars files for different environments like dev, staging, and prod.

To parameterize your GitHub Actions pipeline (pipeline.yml) so it supports running for different environments (e.g., dev, staging, and prod), i am using workflow inputs and environment variables.

Secrets Configuration
Set secrets for different environments in GitHub Actions (Settings -> Secrets and Variables -> Actions):

Common Secrets:
AZURE_CONTAINER_REGISTRY: The Azure container registry name.
AZURE_CONTAINER_REGISTRY_USERNAME: The registry username.
AZURE_CONTAINER_REGISTRY_PASSWORD: The registry password.


Environment Secrets:

For dev:
POSTGRESQL_PASSWORD=DevStrongPassword123!
POSTGRESQL_DBNAME=app_db_dev
APP_SERVICE_NAME_DEV=myproject-dev-app
RESOURCE_GROUP_NAME_DEV=myproject-dev-rg
APP_SERVICE_URL_DEV=myproject-dev-app.azurewebsites.net


For staging:
POSTGRESQL_PASSWORD=StagingStrongPassword123!
POSTGRESQL_DBNAME=app_db_staging
APP_SERVICE_NAME_STAGING=myproject-staging-app
RESOURCE_GROUP_NAME_STAGING=myproject-staging-rg
APP_SERVICE_URL_STAGING=myproject-staging-app.azurewebsites.net

For prod:
POSTGRESQL_PASSWORD=ProdStrongPassword123!
POSTGRESQL_DBNAME=app_db_prod
APP_SERVICE_NAME_PROD=myproject-prod-app
RESOURCE_GROUP_NAME_PROD=myproject-prod-rg
APP_SERVICE_URL_PROD=myproject-prod-app.azurewebsites.net
