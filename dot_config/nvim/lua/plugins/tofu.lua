return {
  {
    "echasnovski/mini.icons",
    init = function()
      -- .tofu (OpenTofu) = gleiche Pipeline wie .tf: highlighting, terraformls, terraform_fmt
      vim.filetype.add({ extension = { tofu = "terraform" } })
    end,
    opts = {
      extension = {
        tofu = { glyph = "󱁢", hl = "MiniIconsBlue" },
      },
    },
  },
}
