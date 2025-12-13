# Declares a top-level option that is used in other modules.
# See `./shell.nix` for example usage.
{ lib, ... }:
{
  options.username = lib.mkOption {
    type = lib.types.singleLineStr;
    readOnly = true;
    default = "iam";
  };
}
