local glyph = vim.fn.nr2char

local cube = glyph(0xF01A6) -- nf-md-cube
local terraform = glyph(0xE69A) -- nf-seti-terraform
local yml = glyph(0xE6A8) -- nf-seti-yml

return {
  {
    -- Seitenleiste (snacks) rendert ueber devicons, nicht mini.icons
    "nvim-tree/nvim-web-devicons",
    opts = {
      override_by_extension = {
        tofu = { icon = cube, color = "#e0af68", name = "OpenTofu" },
        yaml = { icon = yml, color = "#f7768e", name = "Yaml" },
        yml = { icon = yml, color = "#f7768e", name = "Yml" },
        -- devicons hat fuer tfvars nur "fa-file" (generischer Klecks) hinterlegt
        tfvars = { icon = terraform, color = "#5f43e9", name = "Tfvars" },
      },
    },
  },
  {
    "nvim-mini/mini.icons",
    init = function()
      vim.filetype.add({ extension = { tofu = "terraform" } })
    end,
    opts = {
      extension = {
        tofu = { glyph = cube, hl = "MiniIconsYellow" },
        tfvars = { glyph = terraform, hl = "MiniIconsPurple" },
        tf = { glyph = terraform, hl = "MiniIconsPurple" },
        yaml = { glyph = yml, hl = "MiniIconsRed" },
        yml = { glyph = yml, hl = "MiniIconsRed" },
      },
    },
    config = function(_, opts)
      require("mini.icons").setup(opts)
      require("nvim-web-devicons")
      require("mini.icons").mock_nvim_web_devicons()
    end,
  },
}
