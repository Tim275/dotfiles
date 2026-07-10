return {
  {
    "mason-org/mason.nvim",
    opts = {
      ensure_installed = { "yamlfmt", "prettier", "taplo" },
    },
  },
  {
    "stevearc/conform.nvim",
    opts = {
      formatters_by_ft = {
        yaml = { "yamlfmt" },
        terraform = { "terraform_fmt" },
        tf = { "terraform_fmt" },
        ["terraform-vars"] = { "terraform_fmt" },
        hcl = { "terraform_fmt" },
        sh = { "shfmt" },
        bash = { "shfmt" },
        zsh = { "shfmt" },
        json = { "jq" },
        jsonc = { "jq" },
        markdown = { "prettier" },
        go = { "gofumpt", "goimports" },
        python = { "ruff_format", "ruff_fix" },
        lua = { "stylua" },
        toml = { "taplo" },
      },
      formatters = {
        yamlfmt = {
          command = "yamlfmt",
          args = { "-formatter", "basic", "-indentless_arrays=true" },
        },
        shfmt = {
          command = "shfmt",
          args = { "-i", "2", "-ci", "-bn" },
        },
        jq = {
          command = "jq",
          args = { "." },
        },
      },
    },
  },
}
