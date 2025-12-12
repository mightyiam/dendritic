# This module defines "custom" top-level options that can be
# later used to influence different kinds of configurations.
#
# This is the recommended approach instead of using the specialArgs anti-pattern.
# See shell.nix for example usage.
{ lib, ... }:
{
  options.meta.username = lib.mkOption {
    description = "Principal User's username";
    type = lib.types.str;
  };
}
