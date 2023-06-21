lvim.plugins = {
  { "sainnhe/gruvbox-material" },
  { "ThePrimeagen/harpoon" },
  { "catppuccin/nvim",                        name = "catppuccin" },
  { "github/copilot.vim" },
  { "nvim-treesitter/nvim-treesitter-context" },
  {
    "phaazon/hop.nvim",
    event = "BufRead",
    config = function()
      require("hop").setup()
      vim.api.nvim_set_keymap("n", "T", ":HopChar2<cr>", { silent = true })
      vim.api.nvim_set_keymap("n", "t", ":HopWord<cr>", { silent = true })
    end,
  },
  {
    "sindrets/diffview.nvim",
    event = "BufRead",
  },
  {
    "windwp/nvim-spectre",
    event = "BufRead",
    config = function()
      require("spectre").setup()
    end,
  },
}
