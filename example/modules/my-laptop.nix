{ self, ... }:
{
  flake.modules.nixos.my-laptop = {
    imports = with self.modules.nixos; [
      admin
      shell
      no-boot # for example purposes
      # any other usability concerns for my-laptop
    ];

    nixpkgs.hostPlatform = "x86_64-linux";
  };
}
