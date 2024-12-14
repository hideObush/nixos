{
  # NOTE: the args not used in this file CAN NOT be removed!
  # because haumea pass argument lazily,
  # and these arguments are used in the functions like `mylib.nixosSystem`, `mylib.colmenaSystem`, etc.
  inputs,
  lib,
  myvars,
  mylib,
  system,
  genSpecialArgs,
  ...
} @ args: let
  # 星野 アイ, Hoshino Ai
  name = "ai";
  base-modules = {
    wsl-modules = map mylib.relativeToRoot [
      # # common
      # "modules/nixos/desktop.nix"
      # host specific
      "hosts/wsl-${name}"
      # nixos hardening
    ];
    home-modules = map mylib.relativeToRoot [
      # common
      "home/wsl.nix"
      # host specific
      # "hosts/idols-${name}/home.nix"
    ];
  };
in {
  wslConfigurations = {
    # host with hyprland compositor
    "${name}-wsl" = mylib.nixosSystem (modules-hyprland // args);
  };

  # generate iso image for hosts with desktop environment
  packages = {
    "${name}-wsl" = inputs.self.wslConfigurations."${name}-wsl".config.formats.iso;
  };
}
