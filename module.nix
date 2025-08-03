{ lib, config, ... }:

let
  cfg = config.services.personalSite;
in
{
  options.services.personalSite = {
    enable = lib.mkEnableOption "personal site";

    domain = lib.mkOption {
      type = lib.types.str;
      description = "the domain the site will be hosted on";
    };

    enableACME = lib.mkOption {
      type = lib.types.bool;
      default = true;
      description = "if SSL certificates should automatically be configured using ACME";
    };

    forceSSL = lib.mkOption {
      type = lib.types.bool;
      default = true;
    };
  };

  config = lib.mkIf cfg.enable {
    # while I could be more transparent about the fact that
    # this just wraps nginx, I don't think it's necessary
    services.nginx = {
      enable = true;

      virtualHosts.${cfg.domain} = {
        enableACME = cfg.enableACME;
        forceSSL = cfg.forceSSL;
        root = ./www;
      };
    };
  };
}
