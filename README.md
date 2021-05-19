# Ansible Workstation Setup
This playbook installs the software that I use on my Ubuntu (Bionic Beaver) workstation.

## Installation
1. Clone this repo: `git clone https://github.com/wozorio/ansible-workstation-setup.git`
1. Change to the repo directory: `cd ansible-workstation-setup`
1. Install Ansible
    ```bash
    sudo apt update
    sudo apt -y install software-properties-common
    sudo add-apt-repository --yes --update ppa:ansible/ansible
    sudo apt -y install ansible
    ```
3. Run: `ansible-playbook main.yml -i inventory --ask-become-pass`
