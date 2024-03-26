return {
  "jackMort/ChatGPT.nvim",
  event = "VeryLazy",
  config = function()
    require("chatgpt").setup({
      openai_params = {
        model = "gpt-4",
        frequency_penalty = 0,
        presence_penalty = 0,
        max_tokens = 1000,
        temperature = 0,
        top_p = 1,
        n = 1,
      },
      openai_edit_params = {
        model = "gpt-4",
        frequency_penalty = 0,
        presence_penalty = 0,
        temperature = 0,
        top_p = 1,
        n = 1,
      },
    })
    -- Require which-key
    local wk = require("which-key")
    -- Define new keybindings
    local newBindings = {
      ["<leader>a"] = { name = "ChatGPT" },
    }
    -- Register the new keybindings with which-key
    wk.register(newBindings, { mode = { "n", "v" } })
  end,
  dependencies = {
    "MunifTanjim/nui.nvim",
    "nvim-lua/plenary.nvim",
    "folke/trouble.nvim",

    "nvim-telescope/telescope.nvim",
  },
  keys = {
    { "<leader>ac", "<cmd>ChatGPT<CR>", desc = "Chat", mode = { "n", "v" } },
    { "<leader>ae", "<cmd>ChatGPTEditWithInstructions<CR>", desc = "Edit with instructions", mode = { "n", "v" } },
    { "<leader>ax", "<cmd>ChatGPTRun explain_code<CR>", desc = "Explain code", mode = { "n", "v" } },
    { "<leader>aa", "<cmd>ChatGPTRun add_tests<CR>", desc = "Add tests", mode = { "n", "v" } },
    { "<leader>ao", "<cmd>ChatGPTRun optimize_code<CR>", desc = "Optimize code", mode = { "n", "v" } },
  },
}
