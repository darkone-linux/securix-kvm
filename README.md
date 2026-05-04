# Securix KVM / Qemu

![Sécurix](assets/securix.png)

## Utilisation

```bash
# Paramétrer
vim inventory/securix.nix
vim default.nix

# Construire l'ISO installateur
nix-build -A terminal.installer

# Lancer la VM avec l'ISO
nix-shell --run "run-securix-vm ./result/iso/*.iso"

# Lancer la VM
nix-shell --run "run-securix-vm"
```
