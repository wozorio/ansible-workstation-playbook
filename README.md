# Ansible Workstation Setup
This playbook installs the software that I use on my Ubuntu (Bionic Beaver) workstation.

## Installation
1. Install Ansible
    ```bash
    sudo add-apt-repository --update --yes ppa:ansible/ansible
    sudo apt install -y software-properties-common ansible
    ```
1. Clone the repo: `git clone https://github.com/wozorio/ansible-workstation-setup.git`
1. Change to the repo directory: `cd ansible-workstation-setup`
1. Install the required Ansible roles: `ansible-galaxy install -r requirements.yml`
3. Run the playbook: `ansible-playbook main.yml -i inventory --ask-become-pass`

### Running a specific set of tagged tasks

You can filter which part of the provisioning process to run by specifying a set of tags using `ansible-playbook`'s `--tags` flag. The tags available are `docker`, `tools`, `azure-cli`, `terraform`, `kubectl` and `helm`.

```bash
ansible-playbook main.yml -i inventory --ask-become-pass --tags "tools,terraform"
```
