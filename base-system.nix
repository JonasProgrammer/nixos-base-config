# Edit this configuration file to define what should be installed on
# your system. Help is available in the configuration.nix(5) man page, on
# https://search.nixos.org/options and in the NixOS manual (`nixos-help`).

{
  config,
  lib,
  pkgs,
  ...
}:
let
  machine-specific = ./machine-specific.d;
in
{
  imports = [
    ./hw-base.nix
    ./gpg-yubi.nix
  ]
  ++ (map (n: "${machine-specific}/${n}") (
    builtins.filter (
      n: (builtins.match ".*[.]nix$" n) != null && (builtins.match ".*[.]helper[.]nix$" n) == null
    ) (builtins.attrNames (builtins.readDir machine-specific))
  ));

  nixpkgs.config.packageOverrides = pkgs: {
    unstable = import <nixos-unstable> { config = config.nixpkgs.config; };
  };

  environment.systemPackages = with pkgs; [
    cached-nix-shell
    curl
    dig
    ethtool
    git
    htop
    less
    net-tools
    netcat-openbsd
    nixfmt-rfc-style
    openssl
    tmux
    usbutils
  ];

  programs = {
    vim = {
      enable = true;
      defaultEditor = true;
    };
    nix-ld = {
      enable = true;
      libraries =
        with pkgs;
        [
          xorg.libxcb
          xorg.xcbutilcursor # libxcb-cursor
          libsecret
          libsecret.dev
        ]
        ++ (appimageTools.defaultFhsEnvArgs.multiPkgs pkgs);

    };
  };
}
