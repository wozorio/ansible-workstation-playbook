#!/usr/bin/env bash

set -e

REPO="https://github.com/wozorio/ansible-workstation-playbook.git"
REPO_NAME="$(basename "${REPO}" .git)"
INSTALL_DIR="${HOME}/${REPO_NAME}"

rm -rf "${INSTALL_DIR}"
git clone "${REPO}" "${INSTALL_DIR}"
cd "${INSTALL_DIR}"

sudo apt update
sudo apt install -y make

make bootstrap
