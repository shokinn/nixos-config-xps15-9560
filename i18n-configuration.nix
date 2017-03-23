# Internationalization configuration inkl. TTY config

{ config, pkgs, ... }:

{
  i18n = {
    consoleFont = "${pkgs.powerline-fonts}/share/fonts/psf/ter-powerline-v12n.psf.gz";
    consoleKeyMap = "de-latin1-nodeadkeys";
    defaultLocale = "de_DE.UTF-8";
    consolePackages = with pkgs; [
      powerline-fonts
    ];
  };
}
