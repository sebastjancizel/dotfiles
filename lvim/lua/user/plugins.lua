lvim.plugins = {
  { "catppuccin/nvim", name = "catppuccin" },
  { "morhetz/gruvbox", name = "gruvbox" },
  { "tpope/vim-repeat" },
  {
    "zbirenbaum/copilot.lua",
    config = function()
      require("copilot").setup()
      lvim.builtin.which_key.mappings["C"] = {
        name = "Copilot",
        e = { "<cmd>Copilot enable<cr>", "Copilot enable" },
        d = { "<cmd>Copilot disable<cr>", "Copilot disable" },
        s = { "<cmd>Copilot status<cr>", "Copilot status" },
        p = { "<cmd>Copilot panel<cr>", "Copilot panel" },
      }
    end,
  },
  -- lazy.nvim
  {
    "folke/noice.nvim",
    event = "VeryLazy",
    opts = {
      -- add any options here
    },
    dependencies = {
      -- if you lazy-load any plugin below, make sure to add proper `module="..."` entries
      "MunifTanjim/nui.nvim",
      -- OPTIONAL:
      --   `nvim-notify` is only needed, if you want to use the notification view.
      --   If not available, we use `mini` as the fallback
      "rcarriga/nvim-notify",
    }
  },
  {
    "zbirenbaum/copilot-cmp",
    event = "InsertEnter",
    dependencies = { "zbirenbaum/copilot.lua" },
    config = function()
      vim.defer_fn(function()
        require("copilot").setup()     -- https://github.com/zbirenbaum/copilot.lua/blob/master/README.md#setup-and-configuration
        require("copilot_cmp").setup() -- https://github.com/zbirenbaum/copilot-cmp/blob/master/README.md#configuration
      end, 100)
    end,
  },
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
    "jackMort/ChatGPT.nvim",
    event = "VeryLazy",
    dependencies = {
      "MunifTanjim/nui.nvim",
      "nvim-lua/plenary.nvim",
      "nvim-telescope/telescope.nvim"
    }
  },
  {
    "amitds1997/remote-nvim.nvim",
    version = "*",                     -- Pin to GitHub releases
    dependencies = {
      "nvim-lua/plenary.nvim",         -- For standard functions
      "MunifTanjim/nui.nvim",          -- To build the plugin UI
      "nvim-telescope/telescope.nvim", -- For picking b/w different remote methods
    },
    config = true,
  }
}
