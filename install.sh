#!/usr/bin/env bash

set -e

readonly REPO_URL="https://github.com/wozorio/ansible-workstation-playbook.git"

log_info() {
    local MSG="${1}"
    echo -e "\033[37;1m ${MSG}" 1>&2
}

log_warning() {
    local MSG="${1}"
    echo -e "\033[33;1m ${MSG}" 1>&2
}

is_make_installed() {
    if command -v make &>/dev/null; then
        log_info "INFO: make is already installed"
        echo 1
    else
        log_info "INFO: make is not installed"
        echo 0
    fi
}

install_make() {
    log_info "INFO: Installing make"
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

    log_info
    log_info "INFO: Ansible has been successfully installed"
    log_warning
    log_warning "WARN: Before running the playbook, please restart the shell"
    log_warning "      to ensure paths recently added to the PATH are loaded."
}

main
