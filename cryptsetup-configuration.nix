# Cryptsetup configutaion

{ config, ... }:

{
  # cryptsetup
  boot.initrd.luks.devices = {
    # cryptkey store
    cryptkey = {
      device = "/dev/disk/by-uuid/97a9e208-15f4-455f-9650-55663d19f771";
    };

    # encrypted root
    cryptroot = {
      device = "/dev/disk/by-uuid/a59def54-0f0c-449d-b8e9-cb9769fc8cd0";
      keyFile = "/dev/mapper/cryptkey";
    };

    # encrypted swap
    cryptswap = {
      device = "/dev/disk/by-uuid/424df30e-ff3d-4984-9265-b04374fe0244";
      keyFile = "/dev/mapper/cryptkey";
    };
  };
}
