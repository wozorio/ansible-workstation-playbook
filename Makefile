# Install ansible and python3-debian
.PHONY: install
install:
	@pip install ansible \
 	&& sudo apt-get -y reinstall python3-debian

# Run the playbook with deault settings
.PHONY: run
run:
	@ansible-playbook main.yml -i inventory --ask-become-pass
