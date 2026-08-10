module "secret_manager" {
    source = "../../modules/secrets_manager"
    project_name = var.project_name
    env = var.env
}