variable "cloud" {
  description = "Name of your cloud from clouds.yaml."
  type = string
}

variable "compute_instance_name" {
  description = "Name of the compute instance."
  type = string
}

variable "compute_instance_image_name" {
  description = "The name of the image used by compute instance."
  type = string
}

variable "compute_instance_user" {
  description = "Username used in compute instance. It can be found in image details."
  type = string
}

variable "compute_instance_flavor" {
  description = "Name of the flavor used by compute instance."
  type = string
}

variable "volume_size" {
  description = "Volume size in gigabytes."
  type = number
}

variable "network_name" {
  description = "Name of the network used by compute instance."
  type = string
}

variable "public_key" {
  description = "Path to SSH public key used for connecting to compute instance."
  type = string
}

variable "private_key" {
  description = "Path to SSH private key. Ansible uses this key to connect to compute instance. Used only in Ansible command."
  type = string
  default = ""
}

variable "floating_ip_pool" {
  description = "Name of the floating IP pool."
  type = string
}

variable "secgroup_name" {
  description = "Name of the security group in Openstack."
  type = string
}

variable "cyst_core_token" {
  description = "Gitlab token for cloning CYST private repo via Ansible. Used only in Ansible command."
  type = string
  default = ""
}

variable "dojo_token" {
  description = "Gitlab token for cloning ai-dojo private repo via Ansible. Used only in Ansible command."
  type = string
  default = ""
}

variable "cyst_platform_token" {
  description = "Gitlab token for cloning CYST private repo via Ansible. Used only in Ansible command."
  type = string
  default = ""
}

variable "cyst_models_token" {
  description = "Gitlab token for cloning CYST private repo via Ansible. Used only in Ansible command."
  type = string
  default = ""
}
