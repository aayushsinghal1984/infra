module "RG" {
  source              = "../module/resourcegroup"
  rg                  = var.resource_group
}
module "vnets" {
  depends_on          = [module.RG]
  source              = "../module/virtualnetwork"
  vnets               = var.vnets
  
}
module "subnets" {
  depends_on          = [module.RG , module.vnets]
  source              = "../module/subnet"
  subnets             = var.subnets
}

module "nsg" {
  depends_on          = [module.RG]
  source              = "../module/nsg"
  NSG                 = var.NSG
}
module "nsgsubnetassociation" {
  depends_on          = [module.subnets , module.nsg]
  source              = "../module/nsgsubnetassociation"
  nsgsubnetassociation = var.nsgsubnetassociation
}
