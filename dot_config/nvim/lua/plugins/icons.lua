local glyph = vim.fn.nr2char

-- Codepoints statt Literale: PUA-Zeichen ueberleben Copy-Paste/Editoren nicht zuverlaessig
local cube = glyph(0xF01A6) -- nf-md-cube
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
      },
    },
  },
  {
    "nvim-mini/mini.icons",
    init = function()
      -- .tofu (OpenTofu) = gleiche Pipeline wie .tf: highlighting, terraformls, terraform_fmt
      vim.filetype.add({ extension = { tofu = "terraform" } })
    end,
    opts = {
      extension = {
        tofu = { glyph = cube, hl = "MiniIconsYellow" },
        yaml = { glyph = yml, hl = "MiniIconsRed" },
        yml = { glyph = yml, hl = "MiniIconsRed" },
      },
    },
  },
}
