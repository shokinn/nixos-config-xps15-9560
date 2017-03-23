# Boot loader configutaion

{ config, ... }:

{
  # Boot loader configuration
  boot.loader = {
    # Use systemd-boot EFI boot loader
    systemd-boot.enable = true;
    efi.canTouchEfiVariables = true;
  };
}
