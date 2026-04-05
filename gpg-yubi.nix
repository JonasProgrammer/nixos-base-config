{
  config,
  lib,
  pkgs,
  ...
}:
let
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
  hardware.gpgSmartcards.enable = true;

  environment.systemPackages = with pkgs; [
    gnupg
    libfido2
    opensc
    pcsclite
    pinentry-curses
    yubico-piv-tool
    yubikey-agent
    yubikey-manager
  ];

  services = {
    udev.packages = with pkgs; [
      yubikey-personalization
    ];
    pcscd.enable = true;
    yubikey-agent.enable = true;
  };

  programs.gnupg.agent = {
    enable = true;
    enableSSHSupport = true;
    pinentryPackage = pkgs.pinentry-curses;
  };

  environment.etc = lib.mergeAttrsList [
    (make-link "yubico-piv-tool" "lib/libykcs11.so")
    (make-link "opensc" "lib/opensc-pkcs11.so")
  ];
}
