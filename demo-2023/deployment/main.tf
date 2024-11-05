terraform {
  required_version = ">= 0.14.0"
  required_providers {
    openstack = {
      source = "terraform-provider-openstack/openstack"
      version = "~> 1.54.0"
    }
  }
}

provider "openstack" {
  cloud = var.cloud
}

data "openstack_networking_network_v2" "network" {
  name = var.network_name
}

data "openstack_images_image_v2" "image" {
  name_regex = var.compute_instance_image_name
  most_recent = true
}

data "openstack_networking_secgroup_v2" "secgroup" {
  name = var.secgroup_name
}

resource "random_string" "suffix" {
  length = 6
  special = false
  upper = false
}

resource "openstack_compute_keypair_v2" "dr-emu-key" {
  name = "ai-dojo-demo-${random_string.suffix.result}"
  public_key = file(var.public_key)
}

resource "openstack_networking_floatingip_v2" "fip" {
  pool = var.floating_ip_pool
}

resource "openstack_networking_port_v2" "port" {
  network_id = data.openstack_networking_network_v2.network.id
  security_group_ids = [data.openstack_networking_secgroup_v2.secgroup.id]
}

resource "openstack_networking_floatingip_associate_v2" "fip" {
  floating_ip = openstack_networking_floatingip_v2.fip.address
  port_id = openstack_networking_port_v2.port.id
}

resource "openstack_compute_instance_v2" "dr-emu" {
  name = "${var.compute_instance_name}-${random_string.suffix.result}"
  image_name = data.openstack_images_image_v2.image.id
  flavor_name = var.compute_instance_flavor
  key_pair = openstack_compute_keypair_v2.dr-emu-key.name

  block_device {
    uuid = data.openstack_images_image_v2.image.id
    source_type = "image"
    destination_type = "volume"
    volume_size = var.volume_size
    boot_index = 0
    delete_on_termination = true
  }

  network {
    port = openstack_networking_port_v2.port.id
  }
}

resource "null_resource" "ansible-deployment" {

  provisioner "remote-exec" {  # HACK: wait for the ssh connection
    inline = ["echo 'ssh is up!'"]

    connection {
      type = "ssh"
      user = var.compute_instance_user
      private_key = file(var.private_key)
      host = openstack_networking_floatingip_v2.fip.address
    }
  }

  provisioner "local-exec" {
    command = <<-EOT
    echo "Running ansible playbook."
    echo "It takes some time to run sshd on vm"
    echo "In case of failure, simply rerun <terraform apply>"
    ansible-playbook \
    -i "${openstack_networking_floatingip_v2.fip.address}," \
    -u ${var.compute_instance_user} \
    --private-key ${var.private_key} \
    --ssh-extra-args='-o IdentitiesOnly=yes' \
    -e "dojo_token=${var.dojo_token} cyst_core_token=${var.cyst_core_token} cyst_platform_token=${var.cyst_platform_token} cyst_models_token=${var.cyst_models_token}" \
    ./ansible.yaml
          EOT

    environment = {
      ANSIBLE_HOST_KEY_CHECKING = "False"
    }
  }

  triggers = {
    # The timestamp changes every time, forcing Terraform to redeploy (rerun) the Ansible playbook.
    deploy_time = timestamp()
  }

}

output "username" {
  value = var.compute_instance_user
}

output "ip" {
  value = openstack_networking_floatingip_v2.fip.address
}

output "ssh_command" {
  value = join("", [
    "if [ -z \"$1\" ]; then echo \"Private key must be specified\"; ",
    "else ssh -i $1 -o IdentitiesOnly=yes ${var.compute_instance_user}@${openstack_networking_floatingip_v2.fip.address}; fi"
  ])
}

output "ansible_command" {
  value = var.private_key != "" && var.cyst_core_token != "" && var.dojo_token != "" && var.cyst_platform_token != "" && var.cyst_models_token != "" ? join("", [
    "ANSIBLE_HOST_KEY_CHECKING=False ansible-playbook -i \"${openstack_networking_floatingip_v2.fip.address},\" ",
    "-u ${var.compute_instance_user} --private-key ${var.private_key} ",
    "--ssh-extra-args='-o IdentitiesOnly=yes' ",
    "-e \"dojo_token=${var.dojo_token} cyst_core_token=${var.cyst_core_token} cyst_platform_token=${var.cyst_platform_token} cyst_models_token=${var.cyst_models_token}\" ansible.yaml\n"
  ]) : join("", [
    "Ansible command could not be generated. You have to specify all optional variables:\n",
    "\tTF_VAR_private_key=path/to/your/key\n",
    "\tTF_VAR_gitlab_token=token  # token for cyst/cyst-core repository\n",
  ])
}

