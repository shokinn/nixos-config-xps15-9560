# Environment Configuratoin

{ config, ... }:

{
  environment.sessionVariables = {
    PANEL_FIFO = "/tmp/panel-fifo"; # Tempfile for panel-fifo. Needed for bspwm!
    PATH = "$PATH:/etc/nixos/bspwm/bspwm_panel/"; # Add path to bspwm_panel dir Needed for bspwm!
  };
}
