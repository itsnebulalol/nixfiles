{ pkgs, ... }: {
  os = {
    nixpkgs.overlays = [
      (import ../../pkgs/overlays)
      (_: prev: {
        python312 = prev.python312.override { packageOverrides = _: pysuper: { nose = pysuper.pynose; }; };
      })
    ];
    environment.systemPackages = with pkgs; [
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
  };
}
