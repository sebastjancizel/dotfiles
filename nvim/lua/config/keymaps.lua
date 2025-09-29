-- Keymaps are automatically loaded on the VeryLazy event
-- Default keymaps that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/keymaps.lua
-- Add any additional keymaps here

local map = vim.keymap.set

map("i", "jk", "<ESC>", { noremap = true, silent = true })

map("n", "<leader>bj", "<cmd>BufferLinePick<CR>", { noremap = true, silent = true, desc = "Jump to buffer" })
map("n", "<leader>bc", "<cmd>bd<CR>", { noremap = true, silent = true, desc = "Close buffer" })
map(
  "n",
  "<leader>W",
  "<cmd>noautocmd w<CR>",
  { noremap = true, silent = true, desc = "Write without triggering autocommands" }
)
map("n", "<leader>D", "<cmd>lua Snacks.dashboard()<CR>", { noremap = true, silent = true, desc = "Go to Dashboard" })

map("n", "gh", "<cmd>ClangdSwitchSourceHeader<CR>", { noremap = true, silent = true, desc = "Goto header" })
