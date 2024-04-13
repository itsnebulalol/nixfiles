{
  lib,
  stdenv,
  pkgs
}:
stdenv.mkDerivation {
  pname = "nvchad";
  version = "2.5";

  src = pkgs.fetchFromGitHub {
    owner = "itsnebulalol";
    repo = "nvchad-config";
    rev = "ad3b7de7b988840471aa232fd18ef1b94e4c0eb1";
    sha256 = "sha256-F47+5USQODEgNM570a3r7dF13JgQ1nEZ/6VziyZQryM=";
  };

  installPhase = ''
    mkdir $out
    cp -r * "$out/"
  '';
}
