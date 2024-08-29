{
  lib,
  config,
  inputs,
  ...
}: {
  imports = [
    ./nix
    ./fonts
    ./lang
  ];
  # unstable-packages = final: _prev: {
  #   unstable = import inputs.nixpkgs-unstable {
  #     system = final.system;
  #     config.allowUnfree = true;
  #   };
  # };
  #
  options = {
    system.enable = lib.mkEnableOption "Enable system module";
  };
  config = lib.mkIf config.system.enable {
    nixy.enable = lib.mkDefault true;
    fonts.enable = lib.mkDefault true;
    lang.enable = lib.mkDefault true;
  };
}
