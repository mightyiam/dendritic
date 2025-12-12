{ config, lib, ... }:
{
  flake.modules = {
    nixos.shell =
      { pkgs, ... }:
      {
        programs.fish.enable = true;
        users.users.${config.meta.username}.shell = pkgs.fish;
      };

    darwin.shell =
      { pkgs, ... }:
      {
        # This darwin module is included only for example, this is not a real configuration.
        # nix-darwin has no declarative way to define a user shell, for simplicity we just enable fish.
        # This module could configure Terminal.app or whatever terminal you use to run fish.
        # see https://discourse.nixos.org/t/how-to-set-desired-shell-with-nix-darwin/49826/3
        programs.fish.enable = true;
      };

    nixOnDroid.shell =
      { pkgs, ... }:
      {
        user.shell = lib.getExe pkgs.zsh;
      };
  };
}
