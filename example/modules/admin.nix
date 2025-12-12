# configures the principal administrator user.
# 
# Note that each nix class (`nixos`, `darwin`) uses different options to
# configure who the administrator is.
#
# This "admin" aspect abstract the specific configuration details/differences.
{ config, ... }:
{
  flake.modules = {

    nixos.admin = {
      users.users.${config.meta.username} = {
        isNormalUser = true;
        extraGroups = [ "wheel" ];
      };
    };

    darwin.admin.system.primaryUser = config.meta.username;
  };
}
