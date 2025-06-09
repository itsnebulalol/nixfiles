{ pkgs, ... }: {
  users.main = "nebula";

  rebuildCommand = "nh os switch";

  agenix.enable = true;

  services = {
    caddy.enable = true;
    tailscale.enable = true;
  };
}
