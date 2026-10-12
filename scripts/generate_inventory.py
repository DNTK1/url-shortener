import ipaddress
import json
import subprocess
from pathlib import Path

repo = Path(__file__).resolve().parents[1]

result = subprocess.run(
    [
        "terraform",
        f"-chdir={repo / 'infra/terraform'}",
        "output",
        "-json",
        "vm_ipv4_addresses",
    ],
    check=True,
    stdout=subprocess.PIPE,
    text=True,
)

vms = json.loads(result.stdout)

if not vms:
    raise SystemExit("Brak VM TF")

def get_vm_ip(name, interfaces):
    addresses = set()

    for interface in interfaces:
        for address in interface:
            ip = ipaddress.IPv4Address(address)
            if not (
                ip.is_loopback
                or ip.is_link_local
                or ip.is_unspecified
                or ip.is_multicast
            ):
                addresses.add(str(ip))

    if len(addresses) != 1:
        raise SystemExit(
            f"Nie mozna wybrac jednego IP dla {name}: {sorted(addresses)}"
        )

    return addresses.pop()


repo = Path(__file__).resolve().parents[1]

result = subprocess.run(
    [
        "terraform",
        f"-chdir={repo / 'infra/terraform'}",
        "output",
        "-json",
        "vm_ipv4_addresses",
    ],
    check=True,
    stdout=subprocess.PIPE,
    text=True,
)

vms = json.loads(result.stdout)

if not vms:
    raise SystemExit("Brak VM tf")

lines = ["[url_shortener]"]

for name, interfaces in sorted(vms.items()):
    vm_ip = get_vm_ip(name, interfaces)
    lines.append(
        f"{name} ansible_host={vm_ip} ansible_user=ansible"
    )

content = "\n".join(lines) + "\n"

inventory = repo / "infra/ansible/inventory.ini"
temporary = inventory.with_suffix(".ini.tmp")

temporary.write_text(content, encoding="utf-8")
temporary.replace(inventory)

print(f"Zapisano inventory dla {len(vms)}")
