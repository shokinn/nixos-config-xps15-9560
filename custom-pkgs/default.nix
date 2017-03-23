{ system ? builtins.currentSystem }:

let
  pkgs = import <nixpkgs> { inherit system; };

  callPackage = pkgs.lib.callPackageWith (pkgs // self);

  self = {
    keepass-keeagent = callPackage ./pkgs/keepass-plugins/keeagent { };
  };
in self 
