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

  while read -r vm_name vm_address vm_options; do
    if [[ "$vm_address" == ansible_host=* ]]; then
      ssh -n -i "$ANSIBLE_SSH_KEY"         -o IdentitiesOnly=yes         -o StrictHostKeyChecking=ask         -o ConnectTimeout=10         "ansible@${vm_address#ansible_host=}" true
    fi
  done < infra/ansible/inventory.ini

  ansible-playbook \
    -i infra/ansible/inventory.ini \
    infra/ansible/setup.yml \
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
