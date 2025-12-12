{ self, lib, ... }:
{
  # use flake-parts to expose a nixosConfiguration as flake output.
  flake.nixosConfigurations.my-laptop = lib.nixosSystem {
    # recommendation is for nixos to include only a single module
    # and make that module import others as needed.
    modules = [ self.modules.nixos.my-laptop ];
  };

  # instantiate other kinds of configurations like darwinConfigurations, nixDroid, etc.
}
