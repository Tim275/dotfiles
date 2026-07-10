-- Options are automatically loaded before lazy.nvim startup
-- Default options that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/options.lua
-- Add any additional options here

-- Add NVM node to PATH for LSP servers (yaml-language-server, etc.)
-- NVM Node dynamisch laden (unabhängig von der Version)
local nvm_default = vim.env.HOME .. "/.nvm/alias/default"
local node_version = vim.fn.system("cat " .. nvm_default):gsub("%s+", "")
local node_bin = vim.env.HOME .. "/.nvm/versions/node/v" .. node_version .. "/bin"
if vim.fn.isdirectory(node_bin) == 1 then
  vim.env.PATH = node_bin .. ":" .. vim.env.PATH
end

vim.opt.wrap = true
vim.opt.number = true
vim.opt.relativenumber = false
vim.opt.cursorline = true
vim.opt.guicursor = "n-v-c:block-Cursor,i-ci-ve:block-Cursor,r-cr:hor20,o:hor50"

vim.api.nvim_set_hl(0, "Cursor", { fg = "#000000", bg = "#ff0000" })
vim.api.nvim_set_hl(0, "CursorLine", { bg = "#1e1e2e" })
vim.api.nvim_set_hl(0, "CursorLineNr", { fg = "#ff0000", bold = true })
vim.g.codeium_os = "Darwin"
vim.g.codeium_arch = "arm64"

vim.g.loaded_ruby_provider = 0
vim.g.loaded_perl_provider = 0

vim.g.lazyvim_picker = "snacks"
vim.g.lazyvim_python_lsp = "basedpyright"
