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
        packages.website = pkgs.stdenv.mkDerivation {
          pname = "static-website";
          version = "2024-11-09";
          src = ./.;
          nativeBuildInputs = [ pkgs.zola ];
          buildPhase = "zola build";
          installPhase = "cp -r public $out";
        };
        defaultPackage = self.packages.${system}.website;
        formatter = pkgs.nixfmt-rfc-style;
        devShell = pkgs.mkShell {
          packages = [ pkgs.zola ];
          shellHook = ''
            source <(${pkgs.zola}/bin/zola completion $(basename $SHELL))
          '';
        };
      }
    );
}
