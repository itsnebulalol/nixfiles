{ pkgs, ... }: {
  os.nixpkgs.overlays = [(import ../../pkgs/overlays)];
  os.environment.systemPackages = with pkgs; [
    curl
    wget
    aria2
    dig
    python3
    pipx
    ripgrep
    neofetch
    sshfs
    clang
  ];
}
