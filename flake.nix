{
  description = "Flake for website of Philipp Kühn";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs";
    hugo-coder.url = "github:luizdepra/hugo-coder";
    systems.url = "github:nix-systems/default";
  };

  outputs =
    {
      self,
      nixpkgs,
      hugo-coder,
      systems,
      ...
    }: let
        eachSystem = nixpkgs.lib.genAttrs (import systems);
      in {
        nixosModules.r4ndom-blog =
          { config, lib }:
          with lib;
          let
            cfg = config.services.r4ndom-blog;
          in
          {
            options.services.r4ndom-blog = {
              enable = mkEnableOption "Enable blog";
              domain = mkOption {
                type = types.str;
                description = "Domain to use for reverse proxy";
              };
            };

            config = mkIf cfg.enable {
              environment.systemPackages = [ self.packages.${system}.website ];

              services = {
                nginx.enable = true;
                nginx.virtualHosts.${cfg.domain} = {
                  forceSSL = true;
                  enableACME = true;
                  root = "${nixpkgs.r4ndom-blog}/share/hugo";
                };
              };
            };
          };

        formatter = eachSystem (system: nixpkgs.legacyPackages.${system}.nixfmt-rfc);

        packages.default = nixpkgs.stdenv.mkDerivation {
          pname = "website";
          version = "1.0.0";

          src = ./audacis;

          buildInputs = [ nixpkgs.hugo ];

          buildPhase = ''
            mkdir -p ./public
            hugo --themesDir themes --destination ./public
          '';

          installPhase = ''
            mkdir -p $out/share/hugo
            cp -r ./public/* $out/share/hugo/
          '';

          preBuild = ''
            mkdir -p themes
            ln -s ${hugo-coder.outPath} themes/hugo-coder
          '';
        };

        devShells.default = nixpkgs.mkShell {
          buildInputs = with nixpkgs; [
            git
            hugo
            nixpkgs-fmt
          ];
        };

      } // {
      nixosModules.default = _: { };
      };
}
