require "nvchad.mappings"

-- add yours here

local map = vim.keymap.set

map("n", ";", ":", { desc = "CMD enter command mode" })
map("n", "L", "$")
map("n", "H", "^")
map("n", "<leader>jq","<cmd>%!jq '.'<CR>",{ desc = "make json file to see easier"})

map("n","<leader>rn","<cmd>lua vim.lsp.buf.rename<CR>",{desc = "lsp-rename}"})

-- map({ "n", "i", "v" }, "<C-s>", "<cmd> w <cr>")
