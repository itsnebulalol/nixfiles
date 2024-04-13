{
  config,
  lib,
  ...
}: {
  options.services.wg.enable = lib.mkEnableOption "Wireguard Server";

  config = lib.mkIf config.services.wg.enable {
    services.docker.enable = true;

    os = {
      systemd.tmpfiles.rules = [
        "d /etc/wg 0770 nebula users -"
      ];

      virtualisation.arion.projects.server.settings.services = {
        wg-easy.service = {
          image = "ghcr.io/wg-easy/wg-easy";
          container_name = "wg-easy";
          ports = [
            "51820:51820/udp"
            "51821:51821"
          ];
          capabilities = {
            SYS_MODULE = true;
            NET_ADMIN = true;
          };
          sysctls = {
            "net.ipv4.ip_forward" = 1;
            "net.ipv4.conf.all.src_valid_mark" = 1;
          };
          volumes = [
            "/etc/wg:/etc/wireguard"
          ];
          environment = {
            WG_HOST = "ddns.itsnebula.net";
            WG_DEFAULT_DNS = "1.1.1.1";
          };
          restart = "unless-stopped";
        };
      };

      networking.firewall.allowedUDPPorts = [51820];

      services.caddy = {
        enable = true;
        virtualHosts = {
          "wg.itsnebula.net".extraConfig = ''
            reverse_proxy 127.0.0.1:51821
            import cloudflare
          '';
        };
      };
    };
  };
}
