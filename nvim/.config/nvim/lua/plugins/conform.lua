-- ============================================================================
-- CONFORM.NVIM - Auto-formatting for DevOps files
-- ============================================================================

return {
  "stevearc/conform.nvim",
  opts = {
    formatters_by_ft = {
      -- Kubernetes/YAML
      yaml = { "yamlfmt" },

      -- Terraform/HCL
      terraform = { "terraform_fmt" },
      tf = { "terraform_fmt" },
      ["terraform-vars"] = { "terraform_fmt" },
      hcl = { "terraform_fmt" },

      -- Shell scripts
      sh = { "shfmt" },
      bash = { "shfmt" },
      zsh = { "shfmt" },

      -- Docker
      dockerfile = { "hadolint" },

      -- JSON
      json = { "jq" },
      jsonc = { "jq" },

      -- Markdown
      markdown = { "prettier" },

      -- Go (already handled by LazyVim, but explicit)
      go = { "gofumpt", "goimports" },

      -- Python
      python = { "ruff_format", "ruff_fix" },

      -- Lua
      lua = { "stylua" },

      -- TOML
      toml = { "taplo" },
    },
    formatters = {
      yamlfmt = {
        command = "yamlfmt",
        args = { "-formatter", "basic", "-indentless_arrays=true" },
      },
      shfmt = {
        command = "shfmt",
        args = { "-i", "2", "-ci", "-bn" }, -- 2 space indent, case indent, binary newline
      },
      jq = {
        command = "jq",
        args = { "." },
      },
    },
  },
}
