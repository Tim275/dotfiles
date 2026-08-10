local glyph = vim.fn.nr2char

-- Codepoints statt Literale: PUA-Zeichen ueberleben Copy-Paste/Editoren nicht zuverlaessig
local cube = glyph(0xF01A6) -- nf-md-cube
local yml = glyph(0xE6A8) -- nf-seti-yml
local terraform = glyph(0xE69A) -- nf-seti-terraform

return {
  {
    -- mini.icons ist die einzige Quelle. mock_nvim_web_devicons() leitet devicons
    -- transparent um (snacks.explorer haengt hart an nvim-web-devicons) - vorher
    -- hatten devicons und mini.icons fuer die meisten Endungen verschiedene Icons.
    "nvim-mini/mini.icons",
    init = function()
      -- .tofu (OpenTofu) = gleiche Pipeline wie .tf: highlighting, terraformls, terraform_fmt
      vim.filetype.add({ extension = { tofu = "terraform" } })
    end,
    opts = {
      extension = {
        tofu = { glyph = cube, hl = "MiniIconsYellow" },
        -- blau statt rot: 8 rote yaml-icons in einer liste lesen sich als 8 fehler
        yaml = { glyph = yml, hl = "MiniIconsBlue" },
        yml = { glyph = yml, hl = "MiniIconsBlue" },
        -- devicons hat fuer tfvars nur "fa-file" (generischer Klecks) hinterlegt
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
