# Ansible Workstation Playbook

This playbook installs the software that I use on my Ubuntu 22.04 LTS (Jammy Jellyfish) workstation.

[![GitHub](https://img.shields.io/github/license/wozorio/ansible-workstation-setup)](https://github.com/wozorio/ansible-workstation-setup/blob/master/LICENSE)

## Supported operating systems

- Ubuntu 22.04 LTS (Jammy Jellyfish)

## Installation

1. Clone the repository and change to it:

   ```bash
   git clone https://github.com/wozorio/ansible-workstation-playbook.git && \
   cd ansible-workstation-playbook
   ```

1. Install Ansible (and eventual dependencies):

   ```bash
   make bootstrap
   ```

1. Run the playbook with default settings:

   ```bash
   make run
   ```

## Running a specific set of tagged tasks

You can filter which software to install by specifying the respective tag(s) using `ansible-playbook`'s `--tags` flag.

The tags available are:

| Tag              | Description                                                                                  |
| ---------------- | -------------------------------------------------------------------------------------------- |
| `customizations` | Perform OS customizations                                                                    |
| `devops_tools`   | Install DevOps tools such as `Helm`, `Kubectl`, `Kubens`, `Kubectx`, `Stern` and `Terraform` |
| `docker`         | Install [Docker](https://docs.docker.com/engine/install/ubuntu/)                             |
| `utils`          | Install utilities (i.e.: `jq`, `unzip`, `git`, etc)                                          |
| `zsh`            | Install [Zsh](https://www.zsh.org/)                                                          |

### Usage example

```bash
make run args='--tags "customizations, docker"'
```

```bash
make run args='--skip-tags "zsh"'
```

## Overriding variables during runtime

```bash
make run args='--extra-vars "user=wozorio"'

```
