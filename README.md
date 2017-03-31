# DELL XPS 15 9560 - NixOS configuration
My NixOS System config for my XPS15 9560


## Documents
* [Repair manual](http://topics-cdn.dell.com/pdf/xps-15-9560-laptop_setup%20guide_en-us.pdf)


## Crypt Setup
I used the cryptsetup from [@grahamc (Graham Christensen)](https://github.com/grahamc)

### Disks

If you don't have devices at `/dev/nvme_*` you forgot to turn off RAID
mode, or you're on your own...

You'll want to use ~gdisk~ on `/dev/nvme0n1`, I found this via ~lsblk~,
as according to the UEFI instructions in the manual.

I then deleted partitions 2 through 6, leaving only 500M EFI system
partition, and created partitions so it looked like:

| Partition | Size                  | Code   | Purpose                  |
|-----------|-----------------------|--------|--------------------------|
|         1 | 500 MiB               | `EF00` | EFI partition            |
|         2 | 3 MiB                 | `8300` | cryptsetup luks key      |
|         3 | 16 GiB                | `8300` | swap space (hibernation) |
|         4 | remaining (460.4 GiB) | `8300` | root filesystem          |

Note I use `8300` as the code because they're all encrypted. Calling
the swap partition swap, systemd will try to automatically use it.

Then:

```text
# Create an encrypted disk to hold our key, the key to this drive
# is what you'll type in to unlock the rest of your drives... so,
# remember it:
$ cryptsetup luksFormat /dev/nvme0n1p2
$ cryptsetup luksOpen /dev/nvme0n1p2 cryptkey

# Fill our key disk with random data, wihch will be our key:
$ dd if=/dev/random of=/dev/mapper/cryptkey bs=1024 count=14000

# Use the encrypted key to create our encrypted swap:
$ cryptsetup luksFormat --key-file=/dev/mapper/cryptkey /dev/nvme0n1p3

# Create an encrypted root with a key you can remember.
$ cryptsetup luksFormat /dev/nvme0n1p4
# Now add the cryptkey as a decryption key to the root partition, this
# way you can only decrypt the cryptkey on startup, and use the
# cryptkey to decrypt the root.
#
# The first human-rememberable key we added is just in case.
$ cryptsetup luksAddKey /dev/nvme0n1p4 /dev/mapper/cryptkey

# Now we open the swap and the root and make some filesystems.
$ cryptsetup luksOpen --key-file=/dev/mapper/cryptkey /dev/nvme0n1p3 cryptswap
$ mkswap /dev/mapper/cryptswapex

$ cryptsetup luksOpen --key-file=/dev/mapper/cryptkey /dev/nvme0n1p4 cryptroot
$ mkfs.ext4 /dev/mapper/cryptroot

# and rebuild the boot partition:
$ mkfs.vfat /dev/nvme0n1p1
```

Then for a not fun bit, matching entries in `/dev/disk/by-uuid/` to
the partitions we want to mount where. Running ~ls -l
/dev/disk/by-uuid/~ shows which devices have which UUIDs. To determine
what `dm-1` and `dm2`, I ran ~ls -la /dev/mapper~:

| name                                   | symlink to  | note                |
|----------------------------------------|-------------|---------------------|
| `1234-5678`                            | `sda2`      | installer           |
| `1970-01-01-00-00-01-00`               | `sda1`      | installer           |
| `AAAA-AAAA`                            | `nvme0n1p1` | /boot               |
| `BBBBBBBB-BBBB-BBBB-BBBB-BBBBBBBBBBBB` | `nvme0n1p2` | encrypted cryptkey  |
| `CCCCCCCC-CCCC-CCCC-CCCC-CCCCCCCCCCCC` | `nvme0n1p3` | encrypted cryptswap |
| `DDDDDDDD-DDDD-DDDD-DDDD-DDDDDDDDDDDD` | `nvme0n1p4` | encrypted cryptroot |
| `EEEEEEEE-EEEE-EEEE-EEEE-EEEEEEEEEEEE` | `dm-1`      | decrypted cryptswap |
| `FFFFFFFF-FFFF-FFFF-FFFF-FFFFFFFFFFFF` | `dm-2`      | decrypted cryptroot |

Note I do have a `dm-0` for `cryptkey`, but no UUID but we won't need
it. I substituted the actual hash with `A`s `B`s `C`s `D`s `E`s and
`F`s in order to make the mount commands easier.

```text
# Enable swap using the decrypted cryptswap:
$ swapon /dev/disk/by-uuid/EEEEEEEE-EEEE-EEEE-EEEE-EEEEEEEEEEEE

# Mount the decrypted cryptroot to /mnt
$ mount /dev/disk/by-uuid/FFFFFFFF-FFFF-FFFF-FFFF-FFFFFFFFFFFF /mnt

# Setup and mount the boot partition
a
$ mkdir /mnt/boot
$ mount /dev/disk/by-uuid/AAAA-AAAA /mnt/boot
```

## Initial Configuration

Run ~nixos-generate-config --root /mnt~

### `hardware-configuration.nix` changes

I had to edit the `hardware-configuration.nix` to setup the luks
configuration. I did this with ~nix-shell -p emacs~, deleted the
`boot.initrd.luks.devices` line, and added:

```nix
{
  # !!! cryptkey must be done first, and the list seems to be
  # alphabetically sorted, so take care that cryptroot / cryptswap,
  # whatever you name them, come after cryptkey.
  boot.initrd.luks.devices = {
    cryptkey = {
      device = "/dev/disk/by-uuid/BBBBBBBB-BBBB-BBBB-BBBB-BBBBBBBBBBBB";
    };

    cryptroot = {
      device = "/dev/disk/by-uuid/DDDDDDDD-DDDD-DDDD-DDDD-DDDDDDDDDDDD";
      keyFile = "/dev/mapper/cryptkey";
    };

    cryptswap = {
      device = "/dev/disk/by-uuid/CCCCCCCC-CCCC-CCCC-CCCC-CCCCCCCCCCCC";
      keyFile = "/dev/mapper/cryptkey";
    };
  };
}
```

It should already be correct, but check that:

1. `swapDevices` refers to
   `/dev/disk/by-uuid/EEEEEEEE-EEEE-EEEE-EEEE-EEEEEEEEEEEE`
2. `fileSystems."/boot".device` refers to
   `/dev/disk/by-uuid/AAAA-AAAA`
3. `fileSystems."/".device` refers to
   `/dev/disk/by-uuid/FFFFFFFF-FFFF-FFFF-FFFF-FFFFFFFFFFFF`

Source: <https://gist.github.com/grahamc/fba67370053acc01ac216a6e4b73d308#disks>


## wifi-network-configuration.nix
If you want to use Wifi you have to create an "wifi-network-configuration.nix" file. This is an example

```nix
# Wifi networks configuratoin

{ config, ... }:

{
  # Add wifi networks to wpa_supplicant
  networking.wireless.networks = {
    # SSID of the network
    # German Free Wifi in ICE Trains
    WIFIonICE = { };
    # If you want to use a wifi network with pre-shared key use this example
    # PSK example
    Wifi_SSID = {
      psk="yourPskHere";
    };
  };
}
```
