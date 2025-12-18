-- ============================================================================
-- GH-ACTIONS.NVIM - GitHub Actions Support (2025)
-- https://github.com/Hdoc1509/gh-actions.nvim
-- ============================================================================

return {
  {
    "Hdoc1509/gh-actions.nvim",
    enabled = false, -- Disabled: luaopen_actions symbol error
    ft = { "yaml", "yml" },
    dependencies = {
      "nvim-lua/plenary.nvim",
      "MunifTanjim/nui.nvim",
    },
    opts = {
      -- Highlights for GitHub Actions specific syntax
      highlight = {
        enabled = true,
      },
    },
    keys = {
      { "<leader>Ga", "<cmd>GhActionsRun<cr>", desc = "GitHub: Run Action" },
      { "<leader>Gl", "<cmd>GhActionsListWorkflows<cr>", desc = "GitHub: List Workflows" },
      { "<leader>Gs", "<cmd>GhActionsListRuns<cr>", desc = "GitHub: List Runs" },
    },
  },
}
