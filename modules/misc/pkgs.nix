{ pkgs, ... }: {
  os.nixpkgs.overlays = [(import ../../pkgs/overlays)];
  os.environment.systemPackages = [pkgs.curl pkgs.wget pkgs.aria2 pkgs.dig pkgs.python3];
}
