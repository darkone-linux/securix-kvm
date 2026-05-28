# SPDX-FileCopyrightText: 2026 darkone@darkone.yt
#
# SPDX-License-Identifier: MIT

{
  sources ? import ./npins,
  pkgs ? import sources.nixpkgs { },
  securix ?
    let
      override = builtins.getEnv "NPINS_OVERRIDE_SECURIX";
      src =
        if override == "" then
          sources.securix
        else if builtins.substring 0 1 override == "/" then
          /. + override
        else
          /. + builtins.getEnv "PWD" + "/${override}";
    in
    import src { inherit pkgs; },
}:
let
  inherit (pkgs) lib;

  userModule = import ./inventory/securix.nix;
  vpn-profiles = import ./vpn-profiles.nix { inherit lib; };

  terminal = securix.lib.mkTerminal {
    name = "securix";
    userSpecificModule = userModule;
    vpnProfiles = vpn-profiles;
    modules = [
      {
        securix.graphical-interface = {
          enable = true;
          variant = "sway";
        };
        users.users.root.initialPassword = "changeme";
        users.mutableUsers = lib.mkForce true;
      }
    ];
  };

  vm = import ./vm.nix { inherit pkgs terminal; };
in
{
  inherit terminal vm;
  docs = securix.lib.mkDocs {
    users = {
      securix = userModule;
    };
    terminals = {
      securix = terminal;
    };
    inherit vpn-profiles;
  };
}
