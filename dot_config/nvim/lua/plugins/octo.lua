-- GitHub PRs & Issues direkt in Neovim (braucht eingeloggtes `gh`)
return {
  "pwntester/octo.nvim",
  cmd = "Octo",
  dependencies = { "nvim-lua/plenary.nvim" },
  opts = {
    picker = "snacks",
    enable_builtin = true,
  },
  keys = {
    { "<leader>gO", "<cmd>Octo pr list<cr>", desc = "Octo: PR-Liste" },
  },
}
