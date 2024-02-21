{
  stdenvNoCC,
  fetchFromGitHub,
  libsForQt5,
}:
stdenvNoCC.mkDerivation rec {
  pname = "plasma-rose-pine-theme";
  version = "0.1.0";
  dontBuild = true;

  src = fetchFromGitHub {
    owner = "itsnebulalol";
    repo = "plasma-rose-pine";
    rev = "v${version}";
    sha256 = "sha256-MA20QTygBL6GG9qN239jNdKOylm/6YUeSPCA6q/PIN0=";
  };

  installPhase = ''
    mkdir -p $out/share/color-schemes
    cp -aR $src/"Rose Pine Moon"/colorschemes/* $out/share/color-schemes/
  '';
}
