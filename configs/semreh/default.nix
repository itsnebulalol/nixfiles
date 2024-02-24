{ pkgs, ... }: {
  users.main = "nebula";

  rebuildCommand = "nh os switch";

  agenix.enable = true;
  nur.enable = true;

  services = {
    caddy.enable = true;
    conduit.enable = true;
    tailscale.enable = true;
  };

  hm.home.packages = with pkgs; [
    libraspberrypi
    raspberrypi-eeprom

    neofetch
  ];
}
