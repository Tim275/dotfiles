-- Options are automatically loaded before lazy.nvim startup
-- Default options that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/options.lua
-- Add any additional options here

-- Add NVM node to PATH for LSP servers (yaml-language-server, etc.)
vim.env.PATH = vim.env.HOME .. "/.nvm/versions/node/v22.19.0/bin:" .. vim.env.PATH

vim.opt.wrap = true
vim.g.codeium_os = "Darwin"
vim.g.codeium_arch = "arm64"
