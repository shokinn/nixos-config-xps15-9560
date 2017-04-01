# X11 configuration

{ config, pkgs, ... }:

{
  # Enable the X11 windowing system
  services.xserver = {
    # Set video drivers to commercial (unfree) nvidia drivers
    # Requires "nixpkgs.config.allowUnfree = true;"
    videoDrivers = [
      "nvidia"
    ];

    #enable = true;
    layout = "de";
    xkbModel = "pc105";
    xkbVariant = "nodeadkeys";
    xkbOptions = "eurosing:e";
    #synaptics.enable = true; # Enable trackpad
    libinput.enable = true; # libinput should perform better then synaptics
 
    modules = with pkgs; [
      freetype
    ];
 
    # Define bspwm as displayManager
    displayManager.session = [ {
      name = "bspwm";
      manage = "window";
      start = "
        ${pkgs.sxhkd}/bin/sxhkd -c /etc/nixos/.config/bspwm/sxhkdrc &
        ${pkgs.bspwm}/bin/bspwm -c /etc/nixos/.config/bspwm/bspwmrc &
        ${pkgs.feh}/bin/feh --bg-center /etc/nixos/.config/bspwm/bg.png &
        ${pkgs.polybar}/bin/polybar -c /etc/nixos/.config/polybar/config example
      ";
    } ];
 
    # Set custom loginscreen theme for slim
    displayManager.slim = {
      enable = true;
      theme = pkgs.fetchurl {
        url = "https://github.com/shokinn/MinimalistForTiling-Theme-For-SliM/archive/v1.5.tar.gz";
        sha256 = "83a8335e78fb34e9d9018581030749e0c54b6af94a7e4ae175636aa0c247a41d";
      };
    };
 
    desktopManager = {
      default = "none";
      xterm.enable = false;
    };
    # do not have a desktop manager - nor powermanager, lid be managed by ACPI/systemd
    # Depricated
    # displayManager.desktopManagerHandlesLidAndPower = false;
  };
}
