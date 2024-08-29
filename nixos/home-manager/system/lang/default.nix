{
  inputs,
  lib,
  pkgs,
  config,
  ...
}: {
  options = {
    lang.enable = lib.mkEnableOption "Enable lang module";
  };
  config = lib.mkIf config.lang.enable {
    home = {
      packages =  [
        pkgs.nodejs_22
          pkgs.gccgo14
          pkgs.cargo
          pkgs.rustc
      ];
    };
  };
}

