return {
  {
    "neovim/nvim-lspconfig",
    opts = {
      servers = {
        basedpyright = { mason = false },
        pyright = { enabled = false, mason = false },
      },
    },
  },
}
