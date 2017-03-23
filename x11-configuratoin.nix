# X11 configuration

{ config, pkgs, ... }:

{
  # Enable the X11 windowing system
  services.xserver = {
    # Set video drivers to commercial (unfree) nvidia drivers
    # Requires "nixpkgs.config.allowUnfree = true;"
    videoDrivers = [
      "nvidia"
      "intel"
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
        ${pkgs.bspwm}/bin/bspwm -c /etc/nixos/.config/bspwm/bspwmrc
      ";
      #start = "
      #  ${pkgs.sxhkd}/bin/sxhkd -c /etc/nixos/bspwm/sxhkdrc &
      #  ${pkgs.bspwm}/bin/bspwm -c /etc/nixos/bspwm/bspwmrc &
      #  /etc/nixos/bspwm/bspwm_panel/panel
      #";
    } ];
 
    # Set custom loginscreen theme for slim
    displayManager.slim = {
      enable = true;
      theme = pkgs.fetchurl {
        url = "https://github.com/shokinn/MinimalistForTiling-Theme-For-SliM/archive/v1.3.tar.gz";
        sha256 = "bb8254f2d49133db58a58f1b4c424ad49a90f58815b351764a866dee96ee1b2d";
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
