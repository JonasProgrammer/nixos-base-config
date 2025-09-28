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
  make-link = pkg: path: let base = baseNameOf path; in { "extra-libs/${base}".source = "${pkgs."${pkg}"}/${path}"; };
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

  environment.systemPackages = with pkgs; [
    curl
    dig
    git
    less
    netcat-openbsd
    nixfmt-rfc-style
    yubikey-manager
    yubico-piv-tool
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
  };
}
