# Ansible Workstation Playbook

This playbook installs the software that I use on my Ubuntu 24.04 LTS (Noble Numb) workstation.

[![GitHub](https://img.shields.io/github/license/wozorio/ansible-workstation-setup)](https://github.com/wozorio/ansible-workstation-setup/blob/master/LICENSE)

## Supported operating systems

- Ubuntu 24.04 LTS (Noble Numb)

## Installation

```bash
curl -sO https://raw.githubusercontent.com/wozorio/ansible-workstation-playbook/refs/heads/master/install.sh | && sudo bash install.sh
```

## Running the playbook

```bash
make run
```

### Tagged tasks

You can filter which software to install by specifying the respective tag(s) using `ansible-playbook`'s `--tags` flag.

The tags available are:

| Tag              | Description                                                                                  |
| ---------------- | -------------------------------------------------------------------------------------------- |
| `customizations` | Perform OS customizations                                                                    |
| `devops_tools`   | Install DevOps tools such as `Helm`, `Kubectl`, `Kubens`, `Kubectx`, `Stern` and `Terraform` |
| `docker`         | Install [Docker](https://docs.docker.com/engine/install/ubuntu/)                             |
| `utils`          | Install utilities (i.e.: `jq`, `unzip`, `git`, etc)                                          |
| `zsh`            | Install [Zsh](https://www.zsh.org/)                                                          |

## Usage example

### Running a subset of tasks only

```bash
make run args='--tags "customizations, docker"'
```

### Excluding specific tasks from execution

```bash
make run args='--skip-tags "zsh"'
```

### Overriding variables during runtime

```bash
make run args='--extra-vars "user=wozorio"'
```
