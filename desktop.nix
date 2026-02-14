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
    chromium
    firefox
    keepassxc
    kitty
    nemo-fileroller
    nemo-with-extensions
    peazip
    texstudio
    thunderbird
    wdisplays
  ];

  nixpkgs.overlays = [
    (final: prev: {
      chromium = prev.chromium.override {
        enableWideVine = true;
      };
    })
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

  xdg = {
    mime = {
      enable = true;
      defaultApplications = {
        "inode/directory" = [ "nemo.desktop" ];
        "application/x-gnome-saved-search" = [ "nemo.desktop" ];
      };
    };
  };

  programs.steam = {
    enable = true;
  };

  services.greetd = {
    enable = true;
    settings = {
      default_session = {
        command = "${pkgs.tuigreet}/bin/tuigreet --time --cmd sway";
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
