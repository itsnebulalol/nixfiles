{ pkgs, ... }: {
  users.main = "nebula";

  rebuildCommand = "nh os switch";

  agenix.enable = true;
  nur.enable = true;

  services = {
    adguard.enable = true;
    instafix.enable = true;
    samba = {
      enable = true;

      serverName = "consus";
      shareName = "consus";
      path = "/data";
    };
    scrypted.enable = true;
    static.enable = true;
    tailscale.enable = true;
    watchtower.enable = true;
    wg.enable = true;
  };
}
