{
  description = "A flake for developing and building my personal website";

  inputs.nixpkgs.url = "github:nixos/nixpkgs/nixpkgs-unstable";
  inputs.flake-utils.url = "github:numtide/flake-utils";

  outputs =
    {
      self,
      nixpkgs,
      flake-utils,
    }:
    flake-utils.lib.eachDefaultSystem (
      system:
      let
        pkgs = nixpkgs.legacyPackages.${system};
      in
      {
        packages.audacis-blog = import ./nix/package.nix {
          inherit pkgs;
          src = ./.;
        };
        packages.default = self.packages.${system}.audacis-blog;
        
        apps.default = {
          type = "app";
          program = "${import ./nix/serve.nix { inherit pkgs; src = ./.; }}/bin/serve-blog";
        };
        
        formatter = pkgs.nixfmt-rfc-style;
        
        devShells.default = import ./nix/shell.nix {
          inherit pkgs;
        };
      }
    ) // {
      nixosModules.default = import ./nix/module.nix {
        inherit self;
      };
    };
}