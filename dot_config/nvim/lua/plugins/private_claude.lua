-- Claude Code CLI Integration
return {
  "folke/snacks.nvim",
  keys = {
    {
      "<leader>cc",
      function()
        Snacks.terminal("claude", {
          win = {
            position = "float",
            width = 0.85,
            height = 0.85,
            border = "rounded",
            title = " Claude Code ",
            title_pos = "center",
          },
        })
      end,
      desc = "Claude Code",
    },
    {
      "<leader>cC",
      function()
        -- Claude mit aktuellem File context
        local file = vim.fn.expand("%:p")
        Snacks.terminal("claude " .. vim.fn.shellescape(file), {
          win = {
            position = "float",
            width = 0.85,
            height = 0.85,
            border = "rounded",
            title = " Claude Code ",
            title_pos = "center",
          },
        })
      end,
      desc = "Claude Code (current file)",
    },
  },
}
