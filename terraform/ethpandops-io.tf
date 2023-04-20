resource "cloudflare_record" "dns-entry" {
  for_each = {
    for vm in local.digitalocean_vms : "${vm.id}" => vm
  }
  zone_id = data.sops_file.cloudflare.data["zones.ethpandaops-io.zone_id"]
  name    = "${each.value.name}.${data.sops_file.cloudflare.data["zones.ethpandaops-io.domain"]}"
  type    = "A"
  value   = "${digitalocean_droplet.main[each.value.id].ipv4_address}"
  proxied = false
}


resource "cloudflare_record" "dns-entry-bootnode-wildcard" {
  zone_id = data.sops_file.cloudflare.data["zones.ethpandaops-io.zone_id"]
  name    = "*.${var.ethereum_network}"
  type    = "CNAME"
  value   = "${var.ethereum_network}.${data.sops_file.cloudflare.data["zones.ethpandaops-io.domain"]}"
  proxied = false
}

resource "cloudflare_record" "server_record_rpc" {
  for_each = {
    for vm in local.digitalocean_vms : "${vm.id}" => vm
  }
  zone_id = data.sops_file.cloudflare.data["zones.ethpandaops-io.zone_id"]
  name    = "rpc.${each.value.name}.${var.ethereum_network}"
  type    = "A"
  value   = digitalocean_droplet.main[each.value.id].ipv4_address
  proxied = false
  ttl     = 120
}

resource "cloudflare_record" "server_record_beacon" {
  for_each = {
    for vm in local.digitalocean_vms : "${vm.id}" => vm
  }
  zone_id = data.sops_file.cloudflare.data["zones.ethpandaops-io.zone_id"]
  name    = "bn.${each.value.name}.srv.${var.ethereum_network}"
  type    = "A"
  value   = digitalocean_droplet.main[each.value.id].ipv4_address
  proxied = false
  ttl     = 120
}