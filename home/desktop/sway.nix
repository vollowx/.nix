{ config, pkgs, lib, colors, ... }:

{
  home = {
    packages = with pkgs; [ wl-clipboard wlogout wofi brightnessctl wdisplays ];
    sessionVariables = {
      # Wayland
      NIXOS_OZONE_WL = "1";
      QT_QPA_PLATFORM = "wayland";
      SDL_VIDEODRIVER = "wayland";
      CLUTTER_BACKEND = "wayland";
      # Firefox
      MOZ_ENABLE_WAYLAND = "1";
      # QT
      QT_WAYLAND_DISABLE_WINDOWDECORATION = "1";
      QT_QPA_PLATFORMTHEME = "qt6ct";
      # Java
      _JAVA_AWT_WM_NONREPARENTING = "1";
    };
  };

  wayland.windowManager.sway = {
    enable = true;
    # package = pkgs.swayfx;
    systemd.enable = true;
    extraSessionCommands = ''
      export XDG_CURRENT_DESKTOP=sway;
    '';
    wrapperFeatures.gtk = true;
    xwayland = true;
    config = {
      modifier = "Mod4";
      input = {
        "type:keyboard" = {
          xkb_layout = "us";
          repeat_delay = "200";
          repeat_rate = "30";
        };
        "type:touchpad" = {
          dwt = "disabled";
          tap = "enabled";
          accel_profile = "adaptive";
          natural_scroll = "enabled";
          scroll_factor = "0.45";
          pointer_accel = "0.27";
        };
      };
      output = {
        eDP-1 = { bg = "~/.local/share/backgrounds/Nix.png fill"; };
        HDMI-A-1 = { bg = "~/.local/share/backgrounds/Nix.png fill"; };
      };
      seat = { "*" = { hide_cursor = "when-typing enable"; }; };

      colors = {
        background = "#${colors.base}";
        focused = {
          background = "#${colors.base}";
          border = "#${colors.surface2}";
          childBorder = "#${colors.surface2}";
          indicator = "#${colors.overlay0}";
          text = "#${colors.text}";
        };
        focusedInactive = {
          background = "#${colors.base}";
          border = "#${colors.surface1}";
          childBorder = "#${colors.surface1}";
          indicator = "#${colors.overlay0}";
          text = "#${colors.text}";
        };
        placeholder = {
          background = "#${colors.base}";
          border = "#${colors.overlay0}";
          childBorder = "#${colors.overlay0}";
          indicator = "#${colors.overlay0}";
          text = "#${colors.text}";
        };
        unfocused = {
          background = "#${colors.base}";
          border = "#${colors.surface0}";
          childBorder = "#${colors.surface0}";
          indicator = "#${colors.overlay0}";
          text = "#${colors.text}";
        };
        urgent = {
          background = "#${colors.base}";
          border = "#${colors.peach}";
          childBorder = "#${colors.peach}";
          indicator = "#${colors.overlay0}";
          text = "#${colors.text}";
        };
      };
      window = {
        titlebar = false;
        border = 0;
      };
      floating = {
        titlebar = false;
        border = 0;
      };
      gaps.inner = 0;
      bars = [ ];

      keybindings = let
        modifier = config.wayland.windowManager.sway.config.modifier;
        concatAttrs = lib.fold (x: y: x // y) { };
        workspaceKeys = concatAttrs (map (i: {
          "${modifier}+${toString i}" =
            "exec 'swaymsg workspace ${toString i}'";
          "${modifier}+Shift+${toString i}" =
            "exec 'swaymsg move container to workspace ${toString i}'";
        }) (lib.range 0 9));
      in workspaceKeys // {
        "${modifier}+escape" = "exec wlogout";
        "${modifier}+return" = "exec kitty -1";
        "${modifier}+d" = "exec wofi --show drun";
        "${modifier}+v" = "exec clipman pick -t wofi";
        "${modifier}+s" = "exec status";
        "${modifier}+x" = "exec swaylock -f";
        "${modifier}+o" = "exec ${pkgs.hyprpicker}/bin/hyprpicker -a -n";

        "${modifier}+q" = "kill";
        "${modifier}+r" = "mode 'resize'";
        "${modifier}+h" = "focus left";
        "${modifier}+j" = "focus down";
        "${modifier}+k" = "focus up";
        "${modifier}+l" = "focus right";
        "${modifier}+Shift+h" = "move left";
        "${modifier}+Shift+j" = "move down";
        "${modifier}+Shift+k" = "move up";
        "${modifier}+Shift+l" = "move right";
        "${modifier}+w" = "layout tabbed";
        "${modifier}+e" = "layout toggle split";
        "${modifier}+f" = "fullscreen";
        "${modifier}+space" = "focus mode_toggle";
        "${modifier}+Shift+space" = "floating toggle";
        "${modifier}+minus" = "scratchpad show";
        "${modifier}+Shift+minus" = "move scratchpad";
        "${modifier}+a" = "focus parent";
        "${modifier}+Shift+r" = "reload";
        "${modifier}+Shift+e" =
          "exec swaynag -t warning -m 'You pressed the exit shortcut. Do you really want to exit sway? This will end your Wayland session.' -B 'Yes, exit sway' 'swaymsg exit'";

        "XF86AudioMute" = "exec volume -t";
        "XF86AudioMicMute" = "exec microphone -t";
        "XF86AudioLowerVolume" = "exec volume -d 5";
        "XF86AudioRaiseVolume" = "exec volume -i 5";
        "XF86MonBrightnessDown" = "exec brightness set 5%-";
        "XF86MonBrightnessUp" = "exec brightness set +5%";
      };
    };
  };

  services.swayidle = {
    enable = true;
    events = [
      {
        event = "before-sleep";
        command = "swaylock -f";
      }
      {
        event = "after-resume";
        command = "swaymsg 'output * dpms on'";
      }
    ];
    timeouts = [
      {
        timeout = 300;
        command = "swaylock -f";
      }
      {
        timeout = 600;
        command = "swaymsg 'output * dpms off'";
      }
    ];
  };

  programs.swaylock = {
    enable = true;
    settings = {
      ignore-empty-password = true;
      color = "#000000";
    };
  };

  services.clipman = { enable = true; };
}
