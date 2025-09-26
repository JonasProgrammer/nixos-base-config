{
  config,
  lib,
  pkgs,
  ...
}:

{
  hardware.nvidia = {
    # Use open driver for now, sway will fail otherwise
    open = true;
  };

  # also sets for wayland
  services.xserver.videoDrivers = [ "nvidia" ];

}
