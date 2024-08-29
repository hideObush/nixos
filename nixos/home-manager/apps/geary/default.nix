
{
  pkgs,
  lib,
  config,
  ...
}: {
  options = {
    geary.enable = lib.mkEnableOption "Enable geary module";
  };
  config = lib.mkIf config.geary.enable {
    home.packages = with pkgs; [
      gnome.geary
    ];
  };
}
