require("codecompanion").setup({
  adapters = {
    ollama = function()
      return require("codecompanion.adapters").use("ollama", {
        schema = {
          model = { default = "qwen2.5-coder:7b" } -- Replace with your desired model
        }
      })
    end,
  },
  strategies = {
    chat = { adapter = "ollama" },
    inline = { adapter = "ollama" },
    agent = { adapter = "ollama" },
  },
})
