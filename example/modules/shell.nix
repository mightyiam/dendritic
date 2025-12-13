# Default shell for the user across NixOS and Android
{ config, lib, ... }:
{
  flake.modules = {
    nixos.pc = nixosArgs: {
      programs.fish.enable = true;
      users.users.${config.username}.shell = nixosArgs.config.programs.fish.package;
    };

    nixOnDroid.base =
      { pkgs, ... }:
      {
        user.shell = lib.getExe pkgs.fish;
      };
  };
}
