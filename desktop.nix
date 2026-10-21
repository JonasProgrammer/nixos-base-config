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
    libreoffice
    nemo-fileroller
    nemo-with-extensions
    peazip
    texstudio
    thunderbird
    wdisplays

    # Scanning
    #gscan2pdf
    #sane-backends
    #sane-frontends
  ];

  nixpkgs.overlays = [
    (final: prev: {
      chromium = prev.chromium.override {
        enableWideVine = true;
      };
    })
  ];

  services.gnome.gnome-keyring.enable = true;
  services.gvfs.enable = true;

  fonts.packages = with pkgs; [
    nerd-fonts.jetbrains-mono
    font-awesome
    noto-fonts-cjk-sans
    noto-fonts-cjk-serif
  ];

  environment.variables.TERM = "foot";

  programs.foot = {
    enable = true;
    settings = {
      main = {
        font = "JetBrainsMono Nerd Font Mono:size=12";
      };
      scrollback = {
        lines = 10000;
      };
    };
  };

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

  services.xserver = {
    # Makes the generated XKB configuration available to other
    # consumers under /etc/X11/xkb.
    exportConfiguration = true;

    xkb.extraLayouts.us-umlaut = {
      description = "English (US, AltGr German umlauts)";
      languages = [ "eng" ];

      symbolsFile = pkgs.writeText "us-umlaut" ''
        partial alphanumeric_keys

        xkb_symbols "basic" {
          # Retain the normal US layout.
          include "us(basic)"

          # Right Alt becomes AltGr / Level 3.
          include "level3(ralt_switch)"

          # AltGr+A -> ä, AltGr+Shift+A -> Ä
          key <AC01> {
            type[Group1] = "FOUR_LEVEL_ALPHABETIC",
            [ a, A, adiaeresis, Adiaeresis ]
          };

          # AltGr+O -> ö, AltGr+Shift+O -> Ö
          key <AD09> {
            type[Group1] = "FOUR_LEVEL_ALPHABETIC",
            [ o, O, odiaeresis, Odiaeresis ]
          };

          # AltGr+U -> ü, AltGr+Shift+U -> Ü
          key <AD07> {
            type[Group1] = "FOUR_LEVEL_ALPHABETIC",
            [ u, U, udiaeresis, Udiaeresis ]
          };

          # AltGr+S -> ß, AltGr+Shift+S -> ẞ
          key <AC02> {
            type[Group1] = "FOUR_LEVEL_ALPHABETIC",
            [ s, S, ssharp, U1E9E ]
          };
        };
      '';
    };
  };

  security.polkit.enable = true;
  security.pam.services.greetd.enableGnomeKeyring = true;

}
