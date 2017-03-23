# Networking related configutaion
 
{ config, ... }:

{
  networking = {
    # Hostname
    hostName = "midgard";
    # Domain
    domain = "sao.local";
    # Enable wireless network
    wireless.enable = true;
    # Add wifi networks to ./wifi-networks-configuratoin.nix
  };
}
