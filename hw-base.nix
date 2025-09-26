{
  lib,
  config,
  pkgs,
  ...
}:

{

  # Enable non-free firmware
  hardware.enableAllFirmware = true;
  hardware.enableRedistributableFirmware = true;
  hardware.cpu.intel.updateMicrocode = true;
  # Allow all SysReq keys for now
  boot.kernel.sysctl."kernel.sysrq" = 1;

}
