return {
  {
    -- Seitenleiste (snacks) rendert ueber devicons, nicht mini.icons
    "nvim-tree/nvim-web-devicons",
    opts = {
      override_by_extension = {
        tofu = { icon = "󰆦", color = "#e0af68", name = "OpenTofu" },
      },
    },
  },
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
