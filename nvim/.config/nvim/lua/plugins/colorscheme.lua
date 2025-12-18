-- ============================================================================
-- COLORSCHEME - Enterprise Best Practice
-- ============================================================================

return {
  -- Kanagawa (Primary)
  {
    "rebelot/kanagawa.nvim",
    lazy = false,
    priority = 1000,
    opts = {
      compile = false,
      undercurl = true,
      commentStyle = { italic = true },
      keywordStyle = { italic = true },
      statementStyle = { bold = true },
      transparent = false,
      dimInactive = false,
      terminalColors = true,
      theme = "dragon", -- dragon = darkest, most consistent
    },
    config = function(_, opts)
      require("kanagawa").setup(opts)
      vim.cmd("colorscheme kanagawa-dragon")
    end,
  },

  -- Cyberdream (Backup - :colorscheme cyberdream)
  {
    "scottmckendry/cyberdream.nvim",
    lazy = true,
    opts = {
      transparent = false,
      italic_comments = true,
      terminal_colors = true,
    },
  },

  -- LazyVim default
  {
    "LazyVim/LazyVim",
    opts = {
      colorscheme = "kanagawa-dragon",
    },
  },
}
