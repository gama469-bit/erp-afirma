@echo off
echo Setting up IAM authentication for Cloud SQL...
echo.

echo 1. Enabling IAM authentication on Cloud SQL instance...
gcloud sql instances patch erp-afirma-db --database-flags=cloudsql.iam_authentication=on

echo.
echo 2. Creating Cloud Run service account...
gcloud iam service-accounts create erp-cloudrun-sa --display-name="ERP Cloud Run Service Account"

echo.
echo 3. Granting Cloud SQL client role...
gcloud projects add-iam-policy-binding erp-afirma-solutions --member="serviceAccount:erp-cloudrun-sa@erp-afirma-solutions.iam.gserviceaccount.com" --role="roles/cloudsql.client"

echo.
echo 4. Creating database user for IAM service account...
gcloud sql users create erp-cloudrun-sa@erp-afirma-solutions.iam.gserviceaccount.com --instance=erp-afirma-db --type=cloud_iam_service_account

echo.
echo Setup complete! Now you need to:
echo 1. Connect to database: gcloud sql connect erp-afirma-db --user=postgres --database=BD_afirma
echo 2. Grant permissions:
echo    GRANT ALL PRIVILEGES ON DATABASE "BD_afirma" TO "erp-cloudrun-sa@erp-afirma-solutions.iam.gserviceaccount.com";
echo    GRANT ALL PRIVILEGES ON ALL TABLES IN SCHEMA public TO "erp-cloudrun-sa@erp-afirma-solutions.iam.gserviceaccount.com";
echo    GRANT ALL PRIVILEGES ON ALL SEQUENCES IN SCHEMA public TO "erp-cloudrun-sa@erp-afirma-solutions.iam.gserviceaccount.com";
echo    GRANT USAGE ON SCHEMA public TO "erp-cloudrun-sa@erp-afirma-solutions.iam.gserviceaccount.com";
echo    \q
echo.
echo 3. Deploy: gcloud run services replace service.yaml --region us-central1