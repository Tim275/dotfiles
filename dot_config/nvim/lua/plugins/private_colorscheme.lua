return {
  {
    "folke/tokyonight.nvim",
    lazy = false,
    priority = 1000,
    opts = {
      style = "night",
      transparent = false,
      terminal_colors = true,
      styles = {
        comments = { italic = true },
        keywords = { italic = true },
        sidebars = "dark",
        floats = "dark",
      },
      -- dunkleres, saettigteres Navy statt Stock-#1a1b26 (josean-dev-Palette)
      on_colors = function(colors)
        colors.bg = "#011628"
        colors.bg_dark = "#011423"
        colors.bg_float = "#011423"
        colors.bg_highlight = "#143652"
        colors.bg_popup = "#011423"
        colors.bg_search = "#0A64AC"
        colors.bg_sidebar = "#011423"
        colors.bg_statusline = "#011423"
        colors.bg_visual = "#275378"
        colors.border = "#547998"
        colors.fg = "#CBE0F0"
        colors.fg_dark = "#B4D0E9"
        colors.fg_float = "#CBE0F0"
        colors.fg_gutter = "#627E97"
        colors.fg_sidebar = "#B4D0E9"
      end,
    },
  },

  {
    "LazyVim/LazyVim",
    opts = {
      colorscheme = "tokyonight-night",
    },
  },
}
