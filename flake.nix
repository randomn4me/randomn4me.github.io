{
  description = "A flake for developing and building my personal website";

  inputs.nixpkgs.url = "github:nixos/nixpkgs/nixpkgs-unstable";
  inputs.flake-utils.url = "github:numtide/flake-utils";
  inputs.archie = {
    url = "github:XXXMrG/archie-zola";
    flake = false;
  };

  outputs =
    {
      self,
      nixpkgs,
      flake-utils,
      archie,
    }:
    flake-utils.lib.eachDefaultSystem (
      system:
      let
        pkgs = nixpkgs.legacyPackages.${system};
        themeName = ((builtins.fromTOML (builtins.readFile "${archie}/theme.toml")).name);
      in
      {
        packages.website = pkgs.stdenv.mkDerivation {
          pname = "static-website";
          version = "2024-11-09";
          src = ./.;
          nativeBuildInputs = [ pkgs.zola ];
          configurePhase = ''
            mkdir -p "themes/${themeName}"
            cp -r ${archie}/* "themes/${themeName}"
          '';
          buildPhase = "zola build";
          installPhase = "cp -r public $out";
        };
        defaultPackage = self.packages.${system}.website;
        formatter = pkgs.nixfmt-rfc-style;
        devShell = pkgs.mkShell {
          packages = [ pkgs.zola ];
          shellHook = ''
            mkdir -p themes
            ln -snf "${archie}" "themes/${themeName}"

            source <(${pkgs.zola}/bin/zola completion $(basename $SHELL))
          '';
        };
      }
    );
}
