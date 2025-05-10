module "network" {
  source      = "./modules/network"
  project_id  = var.project_id
  vpc_name    = "vpc-app"
  subnet_name = "subnet-app"
  subnet_cidr = "10.10.0.0/24"
  region      = var.region
}

module "vm" {
  source                = "./modules/compute-engine"
  region                = var.region
  project_id            = var.project_id
  instance_name         = "vm-web"
  zone                  = var.zone
  subnet                = module.network.subnet_self_link
  service_account_email = "app-web@protech-labs.iam.gserviceaccount.com"
}

module "sql" {
  source         = "./modules/cloud-sql"
  project_id     = var.project_id
  instance_name  = "postgres-db-app"
  region         = var.region
  vpc            = module.network.vpc_name
  peering_network = module.network.vpc_self_link
}

module "lb" {
  source              = "./modules/load-balancer"
  project_id          = var.project_id
  name                = "app"
  region              = var.region
  zone                = var.zone
  instance_self_link  = module.vm.instance_self_link
}
