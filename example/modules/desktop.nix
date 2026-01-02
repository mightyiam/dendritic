# Uses the option in `./nixos.nix` to declare a NixOS configuration.
{ config, ... }:
let
  inherit (config.flake.modules) nixos;
in
{
  configurations.nixos.desktop.module = {
    imports = [
      nixos.admin
      nixos.shell
      # ...other `nixos` modules
    ];
    nixpkgs.hostPlatform = "x86_64-linux";

    # Minimal required NixOS options for evaluation
    system.stateVersion = "25.11";
    fileSystems."/".device = "/dev/sda1";
    boot.loader.grub.devices = [ "/dev/sda" ];
    users.users.${config.username}.isNormalUser = true;
  };
}
