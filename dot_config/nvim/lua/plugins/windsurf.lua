return {
  "Exafunction/windsurf.vim",
  event = "BufEnter",
  init = function()
    vim.g.codeium_disable_bindings = 1
  end,
  config = function()
    local opts = { expr = true, silent = true }
    vim.keymap.set("i", "<C-g>", function() return vim.fn["codeium#Accept"]() end, opts)
    vim.keymap.set("i", "<M-]>", function() return vim.fn["codeium#CycleCompletions"](1) end, opts)
    vim.keymap.set("i", "<M-[>", function() return vim.fn["codeium#CycleCompletions"](-1) end, opts)
    vim.keymap.set("i", "<C-x>", function() return vim.fn["codeium#Clear"]() end, opts)
  end,
}
