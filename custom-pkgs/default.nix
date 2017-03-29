{ system ? builtins.currentSystem }:

let
  pkgs = import <nixpkgs> { inherit system; };

  callPackage = pkgs.lib.callPackageWith (pkgs // self);

  self = {
    #<pkg-name> = callPackage ./pkgs/<pkg> { };
  };
in self 
