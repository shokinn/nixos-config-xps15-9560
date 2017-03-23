# Fonts Configuration

{ config, pkgs, ... }:

{
  fonts = {
    enableFontDir = true;
    enableGhostscriptFonts = true;
    fonts = with pkgs; [
      powerline-fonts
    ];
    fontconfig = {
      enable = true;
      defaultFonts = {
          monospace = [ "Droid Sans Mono Slashed for Powerline" ];
      };
    };
  };
}
