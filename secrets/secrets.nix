let
  consus_user = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIE/c8uEXFkY25C51F/QS+uPw1dBVCSrAaCYgy3lzRQd3";
  consus_host = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAILgaHSl0Mv49oFjYV3TALqIQTpcgDy2vY2/2T+X0b6DD";
  consus = [consus_user consus_host];

  geras_user = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIE9igQb33UXH8wAGTC+K7w6uBdciIKI03Xxc2JcoAJNz";
  geras_host = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAILVxSXFgepyJf3LilMcmjhIDrUw9dnvs76/timPjNdGB";
  geras = [geras_user geras_host];

  maniae_user = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIMzIyeRCkLieiuEoCGvrBQrXgp6U/WnorBnvPW/YHL9q";
  maniae_host = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIK9qC/9rOQWjFBr9EFtc05TCIcOI9m38howi6vTPizuy";
  maniae = [maniae_user maniae_host];

  oizys_user = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIPqkRtQeZtjoaEG8oxqALkkEedsPlvMIMNrszYTf1aiU";
  oizys_host = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAII8YzwzjrPrzKHBaeOeSCRGqUJEDhaP684czaY5Gj/Nu";
  oizys = [oizys_user oizys_host];

  poseidon_user = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIEx8KkpRE0VpGp0i3bE/qB1+5vWniibi1Za7k0KOV/f3";
  poseidon_host = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIMTMvXrnkyPvxX+cNDm8HG+0X42pkCaqXoITpBEZNFG9";
  poseidon = [poseidon_user poseidon_host];

in {
  "adguardhome_sync.age".publicKeys = consus;
  "blackhole.age".publicKeys = consus ++ poseidon;
  "blackhole4k.age".publicKeys = consus ++ poseidon;
  "blackhole4kdv.age".publicKeys = consus ++ poseidon;
  "blackholeextra.age".publicKeys = consus ++ poseidon;
  "caddy-cloudflare.age".publicKeys = consus ++ maniae ++ poseidon;
  "cloudflared-media.age".publicKeys = consus ++ poseidon;
  "homepage_env.age".publicKeys = consus ++ poseidon;
  "rd_conf.age".publicKeys = consus ++ poseidon;
  "tailscale.age".publicKeys = consus ++ geras ++ maniae ++ oizys ++ poseidon;
  "wg-home.age".publicKeys = consus ++ poseidon;
}
