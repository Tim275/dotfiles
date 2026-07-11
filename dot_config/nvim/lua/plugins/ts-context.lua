return {
  "nvim-treesitter/nvim-treesitter-context",
  event = "LazyFile",
  opts = { max_lines = 3, multiline_threshold = 1, separator = "─" },
  keys = {
    { "<leader>ut", function() require("treesitter-context").toggle() end, desc = "Toggle Treesitter Context" },
  },
}
