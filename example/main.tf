module "vortexwestdemo" {
  source = "../"

  project_name = var.project_name
  environment  = var.environment
  account_id   = var.account_id

  deploy_new_account = true

  frontend_url = var.frontend_url
  backend_url  = var.backend_url
}
