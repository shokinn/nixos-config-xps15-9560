# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).
   
{ config, pkgs, ... }:
     
{
  imports = [
    # Add Cryptsetup
    ./cryptsetup-configuration.nix
    # Include the results of the hardware scan.
    ./hardware-configuration.nix
    # Boot loader configuratoin
    ./boot_loader-configuration.nix
    # Networking related configuration
    ./networking-configuration.nix
    # Wifi networks for wpa_supplicant
    ./wifi-network-configuration.nix
    # Internationalization configuration inkl. TTY config
    ./i18n-configuration.nix
    # Miscellaneous configuration
    ./misc-configuration.nix
    # Packages to install
    ./pkgs-configuration.nix
    # Services configuratoin
    ./services-configuration.nix
    # X11 configuration
    ./x11-configuratoin.nix
    # User Configuratoin
    ./user-configuration.nix
    # Font Configuration
    ./fonts-configuraton.nix
    # Environment Configuratoin
    ./env-configuration.nix
  ];

  # The NixOS release to be compatible with for stateful data such as databases.
  system.stateVersion = "17.03";
}
