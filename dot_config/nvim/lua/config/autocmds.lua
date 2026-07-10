-- Autocmds are automatically loaded on the VeryLazy event
-- Default autocmds that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/autocmds.lua
--
-- Roter Cursor im Terminal
vim.api.nvim_create_autocmd({ "VimEnter", "VimResume", "FocusGained" }, {
  callback = function()
    io.write("\027]12;#ff0000\007")
    io.flush()
  end,
})

vim.api.nvim_create_autocmd({ "VimLeave", "VimSuspend", "FocusLost" }, {
  callback = function()
    io.write("\027]112\007")
    io.flush()
  end,
})

vim.api.nvim_create_autocmd({ "BufReadPost", "BufWritePost" }, {
  pattern = { "*/.github/workflows/*.yml", "*/.github/workflows/*.yaml" },
  callback = function()
    local ok, lint = pcall(require, "lint")
    if ok then lint.try_lint("actionlint") end
  end,
})
