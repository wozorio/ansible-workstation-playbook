#!/usr/bin/env bash

REPO="https://github.com/wozorio/ansible-workstation-playbook.git"
REPO_NAME="$(basename "${REPO}" .git)"
INSTALL_DIR="${HOME}/${REPO_NAME}"

git clone "${REPO}" "${INSTALL_DIR}"
cd "${INSTALL_DIR}"

apt update
apt install -y make

make bootstrap
