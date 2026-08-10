return {
  {
    "nvim-treesitter/nvim-treesitter",
    opts = {
      -- image.nvim/render-markdown warnen sonst bei jedem checkhealth
      ensure_installed = { "css", "scss", "latex", "typst", "svelte", "vue" },
    },
  },
  {
    "mfussenegger/nvim-lint",
    opts = function(_, opts)
      -- kein fish installiert
      opts.linters_by_ft.fish = nil
    end,
  },
}
