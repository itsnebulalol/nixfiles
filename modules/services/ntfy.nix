{
  config,
  osConfig,
  lib,
  pkgs,
  ...
}: {
  options.services.ntfy.enable = lib.mkEnableOption "ntfy";

  config.os = lib.mkIf config.services.ntfy.enable {
    services.ntfy-sh = {
      enable = true;
      settings = {
        base-url = "https://notify.svrd.me";
        upstream-base-url = "https://ntfy.sh";
        listen-http = ":9841";
        cache-file = "/var/lib/ntfy-sh/cache.db";
        auth-file = "/var/lib/ntfy-sh/user.db";
        auth-default-access = "deny-all";
        behind-proxy = true;
      };
    };
  };
}
