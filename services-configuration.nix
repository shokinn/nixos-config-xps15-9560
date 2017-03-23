# List services that you want to enable:

{ config, ... }:

{
  services = {
    # Enable the OpenSSH daemon.
    # openssh.enable = true;
  
    # Enable CUPS to print documents.
    # printing.enable = true;

    # Enable the X11 windowing system
    xserver.enable = true;
  };
}
