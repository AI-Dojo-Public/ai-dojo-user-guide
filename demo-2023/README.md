# Demo 2023
This page will go through the steps necessary to run the demo 2023.

## Hardware requirements

* 4GB of RAM
* 16GB of disk space
* 2 CPU threads

## System prerequisites

- an **SSH key** registered in the ICS gitlab
- **[Docker Compose](https://docs.docker.com/engine/install/debian/)** installed (optionally [allow docker without sudo](https://docs.docker.com/engine/install/linux-postinstall/#manage-docker-as-a-non-root-user))
- **Python >= 3.11** installed (also must have installed **venv support** -> for debian its `python3-venv`)
- **git** installed

## Preparation
Clone the necessary projects:
```shell
git clone git@gitlab.ics.muni.cz:ai-dojo/ai-dojo.git ~/ai-dojo
git clone git@gitlab.ics.muni.cz:cyst/cyst-core.git ~/ai-dojo/cyst-core --depth 1 --branch v0.6.0a0
git clone git@gitlab.ics.muni.cz:cyst/cyst-platform-docker-cryton.git ~/ai-dojo/cyst-platform-docker-cryton --depth 1 --branch v0.1.1
git clone git@gitlab.ics.muni.cz:cyst/cyst-models-dojo-cryton.git ~/ai-dojo/cyst-models-dojo-cryton --depth 1 --branch v0.1.0
```

Deploy Cryton and Dr Emu:
```bash
docker compose --file ~/ai-dojo/demo-2023/docker-compose.yml up --detach
```

### CYST
Create Python virtual environment:
```shell
python3 -m venv ~/ai-dojo/cyst-models-dojo-cryton/venv
```

Install packages:
```shell
~/ai-dojo/cyst-models-dojo-cryton/venv/bin/pip install ~/ai-dojo/cyst-core
~/ai-dojo/cyst-models-dojo-cryton/venv/bin/pip install ~/ai-dojo/cyst-platform-docker-cryton
~/ai-dojo/cyst-models-dojo-cryton/venv/bin/pip install ~/ai-dojo/cyst-models-dojo-cryton
```

## Running the demo
The demo will run using a scripted actor (attacker).

Run simulation:
```shell
~/ai-dojo/cyst-models-dojo-cryton/venv/bin/python ~/ai-dojo/cyst-models-dojo-cryton/scenarios/demo_2023.py simu
```

Run emulation:
```shell
~/ai-dojo/cyst-models-dojo-cryton/venv/bin/python ~/ai-dojo/cyst-models-dojo-cryton/scenarios/demo_2023.py real
```

## Automatic deployment using Ansible
Another option how to run the demo is to use prepared [Ansible playbook](./deployment/ansible.yaml).

### Requirements
#### Control Node
- access tokens to CYST repositories and ai-dojo repository
  - role: Reporter
  - scope: read_repository
- Ansible installed
- SSH connection with SSH key authentication to managed node

#### Managed Node
- OS: Ubuntu or Debian
- hardware requirements for Demo 2023
- git installed (should be installed by default in Ubuntu or Debian)

### Steps to run the demo via Ansible
1. Check the os variable at the beginning of the [`ansible.yaml`](./deployment/ansible.yaml) and select the correct OS.
2. Run the following command:
```shell
ANSIBLE_HOST_KEY_CHECKING=False ansible-playbook -i "<IP>," -u <username> --private-key <private_key> --ssh-extra-args='-o IdentitiesOnly=yes' -e "dojo_token=<token> cyst_core_token=<token> cyst_platform_token=<token> cyst_models_token=<token>" ./deployment/ansible.yaml
```
where:
- `<IP>` is an IP address of the managed node. **Note:** Comma after the IP address is not a typo and it is necessary.
- `<username>` is username for user on the managed node.
- `<private_key>` is SSH private key for accessing managed node with the username.
- `<token>` are 4 different tokens to access needed CYST repositories and this repository. These tokens must have at least the *Reporter* role and the *read_repository* scope.
