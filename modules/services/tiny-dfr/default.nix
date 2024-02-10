{
  inputs,
  config,
  lib,
  pkgs,
  ...
}: {
  options.services.tiny-dfr.enable = lib.mkEnableOption "tiny-dfr";

  config.os = lib.mkIf config.services.tiny-dfr.enable {
    nixpkgs.overlays = [
      (final: prev: {
        tiny-dfr = prev.tiny-dfr.overrideAttrs (o: {
          patches = (o.patches or [ ]) ++ [
            ./etc-config.patch
          ];
        });
      })
    ];

    systemd.services.tiny-dfr = {
      description = "Tiny Apple silicon touch bar daemon";
      after = [
        "systemd-user-sessions.service"
        "getty@tty1.service"
        "plymouth-quit.service"
        "systemd-logind.service"
      ];
      startLimitIntervalSec = 30;
      startLimitBurst = 2;

      serviceConfig = {
        Restart = "always";
        ExecStart = "${inputs.tiny-dfr.packages.${pkgs.system}.default}/bin/tiny-dfr";
      };
    };

    environment.etc."tiny-dfr" = {
      mode = "symlink";
      source = "${inputs.tiny-dfr}/share/tiny-dfr";
    };

    environment.etc."tiny-dfr/config.toml".text = ''
      MediaLayerDefault = true
      ShowButtonOutlines = true
      EnablePixelShift = false
      FontTemplate = ""
      AdaptiveBrightness = true
      ActiveBrightness = 128

      PrimaryLayerKeys = [
        { Text = "F1",  Action = "F1"  },
        { Text = "F2",  Action = "F2"  },
        { Text = "F3",  Action = "F3"  },
        { Text = "F4",  Action = "F4"  },
        { Text = "F5",  Action = "F5"  },
        { Text = "F6",  Action = "F6"  },
        { Text = "F7",  Action = "F7"  },
        { Text = "F8",  Action = "F8"  },
        { Text = "F9",  Action = "F9"  },
        { Text = "F10", Action = "F10" },
        { Text = "F11", Action = "F11" },
        { Text = "F12", Action = "F12" }
      ]

      MediaLayerKeys = [
        { Icon = "brightness_low",  Action = "BrightnessDown" },
        { Icon = "brightness_high", Action = "BrightnessUp"   },
        { Icon = "mic_off",         Action = "MicMute"        },
        { Icon = "search",          Action = "Search"         },
        { Icon = "backlight_low",   Action = "IllumDown"      },
        { Icon = "backlight_high",  Action = "IllumUp"        },
        { Icon = "fast_rewind",     Action = "PreviousSong"   },
        { Icon = "play_pause",      Action = "PlayPause"      },
        { Icon = "fast_forward",    Action = "NextSong"       },
        { Icon = "volume_off",      Action = "Mute"           },
        { Icon = "volume_down",     Action = "VolumeDown"     },
        { Icon = "volume_up",       Action = "VolumeUp"       }
    ]
    '';

    services.udev.extraRules = ''
      SUBSYSTEM=="backlight", KERNEL=="228200000.display-pipe.0", DRIVERS=="panel-summit", ENV{SYSTEMD_READY}="0"

      SUBSYSTEM=="drm", KERNEL=="card*", DRIVERS=="adp", TAG-="master-of-seat", ENV{ID_SEAT}="seat-touchbar"

      SUBSYSTEM=="input", ATTR{name}=="MacBookPro17,1 Touch Bar", ENV{ID_SEAT}="seat-touchbar"
      SUBSYSTEM=="input", ATTR{name}=="Mac14,7 Touch Bar", ENV{ID_SEAT}="seat-touchbar"

      SUBSYSTEM=="input", ATTR{name}=="MacBookPro17,1 Touch Bar", TAG+="systemd", ENV{SYSTEMD_WANTS}="tiny-dfr.service"
      SUBSYSTEM=="input", ATTR{name}=="Mac14,7 Touch Bar", TAG+="systemd", ENV{SYSTEMD_WANTS}="tiny-dfr.service"
    '';

    boot.kernelPatches = [
      {
        name = "touch";
        patch = null;
        extraConfig = ''
          INPUT_TOUCHSCREEN y
        '';
      }
    ];
  };
}
