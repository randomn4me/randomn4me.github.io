{
  description = "A flake for developing and building my personal website";

  inputs.nixpkgs.url = "github:nixos/nixpkgs/nixpkgs-unstable";
  inputs.flake-utils.url = "github:numtide/flake-utils";
  inputs.tabi = { url = "github:welpo/tabi"; flake = false; };

  outputs =
    {
      self,
      nixpkgs,
      tabi,
      flake-utils,
    }:
    flake-utils.lib.eachDefaultSystem (
      system:
      let
        pkgs = nixpkgs.legacyPackages.${system};
        themeName = ((builtins.fromTOML (builtins.readFile "${tabi}/theme.toml")).name);
      in
      {
        packages.audacis-blog = pkgs.stdenv.mkDerivation {
          pname = "audacis-blog";
          version = "2024-11-09";
          src = ./.;
          nativeBuildInputs = [ pkgs.zola ];
          configurePhase = ''
            mkdir -p "themes/${themeName}"
            cp -r ${tabi}/* "themes/${themeName}"
          '';
          buildPhase = "zola build";
          installPhase = ''
            mkdir -p $out/var/www
            ln -s public $out/var/www/audacis-blog
          '';

        };
        defaultPackage = self.packages.${system}.audacis-blog;
        formatter = pkgs.nixfmt-rfc-style;
        devShell = pkgs.mkShell {
          packages = [ pkgs.zola ];
          shellHook = ''
            hello
            mkdir -p themes
            ln -ln "${tabi}" "themes/${themeName}"
          '';
        };
      }
    );
}
