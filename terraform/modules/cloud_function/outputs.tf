output "bucket_name" {
  value = google_storage_bucket.bucket.name
}

output "object_name" {
  value = google_storage_bucket_object.archive.name
}

output "invoker_service_account_id" {
  value = google_service_account.invoker_service_account.email
}
