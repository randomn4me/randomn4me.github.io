{
  description = "Flake for website of Philipp Kühn";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs";
    hugo-coder = {
      url = "github:luizdepra/hugo-coder";
      flake = false;
    };
    flake-utils.url = "github:numtide/flake-utils";
    systems.url = "github:nix-systems/default";
  };

  outputs =
    {
      self,
      nixpkgs,
      hugo-coder,
      flake-utils,
      ...
    }:
    flake-utils.lib.eachDefaultSystem (
      system:
      let
        pkgs = nixpkgs.legacyPackages.${system};
      in
      {
        formatter = pkgs.nixfmt-rfc-style;

        packages.website = pkgs.stdenv.mkDerivation {
          name = "website";
          src = self;
          buildInputs = [ pkgs.hugo ];
          buildPhase = ''
            mkdir -p themes
            ln -s ${hugo-coder} themes/hugo-coder
            ${pkgs.hugo}/bin/hugo
          '';
          installPhase = "cp -r public $out";
        };

        defaultPackage = self.packages.${system}.website;
        devShells.default = pkgs.mkShell {
          packages = with pkgs; [
            hugo
            git
          ];
        };
      }
    );
}
