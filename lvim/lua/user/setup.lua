-- Check if clangd is installed on the system
-- This is to prevent formatting lsp error 
if os.execute("which clangd") == 0 then
    -- If clangd is installed, continue with setup
    vim.list_extend(lvim.lsp.automatic_configuration.skipped_servers, { "clangd" })
    local capabilities = require("lvim.lsp").common_capabilities()
    capabilities.offsetEncoding = { "utf-16" }
    local opts = { capabilities = capabilities }
    require("lvim.lsp.manager").setup("clangd", opts)
else
    print("clangd is not installed on the system.")
end


