# Provides the user with high permissions cross-platform.
{ config, ... }:
{
  flake.modules = {
    nixos.pc = {
      users.groups.wheel.members = [ config.username ];
    };

    darwin.pc.system.primaryUser = config.username;
  };
}
