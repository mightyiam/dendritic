# enable the flake.modules option
{ inputs, ... }:
{
  imports = [ inputs.flake-parts.flakeModules.modules ];
}
