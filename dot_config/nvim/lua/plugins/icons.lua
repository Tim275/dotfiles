local glyph = vim.fn.nr2char

local cube = glyph(0xF01A6) -- nf-md-cube
local yml = glyph(0xE6A8) -- nf-seti-yml
local terraform = glyph(0xE69A) -- nf-seti-terraform

return {
  {
    "nvim-mini/mini.icons",
    init = function()
      vim.filetype.add({ extension = { tofu = "terraform" } })
    end,
    opts = {
      extension = {
        tofu = { glyph = cube, hl = "MiniIconsYellow" },
        yaml = { glyph = yml, hl = "MiniIconsBlue" },
        yml = { glyph = yml, hl = "MiniIconsBlue" },
        tfvars = { glyph = terraform, hl = "MiniIconsPurple" },
        tf = { glyph = terraform, hl = "MiniIconsPurple" },
      },
    },
    config = function(_, opts)
      require("mini.icons").setup(opts)
      require("nvim-web-devicons")
      require("mini.icons").mock_nvim_web_devicons()
    end,
  },
}
