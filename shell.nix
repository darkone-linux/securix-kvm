# SPDX-FileCopyrightText: 2026 darkone@darkone.yt
#
# SPDX-License-Identifier: MIT

{
  sources ? import ./npins,
  pkgs ? import sources.nixpkgs { },
}:
let
  attrs = import ./. { inherit pkgs; };
in
pkgs.mkShell {
  nativeBuildInputs = [ attrs.vm ];
  shellHook = ''
    echo "Securix VM environment loaded."
    echo "Run: run-securix-vm ./result/iso/*.iso"
  '';
}
