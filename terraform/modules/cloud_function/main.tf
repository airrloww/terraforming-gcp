## this module create a bucket to store the source code into,
## then archiving the source code and uploading it to the bucket

resource "google_storage_bucket" "bucket" {
  name     = "cloud-function-${var.project_id}"
  location = "EU"
  project  = var.project_id
}

# Generate an archive of the source code compressed as a .zip file
data "archive_file" "source" {
  type        = "zip"
  source_dir  = "../app"
  output_path = "../app.zip"
}

# Add source code zip to the Cloud Function's bucket (Cloud_function_bucket) 
resource "google_storage_bucket_object" "archive" {
  source       = data.archive_file.source.output_path
  content_type = "application/zip"
  name         = "src-${data.archive_file.source.output_md5}.zip"
  bucket       = google_storage_bucket.bucket.name
  depends_on = [
    google_storage_bucket.bucket,
    data.archive_file.source
  ]
}


## this part creates a cloud function, a service account to invoke the function
## and give the service account the permissions needed to invoke the function

# Create a service account
resource "google_service_account" "invoker_service_account" {
  account_id   = "function-invoker"
  display_name = "Cloud Function Invoker"
  project      = var.project_id
}

# IAM entry for the service account to invoke the function
resource "google_cloudfunctions_function_iam_member" "invoker" {
  cloud_function = google_cloudfunctions_function.function.name
  project        = google_cloudfunctions_function.function.project
  region         = google_cloudfunctions_function.function.region

  role   = "roles/cloudfunctions.invoker"
  member = "serviceAccount:${google_service_account.invoker_service_account.email}"
  depends_on = [
    google_cloudfunctions_function.function,
    data.archive_file.source
  ]
}

# IAM entry for the service account to interact with CloudSQL
resource "google_project_iam_member" "cloudsql_client" {
  project = var.project_id
  role    = "roles/cloudsql.client"
  member  = "serviceAccount:${google_service_account.invoker_service_account.email}"
}

resource "google_cloudfunctions_function_iam_binding" "function_invoker_binding" {
  cloud_function = google_cloudfunctions_function.function.name
  project        = google_cloudfunctions_function.function.project
  region         = google_cloudfunctions_function.function.region

  role    = "roles/cloudfunctions.invoker"
  members = ["allUsers"]
}

resource "google_cloudfunctions_function" "function" {
  name                         = "${var.project_id}-function"
  runtime                      = var.function_runtime
  description                  = var.description
  region                       = "us-central1"
  entry_point                  = var.entry_point
  timeout                      = var.timeout
  available_memory_mb          = var.memory
  trigger_http                 = var.trigger_http
  https_trigger_security_level = var.https_trigger_security_level
  source_archive_bucket        = google_storage_bucket.bucket.name
  source_archive_object        = google_storage_bucket_object.archive.name
  service_account_email        = google_service_account.invoker_service_account.email
}
