#!/usr/bin/env bash

set -e

readonly REPO_URL="https://github.com/wozorio/ansible-workstation-playbook.git"

readonly WHITE="\033[37;1m"
readonly YELLOW="\033[33;1m"

log_white() {
    local MSG="${1}"
    echo -e "${WHITE} ${MSG}" 1>&2
}

log_yellow() {
    local MSG="${1}"
    echo -e "${YELLOW} ${MSG}" 1>&2
}

is_make_installed() {
    if command -v make &>/dev/null; then
        log_white "INFO: make is already installed"
        echo 1
    else
        log_white "INFO: make is not installed"
        echo 0
    fi
}

install_make() {
    log_white "INFO: Installing make"
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
    log_info

    log_yellow "WARN: Before running the playbook, run 'source ~/.bashrc'"
    log_yellow "      to ensure paths recently added to the PATH are loaded."
    log_yellow
}

main
