variable "cumulus_vx_version" {
    type = string
    default = "4.1.1"
}

provider "libvirt" {
  uri = "qemu:///system"
}

resource "libvirt_volume" "eve_ng" {
  name = "eve_ng.img"
  pool = "default"
  source = "./EVE-COMM-VM/EVE-COMM-VM-0.qcow2"
  format = "qcow2"
}

# Define KVM domain to create
resource "libvirt_domain" "eve_ng" {
  name   = "eve_ng"
  memory = "8192"
  vcpu   = 4

  disk {
    volume_id = libvirt_volume.eve_ng.id
  }

  console {
    type = "pty"
    target_type = "serial"
    target_port = "0"
  }

  graphics {
    type = "spice"
    listen_type = "address"
    autoport = true
  }

  network_interface {
    network_name = "default"
    wait_for_lease = true
  }

  connection {
    type     = "ssh"
    user     = "root"
    password = "eve"
    host     = self.network_interface.0.addresses.0
  }
  
  provisioner "remote-exec" {
    inline = ["mkdir /opt/unetlab/addons/qemu/cumulus-vx-${var.cumulus_vx_version}"]
  }

  provisioner "file" {
    source      = "cumulus/cumulus-linux-${var.cumulus_vx_version}-vx-amd64-qemu.qcow2"
    destination = "/opt/unetlab/addons/qemu/cumulus-vx-${var.cumulus_vx_version}/cumulus-linux-${var.cumulus_vx_version}-vx-amd64-qemu.qcow2"
  }

  provisioner "remote-exec" {
    inline = ["/opt/unetlab/wrappers/unl_wrapper -a fixpermissions"]
  }
}

output "ip" {
  value = libvirt_domain.eve_ng.network_interface.0.addresses.0
}

