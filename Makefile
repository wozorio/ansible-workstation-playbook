SHELL = /usr/bin/env bash

# Install Pipx, Ansible, ansible-lint and python3-debian
.PHONY: bootstrap
bootstrap:
	@sudo apt-get update && \
	sudo apt-get install -y pipx && \
	pipx install ansible && \
	pipx install ansible-lint && \
	ansible-galaxy collection install community.general && \
 	sudo apt-get -y reinstall python3-debian

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
