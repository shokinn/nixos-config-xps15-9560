# Packages to install

{ config, pkgs, ... }:

# Local custom package repo
let custompkgs = import ./custom-pkgs/default.nix {}; in
{
  # Allow unfree packages
  nixpkgs.config.allowUnfree = true;

  # List packages installed in system profile. To search by name, run:
  # $ nix-env -qaP | grep wget
  # TODO may group by functoin?
  environment.systemPackages = [
    pkgs.alsaUtils
    pkgs.bspwm # X11
    pkgs.conky # X11
    pkgs.dmenu # X11
    pkgs.exfat
    pkgs.firefox
    pkgs.git
    pkgs.glxinfo
    pkgs.gptfdisk
    pkgs.htop
    pkgs.hugo
    pkgs.keepass
    pkgs.lynx
    pkgs.mc
    pkgs.mkpasswd
    pkgs.polybar # X11
    pkgs.powertop
    pkgs.rxvt_unicode
    pkgs.screen
    pkgs.softether
    pkgs.spotify
    pkgs.sudo
    pkgs.sutils # X11
    pkgs.sxhkd # X11
    pkgs.unzip
    pkgs.vim
    pkgs.wget
    pkgs.xdo # X11
    pkgs.xdotool # For KeePass (strg+v typing)
    pkgs.xfontsel
    pkgs.xlsfonts
    pkgs.xorg.mkfontdir
    pkgs.xorg.xbacklight # Backlight control
    pkgs.xorg.xprop
    pkgs.xtitle # X11
    pkgs.zsh
  ];
  nixpkgs.config.packageOverrides = pkgs: {
    # Keepass plugin Overrides
    keepass = pkgs.keepass.override {
      # Just leave your plugin-packages here
      plugins = [
        pkgs.keepass-keefox
        pkgs.keepass-keepasshttp
        pkgs.keepass-keeagent
      ];
    };
  };
}
