{
  config,
  lib,
  ...
}: {
  options.services.ntfy.enable = lib.mkEnableOption "ntfy";

  config = lib.mkIf config.services.ntfy.enable {
    services.docker.enable = true;

    os = {
      systemd.tmpfiles.rules = [
        "d /etc/ntfy 0770 nebula users -"
      ];

      virtualisation.arion.projects.server.settings.services = {
        ntfy.service = {
          image = "binwiederhier/ntfy";
          container_name = "ntfy";
          healthcheck = {
            test = [ "CMD-SHELL" "wget" "-q" "--tries=1" "http://localhost:9841/v1/health" "-O" "-" "|" "grep" "-Eo" "'\"healthy\"\\s*:\\s*true'" "||" "exit" "1" ];
            interval = "60s";
            timeout = "10s";
            retries = 3;
            start_period = "40s";
          };
          user = "1000:100";
          ports = [ "9841:9841" ];
          volumes = [
            "/etc/ntfy:/var/lib/ntfy"
          ];
          environment = {
            NTFY_BASE_URL = "https://notify.svrd.me";
            NTFY_UPSTREAM_BASE_URL = "https://ntfy.sh";
            NTFY_LISTEN_HTTP = ":9841";
            NTFY_ATTACHMENT_CACHE_DIR = "/var/lib/ntfy/attachments";
            NTFY_CACHE_FILE = "/var/lib/ntfy/cache.db";
            NTFY_AUTH_FILE = "/var/lib/ntfy/user.db";
            NTFY_AUTH_DEFAULT_ACCESS = "deny-all";
            NTFY_BEHIND_PROXY = "true";
          };
          command = [ "serve" ];
          restart = "unless-stopped";
        };
      };
    };
  };
}

