# API details
resource "google_api_gateway_api" "api_gw" {
  provider     = google-beta
  api_id       = "${var.project_id}-api"
  display_name = "${var.project_id}-api"
}

# API config
resource "google_api_gateway_api_config" "api_cfg" {
  provider             = google-beta
  api                  = google_api_gateway_api.api_gw.api_id
  display_name         = "${google_api_gateway_api.api_gw.display_name}-conf.yml" # spec file name

  openapi_documents {
    document {
      path     = "../app/api-config.yaml" # api spec file
      contents = filebase64("../app/api-config.yml") # api spec file
    }
  }
  gateway_config {
    backend_config {
      google_service_account = var.invoker_service_account_id
    }
  }

  lifecycle {
    create_before_destroy = true
  }
}

# Gateway details
resource "google_api_gateway_gateway" "gw" {
  provider = google-beta
  api_config   = google_api_gateway_api_config.api_cfg.id
  gateway_id   = "${var.project_id}-gateway"
  region   = var.region
  depends_on   = [google_api_gateway_api_config.api_cfg]
}