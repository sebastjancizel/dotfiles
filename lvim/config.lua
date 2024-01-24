-- vim options
vim.opt.shiftwidth = 2
vim.opt.tabstop = 2
vim.opt.relativenumber = true
vim.opt.timeoutlen = 250

-- general
lvim.log.level = "warn"
lvim.format_on_save = {
  enabled = true,
  pattern = { "*.lua", "*.py", "*.c", ".h", "*.cpp" },
  timeout = 1000,
}
-- to disable icons and use a minimalist setup, uncomment the following

-- keymappings <https://www.lunarvim.org/docs/configuration/keybindings>
lvim.leader = "space"
lvim.keys.normal_mode["<C-s>"] = ":w<cr>"
lvim.keys.insert_mode["jk"] = "<esc>"

local which_key = lvim.builtin.which_key
-- -- Use which-key to add extra bindings with the leader-key prefix
which_key.mappings["W"] = { "<cmd>noautocmd w<cr>", "Save without formatting" }
which_key.mappings["P"] = { "<cmd>Telescope projects<CR>", "Projects" }
which_key.mappings["Q"] = { "<cmd>qall<CR>", "Quit All" }
which_key.mappings["D"] = {
  h = { "<cmd>DiffviewFileHistory %<cr>", "File History" },
  c = { "<cmd>DiffviewClose <cr>", "Close" },
  o = { "<cmd>lua DiffviewOpenCustom()<cr>", "Open" }
}

-- -- Change theme settings
lvim.colorscheme = "catppuccin-mocha"

lvim.builtin.alpha.active = true
lvim.builtin.alpha.mode = "dashboard"
lvim.builtin.terminal.active = true
lvim.builtin.nvimtree.setup.view.side = "right"
lvim.builtin.nvimtree.setup.renderer.icons.show.git = true

-- automatically install missing parsers when entering buffer
lvim.builtin.treesitter.auto_install = true

-- always installed on startup, useful for parsers without a strict filetype
lvim.builtin.treesitter.ensure_installed = { "comment", "markdown_inline", "regex", "python", "c" }
lvim.builtin.telescope.defaults.layout_config.preview_cutoff = 75
lvim.builtin.mason.ensure_installed = { "clangd" }

lvim.builtin.lualine.options.section_separators = { left = '', right = '' }

-- set a formatter, this will override the language server formatting capabilities (if it exists)
local formatters = require "lvim.lsp.null-ls.formatters"
formatters.setup {
  { command = "black",        filetypes = { "python" } },
  { command = "isort",        filetypes = { "python" } },
  { command = "clang_format", filetypes = { "c", "cpp" } },
}

-- -- Additional Plugins <https://www.lunarvim.org/docs/plugins#user-plugins>
if os.execute("which clangd") == 0 then
  vim.list_extend(lvim.lsp.automatic_configuration.skipped_servers, { "clangd" })
  local capabilities = require("lvim.lsp").common_capabilities()
  capabilities.offsetEncoding = { "utf-16" }
  local opts = { capabilities = capabilities }
  require("lvim.lsp.manager").setup("clangd", opts)
end


-- Custom functions
function DiffviewOpenCustom()
  local arg1 = vim.fn.input('Enter first argument: ')
  local arg2 = vim.fn.input('Enter second argument: ')
  vim.cmd('DiffviewOpen ' .. arg1 .. ' ' .. arg2)
end

require("user.plugins")
require("user.copilot")
require("user.chatgpt")
