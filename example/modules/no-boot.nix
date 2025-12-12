{
  flake.modules.nixos.no-boot = {
    boot.loader.grub.enable = false;
    fileSystems."/".device = "/dev/no-boot";
  };
}
