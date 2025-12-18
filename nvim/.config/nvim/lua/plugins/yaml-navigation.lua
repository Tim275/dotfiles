-- ============================================================================
-- YAML.NVIM - Kubernetes Manifest Navigation
-- For navigating large YAML files (Helm charts, Kustomize, etc.)
-- ============================================================================

return {
  -- yaml.nvim - Navigate YAML like a pro
  {
    "cuducos/yaml.nvim",
    ft = { "yaml", "yml" },
    dependencies = {
      "nvim-treesitter/nvim-treesitter",
      "nvim-telescope/telescope.nvim",
    },
    keys = {
      { "<leader>yy", "<cmd>YAMLView<cr>", desc = "YAML: View path" },
      { "<leader>yY", "<cmd>YAMLYank<cr>", desc = "YAML: Yank path" },
      { "<leader>yq", "<cmd>YAMLQuickfix<cr>", desc = "YAML: Quickfix keys" },
      { "<leader>yt", "<cmd>YAMLTelescope<cr>", desc = "YAML: Telescope keys" },
    },
    config = function()
      require("yaml_nvim").setup({
        -- Show the full YAML path in the winbar
        -- Useful for deep Kubernetes manifests
      })
    end,
  },

  -- Enhanced YAML schema support via SchemaStore
  {
    "b0o/SchemaStore.nvim",
    lazy = true,
    version = false,
  },

  -- Helm file detection and syntax
  {
    "towolf/vim-helm",
    ft = "helm",
  },

  -- Better YAML folding
  {
    "pedrohdz/vim-yaml-folds",
    ft = { "yaml", "yml" },
  },
}
