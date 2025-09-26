{
  config,
  lib,
  pkgs,
  ...
}:

{
  imports = [
    ./hw-desktop.nix
  ];

  environment.systemPackages = with pkgs; [
    # Utility
    grim
    slurp
    wl-clipboard
    mako
    waybar
    pavucontrol

    # Software
    firefox
    keepassxc
    kitty
    nemo
    texstudio
    thunderbird
  ];

  environment.variables.TERM = "kitty";

  services.gnome.gnome-keyring.enable = true;
  services.gvfs.enable = true;

  fonts.packages = with pkgs; [
    nerd-fonts.jetbrains-mono
    font-awesome
    noto-fonts-cjk-sans
    noto-fonts-cjk-serif
  ];

  programs.sway = {
    enable = true;
    wrapperFeatures.gtk = true;
    extraOptions = [
      "--unsupported-gpu"
    ];
  };

  programs.steam = {
    enable = true;
  };

  services.greetd = {
    enable = true;
    settings = {
      default_session = {
        command = "${pkgs.greetd.tuigreet}/bin/tuigreet --time --cmd sway";
      };
    };
  };

  services.pipewire = {
    enable = true;
    pulse.enable = true;
  };

  security.polkit.enable = true;
  security.pam.services.greetd.enableGnomeKeyring = true;

}
