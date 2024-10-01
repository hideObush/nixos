{
  config,
  pkgs,
  inputs,
  ...
}: {
  programs.neovim = let

  in {
    enable = true;
    package = inputs.neovim-nightly-overlay.packages.${pkgs.system}.default;
    viAlias = true;
    vimAlias = true;
    vimdiffAlias = true;

    extraPackages = with pkgs; [
      lua-language-server
      alejandra
      nixd
      tree-sitter
    ];
    plugins = with pkgs.vimPlugins; [

    nvim-treesitter-parsers.typescript
        # plugin = nvim-lspconfig;
        # config = toLuaFile ./nvim/plugin/lsp.lua;
    ];
  };
}
