{
  lib,
  config,
  ...
}: let
  cfg = config.users;
  inherit (lib) mkOption types;
in {
  options.users = {
    main = mkOption {
      type = types.str;
    };
  };

  config = {
    os = {
      users.users.root.hashedPasswordFile = "/persist/passwords/root";
      users.users.${cfg.main} = {
        uid = 1000;
        initialHashedPassword = "$6$C/464KR0SF1j/V3F$TLSu9SmTjjgzCbQu1dIAEu3zIGQeOUBnjgAYBrWEaRy.t9fCWJgQ.ys0vEgPxASi63i5sQJ6ltAXEY/svDVQY.";
        hashedPasswordFile = "/persist/passwords/${cfg.main}";
        isNormalUser = true;
        extraGroups = [
          "wheel"
          "video"
          "networkmanager"
        ];
      };
      users.mutableUsers = false;
    };
    hmUsername = cfg.main;
  };
}