#!/usr/bin/env bash
set -euo pipefail

cd -- "$(dirname -- "${BASH_SOURCE[0]}")"

ANSIBLE_SSH_KEY="${ANSIBLE_SSH_KEY:-$HOME/.ssh/id_ed25519}"

init_terraform() {
  : "${PROXMOX_VE_ENDPOINT:?Ustaw PROXMOX_VE_ENDPOINT}"
  : "${PROXMOX_VE_API_TOKEN:?Ustaw PROXMOX_VE_API_TOKEN}"

  terraform -chdir=infra/terraform init -input=false
  terraform -chdir=infra/terraform validate
}

configure_vm() {
  ansible-galaxy collection install -r infra/ansible/requirements.yml

  python3 scripts/generate_inventory.py

  ansible-playbook \
    -i infra/ansible/inventory.ini \
    infra/ansible/site.yml \
    --private-key "$ANSIBLE_SSH_KEY" \
    --ssh-common-args='-o IdentitiesOnly=yes'
}

case "${1:-}" in
  plan)
    init_terraform
    terraform -chdir=infra/terraform plan
    ;;
  configure)
    configure_vm
    ;;
  up)
    init_terraform
    terraform -chdir=infra/terraform apply
    configure_vm
    ;;
  *)
    echo "Uzycie: $0 plan|configure|up" >&2
    exit 1
    ;;
esac
