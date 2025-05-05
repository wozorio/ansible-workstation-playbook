#!/usr/bin/env bash

set -e

readonly REPO_URL="https://github.com/wozorio/ansible-workstation-playbook.git"

is_make_installed() {
    if command -v make &> /dev/null; then
        echo 1
    else
        echo 0
    fi
}

install_make() {
    sudo apt update
    sudo apt install -y make
}

main() {
    local REPO_NAME
    REPO_NAME="$(basename "${REPO_URL}" .git)"

    local INSTALL_DIR="${HOME}/${REPO_NAME}"

    if [[ $(is_make_installed) -eq 0 ]]; then
        install_make
    fi

    rm -rf "${INSTALL_DIR}"
    git clone --depth 1 "${REPO_URL}" "${INSTALL_DIR}"
    cd "${INSTALL_DIR}"

    make bootstrap
}

main
