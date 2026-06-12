variable "rg" {
    description = "List of Resource Group"
    type        = map(object({
        rg_name  = string
        location = string
    }))

}