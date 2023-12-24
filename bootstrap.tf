module "bootstrap" {
count = var.deploy_new_account ? 1 : 0  

  source = "./modules/bootstrap/"

  project_name = var.project_name
  environment  = var.environment
  account_id   = var.account_id
}

