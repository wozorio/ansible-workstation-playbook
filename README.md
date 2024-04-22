# Ansible Workstation Playbook

This playbook installs the software that I use on my Ubuntu 22.04 LTS (Jammy Jellyfish) workstation.

[![GitHub](https://img.shields.io/github/license/wozorio/ansible-workstation-setup)](https://github.com/wozorio/ansible-workstation-setup/blob/master/LICENSE)

## Installation

1. Install Ansible:

   ```bash
   pip install ansible
   sudo apt -y install python3-debian
   ```

1. Clone the repository:

   ```bash
   git clone https://github.com/wozorio/ansible-workstation-playbook.git
   ```

1. Change to the repository directory:

   ```bash
   cd ansible-workstation-playbook
   ```

1. Run the playbook:

   ```bash
   ansible-playbook main.yml -i inventory --ask-become-pass
   ```

## Running a specific set of tagged tasks

You can filter which software to install by specifying the respective tag(s) using `ansible-playbook`'s `--tags` flag.

The tags available are:

| Tag              | Description                                                                                                |
| ---------------- | ---------------------------------------------------------------------------------------------------------- |
| `customizations` | Perform OS customizations                                                                                  |
| `devops_tools`   | Install DevOps tools such as `Helm`, `Kubectl`, `Kubens`, `Kubectx`, `Stern`, `Terraform` and `Terragrunt` |
| `docker`         | Install [Docker](https://docs.docker.com/engine/install/ubuntu/)                                           |
| `utils`          | Install utilities (i.e.: `jq`, `unzip`, `git`, etc)                                                        |
| `zsh`            | Install [Zsh](https://www.zsh.org/)                                                                        |

### Usage example

```bash
ansible-playbook main.yml -i inventory --ask-become-pass --tags "customizations, docker"
```

```bash
ansible-playbook main.yml -i inventory --ask-become-pass --skip-tags "zsh"
```

## Overriding variables during runtime

```bash
ansible-playbook main.yml -i inventory --ask-become-pass --extra-vars "user=wozorio"
```

## Supported operating systems

- Ubuntu 22.04 LTS (Jammy Jellyfish)
