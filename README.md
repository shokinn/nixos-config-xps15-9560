# nixos-config
My NixOS System config for my XPS15 9560


## Crypt Setup
TODO


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
