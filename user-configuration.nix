# User Configuration

{ config, pkgs, ... }:

{
  # General Users configuration
  users = {
    # Define Standard User Shell
    defaultUserShell = pkgs.zsh;
    # Set motd
    motd = "Remember, remember the 5th of November.";
    # Define a user account. Don't forget to set a password with ‘passwd’.
    extraUsers.phg = {
      isNormalUser = true;
      description = "Philip Henning";
      home = "/home/phg";
      uid = 1000;
      group = "users";
      extraGroups = [
        "adm"
        "audio"
        "cdrom"
        "dialout"
        "disk"
        "systemd-journal"
        "tty"
        "video"
        "wheel"
      ];
      initialPassword = "changeme";
      useDefaultShell = true;
    };
  };
}
