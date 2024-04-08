{
  lib,
  stdenv,
  pkgs
}:
stdenv.mkDerivation {
  pname = "nvchad";
  version = "2.5";

  src = pkgs.fetchFromGitHub {
    owner = "NvChad";
    repo = "starter";
    rev = "d801a059efd216b3d11a5a1eaf039e6e583d3e49";
    sha256 = "sha256-hfpvQl7HPBXfX/UqbapB54DKJK4jsivYdTZV3bf0hMw=";
  };

  installPhase = ''
    mkdir $out
    cp -r * "$out/"
  '';
}
