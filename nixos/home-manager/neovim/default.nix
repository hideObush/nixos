{config,pkgs,inputs,...}:
{
  programs.neovim =
  let
    toLua = str: "lua << EOF\n${str}\nEOF\n";
    toLuaFile = file: "lua << EOF\n${builtins.readFile file}\nEOF\n";
  in 
  {
    enable = true;
    viAlias = true;
    vimAlias = true;
    vimdiffAlias =true;

    extraPackages = with pkgs; [
    lua-language-server
    rnix-lsp


    ];
    plugins =with pkgs.vimPlugins; [
    base46
    
    {
      plugin = nvim-lspconfig;
      config = toLuaFile ./nvim/plugin/lsp.lua;
    }
    ]

    
  }
}
