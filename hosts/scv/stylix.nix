
{ inputs, pkgs, ... }:
let
  themes = {
    catppuccin-mocha = "catppuccin-mocha";
    mountain = "mountain";
    google-dark="google-dark";
    oxocarbon-dark = "oxocarbon-dark";
    jabuti = {
      scheme = "Jabuti";
      author = "Notusknot";
      base00 = "292a37";
      base01 = "343545";
      base02 = "3c3e51";
      base03 = "45475d";
      base04 = "50526b";
      base05 = "c0cbe3";
      base06 = "d9e0ee";
      base07 = "ffffff";
      base08 = "ec6a88";
      base09 = "efb993";
      base0A = "e1c697";
      base0B = "3fdaa4";
      base0C = "ff7eb6";
      base0D = "3fc6de";
      base0E = "be95ff";
      base0F = "8b8da9";
    };
  };
in
{
  stylix = {
    enable = true;
    autoEnable = true;
    image = ./wallpaper/clay-banks-hwLAI5lRhdM-unsplash.jpg;
    base16Scheme = "${pkgs.base16-schemes}/share/themes/3024.yaml";
    # base16Scheme = themes.jabuti;
    fonts = {
      monospace = {
        package = pkgs.noto-fonts-cjk-sans;
        name = "noto-fonts Mono";
      };
      sansSerif = {
        package = pkgs.dejavu_fonts;
        name = "DejaVu Sans";
      };
      serif = {
        package = pkgs.dejavu_fonts;
        name = "DejaVu Serif";
      };
      sizes = {
        applications = 11;
        terminal = 12;
        desktop = 11;
        popups = 11;
      };
    };
    opacity = {
      applications = 1.0;
      terminal = 0.95;
      desktop = 1.0;
      popups = 1.0;
    };
    polarity = "dark";
    targets = {
      grub.enable = false;
      gnome.enable = false;
      fish.enable = false;
      gtk.enable = true;
      nixos-icons.enable = true;
    };
  };
}
