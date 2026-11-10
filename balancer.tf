# Создаем целевую группу
resource "yandex_lb_target_group" "web-group" {
  name = "web-target-group"

  # Автоматически берем IP-адреса всех созданных виртуальных машин
  dynamic "target" {
    for_each = yandex_compute_instance.web[*].network_interface[0].ip_address
    content {
      subnet_id = yandex_vpc_subnet.subnet.id
      address   = target.value
    }
  }
}

# Создаем сетевой балансировщик
resource "yandex_lb_network_load_balancer" "web-lb" {
  name = "web-network-load-balancer"

  # Настраиваем прослушивание 80 порта
  listener {
    name = "http-listener"
    port = 80
    external_address_spec {
      ip_version = "ipv4"
    }
  }

  # Привязываем целевую группу и настраиваем проверку здоровья (healthcheck)
  attached_target_group {
    target_group_id = yandex_lb_target_group.web-group.id

    healthcheck {
      name = "http-healthcheck"
      http_options {
        port = 80
        path = "/"
      }
    }
  }
}