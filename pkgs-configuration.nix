# Packages to install

{ config, pkgs, ... }:


let custompkgs = import ./custom-pkgs/default.nix {}; in
{
  # Allow unfree packages
  nixpkgs.config.allowUnfree = true;

  # List packages installed in system profile. To search by name, run:
  # $ nix-env -qaP | grep wget
  # TODO may group by functoin?
  environment.systemPackages = with pkgs; [
    alsaUtils
    bspwm # X11
    conky # X11
    dmenu # X11
    firefox
    gptfdisk
    git
    htop
    keepass
    #keepass-keefox # Keepass plugin 
    lynx
    mkpasswd
    polybar # X11
    rxvt_unicode
    screen
    sudo
    sutils # X11
    sxhkd # X11
    vim
    wget
    xdo # X11
    xdotool # Für Keepass
    xfontsel
    xlsfonts
    xorg.mkfontdir
    xorg.xbacklight # Backlight control
    xorg.xprop
    xtitle # X11
    zsh
  ];
  nixpkgs.config.packageOverrides = pkgs: {
    # Keepass plugin Overrides
    keepass = pkgs.keepass.override {
      # Just leave you plugin-packages here
      plugins = [
        pkgs.keepass-keefox
        pkgs.keepass-keepasshttp
        custompkgs.keepass-keeagent
      ];
    };
  };
}
