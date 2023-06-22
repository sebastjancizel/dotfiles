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
  {
    "ThePrimeagen/harpoon",
    config = function()
      require('harpoon')

      lvim.builtin.which_key.mappings["H"] = {
        name = "Harpoon",
        a = { "<cmd>lua require('harpoon.mark').add_file()<cr>", "Add Mark" },
        t = { "<cmd>lua require('harpoon.ui').toggle_quick_menu()<cr>", "Toggle Quick Menu" },
        n = { "<cmd>lua require('harpoon.ui').nav_next()<cr>", "Navigate Next" },
        p = { "<cmd>lua require('harpoon.ui').nav_prev()<cr>", "Navigate Previous" },
        f = {
          name = "Navigate to File",
          ["1"] = { "<cmd>lua require('harpoon.ui').nav_file(1)<cr>", "File 1" },
          ["2"] = { "<cmd>lua require('harpoon.ui').nav_file(2)<cr>", "File 2" },
          ["3"] = { "<cmd>lua require('harpoon.ui').nav_file(3)<cr>", "File 3" },
          ["4"] = { "<cmd>lua require('harpoon.ui').nav_file(4)<cr>", "File 4" },
          ["5"] = { "<cmd>lua require('harpoon.ui').nav_file(5)<cr>", "File 5" },
        },
      }
    end,
  },
}
