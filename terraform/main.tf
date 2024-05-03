# Module to enable APIs for this project
module "enable_apis" {
  source = "./modules/enable_apis"
}

# Module for managing SQL database
module "sql_database" {
  source     = "./modules/sql_database"
  project_id = var.project_id
  depends_on = [module.enable_apis]
}

# Module to create a cloud function
module "cloud_function" {
  source     = "./modules/cloud_function"
  project_id = var.project_id
  region     = var.region
  depends_on = [module.enable_apis, module.sql_database]
}

# Module to create API gateway
module "gateway" {
  source                     = "./modules/gateway"
  project_id                 = var.project_id
  invoker_service_account_id = module.cloud_function.invoker_service_account_id
}