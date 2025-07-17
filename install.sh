#!/usr/bin/env bash

set -e

readonly REPO_URL="https://github.com/wozorio/ansible-workstation-playbook.git"

readonly BLUE="\033[34;1m"
readonly YELLOW="\033[33;1m"

log() {
    local MSG="${1}"
    echo "${MSG}" 1>&2
}

log_blue() {
    local MSG="${1}"
    echo -e "${BLUE} ${MSG}" 1>&2
}

log_yellow() {
    local MSG="${1}"
    echo -e "${YELLOW} ${MSG}" 1>&2
}

is_make_installed() {
    if command -v make &>/dev/null; then
        log "INFO: make is already installed"
        echo 1
    else
        log "INFO: make is not installed"
        echo 0
    fi
}

install_make() {
    log "INFO: Installing make"
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

    log_blue
    log_blue "INFO: Ansible has been successfully installed!"
    log_blue

    log_yellow "WARN: Before running the playbook for the first time, please"
    log_yellow "      run 'source ~/.bashrc' to ensure paths recently added"
    log_yellow "      to the PATH are loaded."
    log_yellow
}

main
