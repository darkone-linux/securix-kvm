#!/usr/bin/env bash
set -euo pipefail

cd "$(dirname "$0")"

echo "1. Checks..."
nix-instantiate --parse default.nix

echo "2. Construction de la configuration système (dry-run)..."
nix-build -A terminal.system --dry-run 2>&1 | head -20

echo "3. Construction de l'ISO..."
nix-build -A terminal.installer

echo "4. Création du disque VM si nécessaire..."
if [ ! -f securix-vm.qcow2 ]; then
  qemu-img create -f qcow2 securix-vm.qcow2 40G
fi

echo "ISO: ./result/iso/*.iso"
echo "Lancer la VM: nix-shell --run \"run-securix-vm ./result/iso/*.iso\""
