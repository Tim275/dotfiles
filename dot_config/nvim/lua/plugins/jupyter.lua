return {
  {
    "3rd/image.nvim",
    lazy = true,
    opts = {
      backend = "kitty",
      processor = "magick_cli",
      max_width_window_percentage = math.huge,
      max_height_window_percentage = math.huge,
      window_overlap_clear_enabled = true,
      window_overlap_clear_ft_ignore = { "cmp_menu", "cmp_docs", "snacks_notif" },
    },
  },
  {
    "benlubas/molten-nvim",
    version = "^1.0.0",
    dependencies = { "3rd/image.nvim" },
    build = ":UpdateRemotePlugins",
    init = function()
      vim.g.molten_image_provider = "image.nvim"
      vim.g.molten_output_win_max_height = 20
      vim.g.molten_auto_open_output = false
      vim.g.molten_wrap_output = true
      vim.g.molten_virt_text_output = true
      vim.g.molten_virt_lines_off_by_1 = true
    end,
    keys = {
      { "<leader>m", "", desc = "+molten" },
      { "<leader>mi", "<cmd>MoltenInit<cr>", desc = "Molten init" },
      { "<leader>me", "<cmd>MoltenEvaluateOperator<cr>", desc = "eval operator" },
      { "<leader>ml", "<cmd>MoltenEvaluateLine<cr>", desc = "eval line" },
      { "<leader>mr", "<cmd>MoltenReevaluateCell<cr>", desc = "re-eval cell" },
      { "<leader>mv", ":<C-u>MoltenEvaluateVisual<cr>gv", mode = "v", desc = "eval visual" },
      { "<leader>mo", "<cmd>MoltenShowOutput<cr>", desc = "show output" },
      { "<leader>mh", "<cmd>MoltenHideOutput<cr>", desc = "hide output" },
      { "<leader>md", "<cmd>MoltenDelete<cr>", desc = "delete cell" },
    },
  },
  {
    "GCBallesteros/jupytext.nvim",
    lazy = false,
    opts = {
      style = "markdown",
      output_extension = "auto",
      force_ft = nil,
    },
  },
}
