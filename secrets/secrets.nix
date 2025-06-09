let
  maniae_user = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIMzIyeRCkLieiuEoCGvrBQrXgp6U/WnorBnvPW/YHL9q";
  maniae_host = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIK9qC/9rOQWjFBr9EFtc05TCIcOI9m38howi6vTPizuy";
  maniae = [maniae_user maniae_host];

in {
  "caddy-cloudflare.age".publicKeys = maniae;
  "tailscale.age".publicKeys = maniae;
}
