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
        "url_shortener_ipv4_addresses",
    ],
    check=True,
    stdout=subprocess.PIPE,
    text=True,
)

interfaces = json.loads(result.stdout)

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
        f"Wiecej IP VM: {sorted(addresses)}"
    )

vm_ip = addresses.pop()

inventory = repo / "infra/ansible/inventory.ini"

content = (
    "[url_shortener]\n"
    f"url_shortener_test ansible_host={vm_ip} ansible_user=ansible\n"
)

temporary = inventory.with_suffix(".ini.tmp")
temporary.write_text(content, encoding="utf-8")
temporary.replace(inventory)

print(f"Zapisano inventory VM: {vm_ip}")
