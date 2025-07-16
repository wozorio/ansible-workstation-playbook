SHELL = /usr/bin/env bash

export PATH := $(PATH):$(HOME)/.local/bin

.DEFAULT_GOAL = run

# Update the apt cache
.PHONY: update-apt
update-apt:
	@sudo apt-get update

# Set up uv
.PHONY: setup-uv
setup-uv:
	@curl -LsSf https://astral.sh/uv/install.sh | sh
	@IS_UV_BIN_DIR_IN_PATH=$$(grep -c 'PATH=$$PATH:$$HOME/.local/bin' $(HOME)/.zshrc); \
	if [[ $$IS_UV_BIN_DIR_IN_PATH -eq 0 ]]; then \
		echo "adding uv bin directory to the PATH"; \
		echo -e "\n# add uv to the PATH" >> $(HOME)/.zshrc; \
		echo 'export PATH=$$PATH:$$HOME/.local/bin' >> $(HOME)/.zshrc; \
	else \
		echo "uv bin directory already set in the PATH"; \
	fi

# Set up ansible
.PHONY: setup-ansible
setup-ansible:
	@uv tool install ansible
	@uv tool install ansible-core
	@uv tool install ansible-lint
	@ansible-galaxy collection install community.general --force

# Reinstall python3-debian
.PHONY: reinstall-python3-debian
reinstall-python3-debian: update-apt
	@sudo apt-get -y reinstall python3-debian

# Bootstrap the machine
.PHONY: bootstrap
bootstrap: setup-uv setup-ansible reinstall-python3-debian

# Lint the playbook
.PHONY: lint
lint:
	@ansible-playbook -i inventory --syntax-check main.yml
	@ansible-lint

# Run the playbook in dry-run mode
.PHONY: dry-run
dry-run:
	@ansible-playbook -i inventory --diff --check --ask-become-pass $(args) main.yml

# Run the playbook
.PHONY: run
run:
	@ansible-playbook -i inventory --diff --ask-become-pass $(args) main.yml
