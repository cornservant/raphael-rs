{
  description = "Crafting solver for Final Fantasy XIV Online";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs?ref=nixos-unstable";
    rust-overlay.url = "github:oxalica/rust-overlay";
  };

  outputs =
    { nixpkgs, rust-overlay, ... }:
    let
      system = "x86_64-linux";
      pkgs = nixpkgs.legacyPackages.${system};
    in
    {
      devShells.${system}.default = pkgs.mkShell {
        LD_LIBRARY_PATH = pkgs.lib.makeLibraryPath [
          pkgs.libGL
          pkgs.libxkbcommon
          pkgs.wayland
        ];
      };
      packages.${system} = rec {
        raphael-xiv = pkgs.callPackage ./package.nix {
          rust = rust-overlay.packages.${system}.rust;
        };
        default = raphael-xiv;
      };
    };
}
