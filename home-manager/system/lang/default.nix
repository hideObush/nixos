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
          pkgs.gcc14
          pkgs.cargo
          pkgs.rustc
          pkgs.typescript
          # pkgs.llvmPackages_12.clang-unwrapped
          pkgs.libclang
          pkgs.gdb
          # pkgs.clang-tools
          pkgs.glibc
          pkgs.pkg-config
          # pkgs.stdenv
          pkgs.gnumake
          pkgs.cmake
          pkgs.ninja
          pkgs.python3

      ];
    };
  };
}

