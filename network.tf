resource "yandex_vpc_network" "network" {
  name = "hw-network"
}

resource "yandex_vpc_subnet" "subnet" {
  name           = "hw-subnet"
  zone           = var.zone
  network_id     = yandex_vpc_network.network.id
  v4_cidr_blocks = ["10.0.1.0/24"]
}