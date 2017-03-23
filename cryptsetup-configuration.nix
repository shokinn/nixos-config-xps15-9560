# Cryptsetup configutaion

{ config, ... }:

{
  # cryptsetup
  boot.initrd.luks.devices = {
    # cryptkey store
    cryptkey = {
      device = "/dev/disk/by-uuid/ae4dc299-f8a5-4697-92b4-5659ee546d34";
    };

    # encrypted root
    cryptroot = {
      device = "/dev/disk/by-uuid/b9eeb766-4ef4-4e47-9fe3-f424b342d82f";
      keyFile = "/dev/mapper/cryptkey";
    };

    # encrypted swap
    cryptswap = {
      device = "/dev/disk/by-uuid/0129d5cb-baba-42cb-8695-a5dab454c202";
      keyFile = "/dev/mapper/cryptkey";
    };
  };
}
