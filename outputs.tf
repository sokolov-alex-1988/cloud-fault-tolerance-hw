output "lb_external_ip" {
  description = "Внешний IP-адрес балансировщика"
  value       = tolist(tolist(yandex_lb_network_load_balancer.web-lb.listener)[0].external_address_spec)[0].address
}