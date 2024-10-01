{
  pkgs,
  inputs,
  lib,
  config,
  # hyprland,
  ...
}:
let
  # hyprlandFlake = inputs.hyprland.packages.${pkgs.system}.hyprland;
  oxocarbon_pink = "ff7eb6";
  oxocarbon_border = "393939";
  oxocarbon_background = "161616";
  background = "rgba(11111B00)";
  tokyonight_border = "rgba(7aa2f7ee) rgba(87aaf8ee) 45deg";
  tokyonight_background = "rgba(32344aaa)";
  catppuccin_border = "rgba(b4befeee)";
  opacity = "0.95";
  transparent_gray = "rgba(666666AA)";
  gsettings = "${pkgs.glib}/bin/gsettings";
  gnomeSchema = "org.gnome.desktop.interface";
in
{
  options = {
    hyprland.enable = lib.mkEnableOption "Enable hyprland module";
  };
  config = lib.mkIf config.hyprland.enable {
    home.packages = with pkgs; [
      grim # Screenshot tool for hyprland
      slurp # Works with grim to screenshot on wayland
      swappy # Wayland native snapshot editing tool, inspired by Snappy on macOS
      # wl-clipboard # Enables copy/paste on wayland
      # bemenu
      nwg-look # Change GTK theme

      (writeShellScriptBin "screenshot" ''
        grim -g "$(slurp)" - | wl-copy
      '')
      (writeShellScriptBin "screenshot-edit" ''
        wl-paste | swappy -f -
      '')
      (writeShellScriptBin "autostart" ''
        # Variables
        config=$HOME/.config/hypr

        fcitx5 -d

        # ags (bar and some extra stuff)
        # ags

        # Wallpaper
        swww kill
        swww-daemon

        # Cursor
        gsettings set org.gnome.desktop.interface cursor-theme macOS-BigSur
        hyprctl setcursor macOS-BigSur 32 # "Catppuccin-Mocha-Mauve-Cursors"

        # Others
        dbus-update-activation-environment --systemd WAYLAND_DISPLAY XDG_CURRENT_DESKTOP &
      '')

      (writeShellScriptBin "importGsettings" ''
        config="/home/hjkl/.config/gtk-3.0/settings.ini"
        if [ ! -f "$config" ]; then exit 1; fi
        gtk_theme="$(grep 'gtk-theme-name' "$config" | sed 's/.*\s*=\s*//')"
        icon_theme="$(grep 'gtk-icon-theme-name' "$config" | sed 's/.*\s*=\s*//')"
        cursor_theme="$(grep 'gtk-cursor-theme-name' "$config" | sed 's/.*\s*=\s*//')"
        font_name="$(grep 'gtk-font-name' "$config" | sed 's/.*\s*=\s*//')"
        ${gsettings} set ${gnomeSchema} gtk-theme "$gtk_theme"
        ${gsettings} set ${gnomeSchema} icon-theme "$icon_theme"
        ${gsettings} set ${gnomeSchema} cursor-theme "$cursor_theme"
        ${gsettings} set ${gnomeSchema} font-name "$font_name"
      '')
    ];
    wayland.windowManager.hyprland = {
      enable = true;
      plugins = [
      # pkgs.hyprlandPlugins.hyprexpo
      # inputs.hyprland-plugins.packages.${pkgs.system}.hyprexpo
      ];
      # package = hyprlandFlake; # hyprlandFlake or pkgs.hyprland
      xwayland = {
        enable = true;
      };
      settings = {

        # plugin = {
        #   # hyprexpo = {
        #   #   columns = 3;
        #     # gap_size = 5;
        #   };
        # };
       
        "$terminal" = "alacritty";
        "$fileManager"= "nautilus";
        "$menu"= "bemenu-run";
        "$web" = "firefox";
        monitor = "Unknown-1 ,disable";

        exec-once = [
          "autostart"
          # "easyeffects --gapplication-service" # Starts easyeffects in the background
          "importGsettings"
        ];


        env = [
          "HYPRCURSOR_SIZE,24"
            "XDG_SESSION_TYPE,wayland"
            "GBM_BACKEND,nvidia-drm"
            "LIBVA_DRIVER_NAME,nvidia"
            "__GLX_VENDER_LIBRARY_NAME,nvidia"
            "GTK_IM_MODULE,fcitx"
            "QT_IM_MODULE,fcitx"
            "SDL_IM_MODULE,fcitx"
            "GLFW_IM_MODULE,fcitx"
            "XMODIFIERS,@im=fcitx"
        ];

        cursor={
          no_hardware_cursors =true;
        };
        general= { 
          gaps_in = 5;
          gaps_out = 20;

          border_size = 2;

          # col.active_border = rgba(33ccffee) rgba(00ff99ee) 45deg;
          # col.inactive_border = rgba(595959aa);

          resize_on_border = false ;

          allow_tearing = false;

          layout = "dwindle";
        };

        decoration ={
          rounding = 10;

# Change transparency of focused and unfocused windows;
          active_opacity = 1.0;
          inactive_opacity = 1.0;

          drop_shadow = true;
          shadow_range = 4;
          shadow_render_power = 3;
          # col.shadow = rgba(1a1a1aee);

# https://wiki.hyprland.org/Configuring/Variables/#blur;
          blur= {
            enabled = true;
            size = 3;
            passes = 1;

            vibrancy = 0.1696;
          };
        };

# https://wiki.hyprland.org/Configuring/Variables/#animations
        animations ={
          enabled = true;
# Default animations, see https://wiki.hyprland.org/Configuring/Animations/ for more;
          bezier = "myBezier, 0.05, 0.9, 0.1, 1.05";

          animation =[
            "windows, 1, 7, myBezier"
              "windowsOut, 1, 7, default, popin 80%"
              "border, 1, 10, default"
              "borderangle, 1, 8, default"
              "fade, 1, 7, default"
              "workspaces, 1, 5, default"
          ];
        };

# See https://wiki.hyprland.org/Configuring/Dwindle-Layout/ for more
        dwindle ={
          pseudotile = true ;# Master switch for pseudotiling. Enabling is bound to mainMod + P in the keybinds section below
            preserve_split = true ;# You probably want this
        };

# See https://wiki.hyprland.org/Configuring/Master-Layout/ for more
        master= {
          new_status = "master";
        };

# https://wiki.hyprland.org/Configuring/Variables/#misc
        misc ={ 
          force_default_wallpaper = -1; # Set to 0 or 1 to disable the anime mascot wallpapers
            disable_hyprland_logo = false; # If true disables the random hyprland logo / anime girl background. :(
                };


#############
### INPUT ###
#############

# https://wiki.hyprland.org/Configuring/Variables/#input
                input= {
                kb_layout = "us";
                kb_variant ="";
                kb_model ="";
                kb_options ="";
                kb_rules ="";

                follow_mouse = 1;

                sensitivity = 0; # -1.0 - 1.0, 0 means no modification.;

                touchpad= {
                  natural_scroll = false;
                };
                };

# https://wiki.hyprland.org/Configuring/Variables/#gestures
                gestures = {
                  workspace_swipe = false ;
                }; # Example per-device config
# See https://wiki.hyprland.org/Configuring/Keywords/#per-device-input-configs for more
                device = {
                  name = "epic-mouse-v1";
                  sensitivity = "-0.5";
                };


                bind = [
                  "SUPER,Q,killactive,"
                    "SUPER,M,exit,"
                    "SUPER,RETURN,exec,$terminal"
                    # "SUPER,grave,hyprexpo:expo,toggle"
                    "SUPER,T,exec, $web"
                    "SUPER,R,exec, $menu"
                    "SUPER,S,togglefloating,"
                    "SUPER,g,togglegroup"
                    "SUPER,F,fullscreen,0"
                    "SUPER,Tab,cyclenext"
# "SUPER,tab,changegroupactive"
# "SUPER,P,pseudo,"

# Vim binds
                    "SUPER,h,movefocus,l"
                    "SUPER,l,movefocus,r"
                    "SUPER,k,movefocus,u"
                    "SUPER,j,movefocus,d"

                    "SUPER,left,movefocus,l"
                    "SUPER,down,movefocus,r"
                    "SUPER,up,movefocus,u"
                    "SUPER,right,movefocus,d"

                    "SUPER,1,workspace,1"
                    "SUPER,2,workspace,2"
                    "SUPER,3,workspace,3"
                    "SUPER,4,workspace,4"
                    "SUPER,5,workspace,5"
                    "SUPER,6,workspace,6"
                    "SUPER,7,workspace,7"
                    "SUPER,8,workspace,8"

################################## Move ###########################################
                    "SUPER SHIFT, H, movewindow, l"
                    "SUPER SHIFT, L, movewindow, r"
                    "SUPER SHIFT, K, movewindow, u"
                    "SUPER SHIFT, J, movewindow, d"
                    "SUPER SHIFT, left, movewindow, l"
                    "SUPER SHIFT, right, movewindow, r"
                    "SUPER SHIFT, up, movewindow, u"
                    "SUPER SHIFT, down, movewindow, d"

#---------------------------------------------------------------#
# Move active window to a workspace with mainMod + ctrl + [0-9] #
#---------------------------------------------------------------#
# "SUPER $mainMod CTRL, 1, movetoworkspace, 1"
# "SUPER $mainMod CTRL, 2, movetoworkspace, 2"
# "SUPER $mainMod CTRL, 3, movetoworkspace, 3"
# "SUPER $mainMod CTRL, 4, movetoworkspace, 4"
# "SUPER $mainMod CTRL, 5, movetoworkspace, 5"
# "SUPER $mainMod CTRL, 6, movetoworkspace, 6"
# "SUPER $mainMod CTRL, 7, movetoworkspace, 7"
# "SUPER $mainMod CTRL, 8, movetoworkspace, 8"
# "SUPER $mainMod CTRL, 9, movetoworkspace, 9"
# "SUPER $mainMod CTRL, 0, movetoworkspace, 10"
# "SUPER $mainMod CTRL, left, movetoworkspace, -1"
# "SUPER $mainMod CTRL, right, movetoworkspace, +1"

# same as above, but doesnt switch to the workspace

                    "SUPER $mainMod SHIFT, 1, movetoworkspacesilent, 1"
                    "SUPER $mainMod SHIFT, 2, movetoworkspacesilent, 2"
                    "SUPER $mainMod SHIFT, 3, movetoworkspacesilent, 3"
                    "SUPER $mainMod SHIFT, 4, movetoworkspacesilent, 4"
                    "SUPER $mainMod SHIFT, 5, movetoworkspacesilent, 5"
                    "SUPER $mainMod SHIFT, 6, movetoworkspacesilent, 6"
                    "SUPER $mainMod SHIFT, 7, movetoworkspacesilent, 7"
                    "SUPER $mainMod SHIFT, 8, movetoworkspacesilent, 8"

                    ",Print,exec,screenshot"
                    ];

                bindm = [
# Mouse binds
                  "SUPER,mouse:272,movewindow"
                    "SUPER,mouse:273,resizewindow"
                ];


                windowrulev2 = "suppressevent maximize, class:.*"; # You'll probably like this.;




      };
    };


# Hyprland configuration files
      xdg.configFile = {
        "hypr/store/dynamic_out.txt".source = ./store/dynamic_out.txt;
        "hypr/store/prev.txt".source = ./store/prev.txt;
        "hypr/store/latest_notif".source = ./store/latest_notif;

      };

    };
  }
