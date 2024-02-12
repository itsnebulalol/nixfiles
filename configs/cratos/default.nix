{pkgs, ...}: {
  users.main = "nebula";

  rebuildCommand = "nh os switch";

  agenix.enable = true;
  bluetooth.enable = true;
  nur.enable = true;

  programs = {
    _1password.enable = true;
    chromium.enable = true;
    firefox.enable = true;
    gnome.enable = true;
    discord.enable = true;
    minecraft.enable = true;
    vscode.enable = true;
  };

  services = {
    tailscale.enable = true;
  };

  hm.home.packages = with pkgs; [
    neofetch
  ];

  os = {
    programs.nm-applet.enable = true;
  };
}
