# SPDX-FileCopyrightText: 2026 darkone@darkone.yt
#
# SPDX-License-Identifier: MIT

{ pkgs, ... }:
{
  securix.self = {
    selfDescriptionType = "both";
    mainDisk = "/dev/vda";

    machine = {
      serialNumber = "SECURIX001";
      inventoryId = 1;
      hardwareSKU = "qemu-vm";
      users = [ "darkone" ];
    };

    user = {
      email = "darkone@darkone.yt";
      username = "darkone";
      hashedPassword = "$2b$12$z9xJHXqzxJLvUByJBzk7hOnI/hPhOQVBo1Wjv/T.zHzYYg0P/J1N2";
      u2f_keys = [ ];
      bit = 1;
      allowedVPNs = [ ];
      teams = [ "admin" ];
    };
  };
}
