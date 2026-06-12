module "RG" {
  source              = "../module/resourcegroup"
  rg                  = var.RG
}
module "vnets" {
    depends_on          = [module.RG]
  source              = "../module/virtualnetwork"
  vnets               = var.vnets
  
}
module "subnets"{

  depends_on          = [module.RG,module.vnets]
  source              = "../module/subnet"
  subnets             = var.subnets
}