-- plugins/mojo.lua
return {
  {
    "neovim/nvim-lspconfig",
    opts = function(_, opts)
      local mojo_lsp_path = vim.env.VIRTUAL_ENV and (vim.env.VIRTUAL_ENV .. "/bin/mojo-lsp-server") or "mojo-lsp-server"

      opts.servers = opts.servers or {}
      opts.servers.mojo = {
        cmd = { mojo_lsp_path, "-I", ".", "--log=error" },
        handlers = { ["$/progress"] = function() end },
      }
    end,
  },
}
