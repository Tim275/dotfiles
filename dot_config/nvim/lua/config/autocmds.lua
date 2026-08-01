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

-- YAML/JSON-Keys traditionell rot (Override auf jedem Theme)
local function red_keys()
  for _, g in ipairs({ "@property", "@property.yaml", "@property.json", "@field", "@label.json" }) do
    vim.api.nvim_set_hl(0, g, { fg = "#ff6e5e" })
  end
end
vim.api.nvim_create_autocmd("ColorScheme", { callback = red_keys })
red_keys()

-- Binaerdateien (SQLite u.ae.) nie als Buchstabensalat rendern — zeigt nur
-- einen Hinweis, ruft bewusst KEIN anderes Plugin auf (das brach letztes Mal)
vim.api.nvim_create_autocmd("BufReadCmd", {
  pattern = { "*.db", "*.sqlite", "*.sqlite3", "*.db-wal", "*.db-shm" },
  callback = function(args)
    vim.bo[args.buf].modifiable = true
    vim.bo[args.buf].buftype = "nofile"
    vim.bo[args.buf].swapfile = false
    vim.api.nvim_buf_set_lines(args.buf, 0, -1, false, {
      "  Binärdatei: " .. vim.fn.fnamemodify(args.file, ":~"),
      "",
      "  nvim zeigt SQLite/Binärinhalt bewusst nicht als Text.",
      "  Für SQL-Browsing: :DBUI  (dadbod-ui)",
    })
    vim.bo[args.buf].modifiable = false
  end,
})
