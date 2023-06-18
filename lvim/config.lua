-- vim options
vim.opt.shiftwidth = 2
vim.opt.tabstop = 2
vim.opt.relativenumber = true

-- general
lvim.log.level = "warn"
lvim.format_on_save = {
  enabled = true,
  pattern = { "*.lua", "*.py", "*.c", ".h" },
  timeout = 1000,
}
-- to disable icons and use a minimalist setup, uncomment the following
-- lvim.use_icons = false

-- keymappings <https://www.lunarvim.org/docs/configuration/keybindings>
lvim.leader = "space"
lvim.keys.normal_mode["<C-s>"] = ":w<cr>"
lvim.keys.insert_mode["jk"] = "<esc>"

-- -- Use which-key to add extra bindings with the leader-key prefix
lvim.builtin.which_key.mappings["W"] = { "<cmd>noautocmd w<cr>", "Save without formatting" }
lvim.builtin.which_key.mappings["P"] = { "<cmd>Telescope projects<CR>", "Projects" }
lvim.builtin.which_key.mappings["Q"] = { "<cmd>qall<CR>", "Quit All" }
lvim.builtin.which_key.mappings["D"] = {
  name = "DiffView",
  h = { "<cmd>DiffviewFileHistory %<cr>", "File History" },
  c = { "<cmd>DiffviewClose <cr>", "Close" },
  o = { "<cmd>lua DiffviewOpenCustom()<cr>", "Open" }
}

-- -- Change theme settings
lvim.colorscheme = "catppuccin-mocha"

lvim.builtin.alpha.active = true
lvim.builtin.alpha.mode = "dashboard"
lvim.builtin.terminal.active = true
lvim.builtin.nvimtree.setup.view.side = "left"
lvim.builtin.nvimtree.setup.renderer.icons.show.git = true

-- Automatically install missing parsers when entering buffer
lvim.builtin.treesitter.auto_install = true

-- always installed on startup, useful for parsers without a strict filetype
lvim.builtin.treesitter.ensure_installed = { "comment", "markdown_inline", "regex", "python" }

-- set a formatter, this will override the language server formatting capabilities (if it exists)
local formatters = require "lvim.lsp.null-ls.formatters"
formatters.setup {
  { command = "black",        filetypes = { "python" } },
  { command = "isort",        filetypes = { "python" } },
  { command = "clang_format", filetypes = { "c", "cpp" } },
}

-- -- Additional Plugins <https://www.lunarvim.org/docs/plugins#user-plugins>
vim.list_extend(lvim.lsp.automatic_configuration.skipped_servers, { "clangd" })
local capabilities = require("lvim.lsp").common_capabilities()
capabilities.offsetEncoding = { "utf-16" }
local opts = { capabilities = capabilities }
require("lvim.lsp.manager").setup("clangd", opts)

lvim.plugins = {
  {
    "sainnhe/gruvbox-material"
  },
  { "catppuccin/nvim", name = "catppuccin" },
  {
    "github/copilot.vim"
  },
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

-- Custom functions
function DiffviewOpenCustom()
  local arg1 = vim.fn.input('Enter first argument: ')
  local arg2 = vim.fn.input('Enter second argument: ')
  vim.cmd('DiffviewOpen ' .. arg1 .. ' ' .. arg2)
end

reload "user.copilot"
