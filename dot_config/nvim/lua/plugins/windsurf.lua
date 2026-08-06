return {
  "Exafunction/windsurf.vim",
  -- InsertEnter statt BufEnter: sonst spawnt der language_server auch headless
  -- und blockiert dort jedes :qa (Skripte/Formatter-Batches haengen)
  event = "InsertEnter",
  init = function()
    vim.g.codeium_disable_bindings = 1
  end,
  config = function()
    local opts = { expr = true, silent = true }
    vim.keymap.set("i", "<C-g>", function() return vim.fn["codeium#Accept"]() end, opts)
    vim.keymap.set("i", "<M-]>", function() return vim.fn["codeium#CycleCompletions"](1) end, opts)
    vim.keymap.set("i", "<M-[>", function() return vim.fn["codeium#CycleCompletions"](-1) end, opts)
    -- C-] (codeium-default) statt C-x: C-x ist der native Completion-Prefix (C-x C-l/C-f)
    vim.keymap.set("i", "<C-]>", function() return vim.fn["codeium#Clear"]() end, opts)
  end,
}
