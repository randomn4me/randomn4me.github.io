{ self }:
{ config, lib, pkgs, ... }:

let
  cfg = config.services.audacis-blog;
in
{
  options.services.audacis-blog = {
    enable = lib.mkOption {
      type = lib.types.bool;
      default = false;
      description = "Enable the audacis blog service";
    };

    domain = lib.mkOption {
      type = lib.types.str;
      description = "Domain name for the blog";
    };
  };

  config = lib.mkIf cfg.enable {
    services.nginx = {
      enable = true;
      recommendedGzipSettings = true;
      recommendedOptimisation = true;
      recommendedProxySettings = true;
      recommendedTlsSettings = true;

      virtualHosts.${cfg.domain} = {
        enableACME = true;
        forceSSL = true;
        serverAliases = [ "www.${cfg.domain}" ];
        root = "${self.packages.${pkgs.system}.audacis-blog}";
        
        locations."/" = {
          tryFiles = "$uri $uri/ /index.html";
        };
      };
    };

    security.acme = {
      acceptTerms = true;
      defaults.email = "admin@${cfg.domain}";
    };

    networking.firewall.allowedTCPPorts = [ 80 443 ];
  };
}