SHELL = /usr/bin/env bash

# Update the apt cache
.PHONY: update-apt
update-apt:
	@sudo apt-get update

# Set up pipx
.PHONY: setup-pipx
setup-pipx:
	@sudo apt-get install -y pipx && \
	pipx ensurepath

# Set up ansible
.PHONY: setup-ansible
setup-ansible:
	@pipx install --include-deps ansible && \
	pipx install ansible-lint && \
	ansible-galaxy collection install community.general

# Reinstall python3-debian
.PHONY: reinstall-python3-debian
reinstall-python3-debian:
	@sudo apt-get -y reinstall python3-debian

# Bootstrap the machine
.PHONY: bootstrap
bootstrap: update-apt setup-pipx setup-ansible reinstall-python3-debian

# Lint the playbook
.PHONY: lint
lint:
	@ansible-playbook -i inventory --syntax-check main.yml && \
	ansible-lint

# Run the playbook in dry-run mode
.PHONY: dry-run
dry-run:
	@ansible-playbook -i inventory --diff --check --ask-become-pass $(args) main.yml

# Run the playbook
.PHONY: run
run:
	@ansible-playbook -i inventory --diff --ask-become-pass $(args) main.yml
