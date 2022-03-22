# Ansible Workstation Setup

This playbook installs the software that I use on my Ubuntu (Bionic Beaver) workstation.

[![GitHub](https://img.shields.io/github/license/wozorio/ansible-workstation-setup)](https://github.com/wozorio/ansible-workstation-setup/blob/master/LICENSE)

## Installation

1. Install Ansible
    ```
    sudo add-apt-repository --update --yes ppa:ansible/ansible
    sudo apt install -y software-properties-common ansible
    ```
1. Clone the repo: `git clone https://github.com/wozorio/ansible-workstation-setup.git`
1. Change to the repo directory: `cd ansible-workstation-setup`
1. Install the required Ansible roles: `ansible-galaxy install -r requirements.yml -f`
1. Run the playbook: `ansible-playbook main.yml -i inventory --ask-become-pass`

## Running a specific set of tagged tasks

You can filter which part of the provisioning process to run by specifying a set of tags using `ansible-playbook`'s `--tags` flag.

The tags available are:

|Tag|Description|
|---|---|
|`azure-cli`|Install azure-cli|
|`customizations`|Perform various OS customizations|
|`docker`|Install [Docker](https://docs.docker.com/engine/install/ubuntu/)|
|`helm`|Install [Helm](https://helm.sh/)|
|`kubectl`|Install [kubectl](https://kubernetes.io/docs/tasks/tools/install-kubectl-linux/)|
|`kubens` |Install [kubens](https://github.com/ahmetb/kubectx/)|
|`kubectx` |Install [kubectx](https://github.com/ahmetb/kubectx/)|
|`stern`|Install [Stern](https://github.com/wercker/stern)|
|`terraform`|Install [Terraform](https://www.terraform.io/)|
|`terragrunt`|Install [Terragrunt](https://terragrunt.gruntwork.io/)|
|`tools`|Install various tools and utilities (i.e.: `jq`, `unzip`, `git`, etc)|
|`zsh`|Install [Zsh](https://www.zsh.org/)|

### Usage example

```
ansible-playbook main.yml -i inventory --ask-become-pass --tags "tools, terraform"
```

### Known issues
1. If adding Ansible repository public key with `sudo add-apt-repository --update --yes ppa:ansible/ansible` fails, try adding it manually: `curl -sL "http://keyserver.ubuntu.com/pks/lookup?op=get&search=0x93C4A3FD7BB9C367" | sudo apt-key add`
