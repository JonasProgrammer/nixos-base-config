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
  make-link =
    pkg: path:
    let
      base = baseNameOf path;
    in
    {
      "extra-libs/${base}".source = "${pkgs."${pkg}"}/${path}";
    };
in
{
  imports = [
    ./hw-base.nix
  ]
  ++ (map (n: "${machine-specific}/${n}") (
    builtins.filter (n: (builtins.match ".*[.]nix$" n) != null) (
      builtins.attrNames (builtins.readDir machine-specific)
    )
  ));

  nixpkgs.config.packageOverrides = pkgs: {
    unstable = import <nixos-unstable> { config = config.nixpkgs.config; };
  };

  environment.systemPackages = with pkgs; [
    curl
    dig
    git
    htop
    less
    netcat-openbsd
    nixfmt-rfc-style
    tmux
    yubico-piv-tool
    yubikey-manager
  ];

  services.udev.packages = with pkgs; [
    yubikey-personalization
  ];

  services.pcscd.enable = true;

  environment.etc = lib.mergeAttrsList [
    (make-link "yubico-piv-tool" "lib/libykcs11.so")
    (make-link "opensc" "lib/opensc-pkcs11.so")
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
