return {
  {
    "echasnovski/mini.icons",
    init = function()
      -- .tofu (OpenTofu) = gleiche Pipeline wie .tf: highlighting, terraformls, terraform_fmt
      vim.filetype.add({ extension = { tofu = "terraform" } })
    end,
    opts = {
      extension = {
        -- Tofu-Wuerfel (nf-md-cube U+F01A6) in OpenTofu-Gelb statt Terraform-Lila
        tofu = { glyph = "󰆦", hl = "MiniIconsYellow" },
      },
    },
  },
}
