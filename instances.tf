resource "yandex_compute_instance" "web" {
  count = 2
  name  = "web-vm-${count.index + 1}"
  platform_id = "standard-v1" # Intel Ice Lake, как на вашем скриншоте

  resources {
    cores         = 2           # Уменьшаем до 1 ядра (вместо 2)
    memory        = 1           # 2 ГБ памяти (вместо 4)
    core_fraction = 20          # 20% гарантированной доли vCPU (как у вас)
  }

  scheduling_policy {
    preemptible = true          # Делаем машины прерываемыми (как у вас)
  }

  boot_disk {
    initialize_params {
      image_id = "fd8li2lvvfc6bdj4c787" # Ubuntu 22.04 LTS
      size     = 10 # 10 ГБ диск
    }
  }

  network_interface {
    subnet_id = yandex_vpc_subnet.subnet.id
    nat       = true
  }

  metadata = {
    ssh-keys = "ubuntu:${file("C:/Users/admin/.ssh/id_ed25519.pub")}"
    
    user-data = <<-EOF
      #cloud-config
      package_update: true
      packages:
        - nginx
      runcmd:
        - [ systemctl, enable, nginx ]
        - [ systemctl, start, nginx ]
    EOF
  }
}