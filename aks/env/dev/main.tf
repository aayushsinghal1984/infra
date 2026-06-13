

module "aks_block" {
  source       = "../../module/aks_cluster"
  aks          = var.aks_cluster
  log_analytic = var.aks_cluster
}
