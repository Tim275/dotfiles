return {
  { "someone-stole-my-name/yaml-companion.nvim" },
  {
    "neovim/nvim-lspconfig",
    opts = {
      setup = {
        yamlls = function(_, yamlls_opts)
          -- yamlls_opts ist bereits LazyVims fertige config (SchemaStore-before_init,
          -- capabilities) - die geht 1:1 durch, yaml-companion haengt nur builtin_matchers
          -- (kind: <core-resource> -> k8s-schema) zusaetzlich dran, ersetzt nichts.
          local cfg = require("yaml-companion").setup({ lspconfig = yamlls_opts })
          require("lspconfig").yamlls.setup(cfg)
          return true
        end,
      },
    },
  },
}
