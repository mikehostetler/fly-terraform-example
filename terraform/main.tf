# main.tf
terraform {
  required_providers {
    fly = {
      source = "fly-apps/fly"
      version = "0.0.16"
    }
  }
}

resource "fly_app" "myTerraformApp" {
  name = "my-terraform2" #Replace this with your own app name
  org  = "personal"
}

resource "fly_ip" "exampleIp" {
  app        = "my-terraform2" #Replace this with your own app name
  type       = "v4"
  depends_on = [fly_app.myTerraformApp]
}

resource "fly_ip" "exampleIpv6" {
  app        = "my-terraform2" #Replace this with your own app name
  type       = "v6"
  depends_on = [fly_app.myTerraformApp]
}

resource "fly_volume" "exampleVol" {
    app = "my-terraform2"
    name = "sftpgodata"
    size = 2
    region = "ewr"
    depends_on = [fly_app.myTerraformApp]
}

#   image  = "flyio/iac-tutorial:latest"
resource "fly_machine" "exampleMachine" {
  for_each = toset(["ewr", "lax", "maa", "mad"])
  app    = "my-terraform2"
  region = each.value
  name   = "flyiac-${each.value}"
  image  = "registry.fly.io/my-terraform:sftpgo-latest"
#   mounts = [
#     {
#         path = "/data"
#         volume = "agpterraformvol"
#     },
#   ]
  services = [
    {
      ports = [
        {
          port     = 443
          handlers = ["tls", "http"]
        },
        {
          port     = 80
          handlers = ["http"]
        }
      ]
      "protocol" : "tcp",
      "internal_port" : 8080
    },
  ]
  cpus = 1
  memorymb = 512
  depends_on = [fly_app.myTerraformApp, fly_volume.exampleVol]
}