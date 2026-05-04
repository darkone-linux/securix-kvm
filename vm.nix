# SPDX-FileCopyrightText: 2026 darkone@darkone.yt
#
# SPDX-License-Identifier: MIT

{ pkgs, terminal }:
let
  vmDisk = "securix-vm.qcow2";
  ovmf = pkgs.OVMF.fd;
in
pkgs.writeShellApplication {
  name = "run-securix-vm";
  runtimeInputs = [ pkgs.qemu ];
  text = ''
    DISK="$PWD/${vmDisk}"
    ISO="''${1:-}"
    EFIVARS="$PWD/OVMF_VARS.fd"

    if [ ! -f "$DISK" ]; then
      echo "Creating virtual disk: $DISK"
      qemu-img create -f qcow2 "$DISK" 40G
    fi

    # Persistent EFI variable storage (required for Secure Boot key enrollment)
    if [ ! -f "$EFIVARS" ]; then
      echo "Initializing EFI variables storage..."
      cp ${ovmf}/FV/OVMF_VARS.fd "$EFIVARS"
      chmod +w "$EFIVARS"
    fi

    # Override with QEMU_DISPLAY=gtk if needed.
    QEMU_DISPLAY="''${QEMU_DISPLAY:-sdl}"

    BOOT_ARGS=()
    if [ -n "$ISO" ] && [ -f "$ISO" ]; then
      echo "Booting from ISO: $ISO"
      BOOT_ARGS=(-cdrom "$ISO" -boot d)
    else
      echo "No ISO provided or file not found — booting from disk: $DISK"
    fi

    echo "Starting Securix VM..."
    qemu-system-x86_64 \
      -enable-kvm \
      -machine q35,accel=kvm \
      -m 4096 \
      -smp 4 \
      -drive if=pflash,format=raw,readonly=on,file=${ovmf}/FV/OVMF_CODE.fd \
      -drive if=pflash,format=raw,file="$EFIVARS" \
      -drive file="$DISK",format=qcow2,if=virtio \
      "''${BOOT_ARGS[@]+"''${BOOT_ARGS[@]}"}" \
      -netdev user,id=net0,hostfwd=tcp::2222-:22 \
      -device e1000,netdev=net0 \
      -vga virtio \
      -display "$QEMU_DISPLAY" \
      -usb \
      -device usb-tablet \
      "''${@:2}"
  '';
}
