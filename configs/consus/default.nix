{ pkgs, ... }: {
  users.main = "nebula";

  rebuildCommand = "nh os switch";

  agenix.enable = true;
  nur.enable = true;

  services = {
    adguard.enable = true;
    instafix.enable = true;
    homepage.enable = true;
    samba = {
      enable = true;

      serverName = "consus";
      globalConfig = ''
        fruit:model = Xserve
      '';
      shares = {
        "files" = {
          comment = "Files";
          path = "/data/files";
          browseable = "yes";
          "read only" = "no";
          "guest ok" = "no";
          "create mask" = "0644";
          "directory mask" = "0755";
          "force user" = "nebula";
          "force group" = "users";
          "vfs objects" = "catia fruit streams_xattr";
        };
        "timemachine" = {
          comment = "Time Machine";
          path = "/data/timemachine";
          browseable = "yes";
          "read only" = "no";
          "guest ok" = "no";
          "create mask" = "0644";
          "directory mask" = "0755";
          "force user" = "nebula";
          "force group" = "users";
          "vfs objects" = "catia fruit streams_xattr";
          "fruit:time machine" = "yes";
        };
      };
    };
    scrypted.enable = true;
    static.enable = true;
    tailscale.enable = true;
    watchtower.enable = true;
    wg.enable = true;
  };
}
