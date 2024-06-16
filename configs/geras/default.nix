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
      globalConfig = ''
        fruit:model = Laptop
      '';
      shares = {
        "geras" = {
          path = "/data";
          browseable = "yes";
          "read only" = "no";
          "guest ok" = "no";
          "create mask" = "0644";
          "directory mask" = "0755";
          "force user" = "nebula";
          "force group" = "users";
          "vfs objects" = "catia fruit streams_xattr";
        };
      };
    };
    tailscale.enable = true;
  };
}
