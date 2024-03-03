{ pkgs, ... }: {
  users.main = "nebula";

  rebuildCommand = "nh os switch";

  agenix.enable = true;
  nur.enable = true;

  services = {
    monero.enable = true;
    samba = {
      enable = true;

      serverName = "geras";
      shareName = "geras";
      path = "/data";
    };
    tailscale.enable = true;
  };
}
