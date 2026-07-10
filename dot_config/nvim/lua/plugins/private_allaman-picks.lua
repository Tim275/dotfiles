-- ============================================================================
-- ALLAMAN-INSPIRED PLUGINS
-- Curated picks from https://github.com/Allaman/nvim
-- ============================================================================

return {
  -- ==========================================================================
  -- 1. KUSTOMIZE.NVIM - Kubernetes Kustomize Helper
  -- ==========================================================================
  -- Deprecation checks with kubent, Trivy security scans
  {
    "allaman/kustomize.nvim",
    ft = "yaml",
    dependencies = { "nvim-lua/plenary.nvim" },
    opts = {
      enable_lua_snip = false,
    },
    keys = {
      { "<leader>Kb", "<cmd>KustomizeBuild<cr>", desc = "Kustomize Build" },
      { "<leader>Kk", "<cmd>KustomizeListKinds<cr>", desc = "List Kinds" },
      { "<leader>Kl", "<cmd>KustomizeListResources<cr>", desc = "List Resources" },
      { "<leader>Kp", "<cmd>KustomizePrintResources<cr>", desc = "Print Resources" },
      { "<leader>Kv", "<cmd>KustomizeValidate<cr>", desc = "Validate (kubent)" },
      { "<leader>Kd", "<cmd>KustomizeDeprecations<cr>", desc = "Deprecations" },
    },
  },

  -- ==========================================================================
  -- 2. OUTLINE.NVIM - Code Structure Sidebar
  -- ==========================================================================
  -- Shows all functions/classes in a sidebar
  {
    "hedyhli/outline.nvim",
    cmd = "Outline",
    keys = {
      { "<leader>o", "<cmd>Outline<cr>", desc = "Toggle Outline" },
    },
    opts = {
      outline_window = {
        position = "right",
        width = 30,
      },
      symbols = {
        icon_source = "lspkind",
      },
    },
  },

  -- ==========================================================================
  -- 3. DROPBAR.NVIM - Breadcrumb Navigation
  -- ==========================================================================
  -- Shows path: file.go > func main > if statement
  {
    "Bekaboo/dropbar.nvim",
    event = "VeryLazy",
    opts = {
      bar = {
        sources = function(buf, _)
          local sources = require("dropbar.sources")
          local utils = require("dropbar.utils")
          if vim.bo[buf].ft == "markdown" then
            return { sources.markdown }
          end
          if vim.bo[buf].buftype == "terminal" then
            return { sources.terminal }
          end
          return {
            sources.path,
            utils.source.fallback({
              sources.lsp,
              sources.treesitter,
            }),
          }
        end,
      },
    },
  },

  -- ==========================================================================
  -- 4. DEVOPS-TOOLS.NVIM - Docker/Helm/Terraform/Kubectl Integration
  -- ==========================================================================
  -- Run DevOps commands directly from Neovim
  {
    "azratul/devops-tools.nvim",
    cmd = {
      "DockerPs", "DockerImages", "DockerRun",
      "HelmInstall", "HelmTemplate", "HelmUpgrade",
      "TerraformInit", "TerraformPlan", "TerraformApply",
      "KubectlGet", "KubectlDescribe", "KubectlLogs",
    },
    dependencies = { "nvim-lua/plenary.nvim" },
    keys = {
      { "<leader>Dp", "<cmd>DockerPs<cr>", desc = "Docker: List Containers" },
      { "<leader>Di", "<cmd>DockerImages<cr>", desc = "Docker: List Images" },
      { "<leader>Ti", "<cmd>TerraformInit<cr>", desc = "Terraform: Init" },
      { "<leader>Tp", "<cmd>TerraformPlan<cr>", desc = "Terraform: Plan" },
      { "<leader>Ta", "<cmd>TerraformApply<cr>", desc = "Terraform: Apply" },
      { "<leader>Kg", "<cmd>KubectlGet pods<cr>", desc = "Kubectl: Get Pods" },
      { "<leader>Ko", "<cmd>KubectlLogs<cr>", desc = "Kubectl: Logs" },
    },
    config = true,
  },

  -- ==========================================================================
  -- 5. YAZI.NVIM - Fast File Manager
  -- ==========================================================================
  -- Requires: brew install yazi
  {
    "mikavilpas/yazi.nvim",
    cmd = "Yazi",
    keys = {
      { "<leader>fy", "<cmd>Yazi<cr>", desc = "Yazi (current file)" },
      { "<leader>fY", "<cmd>Yazi cwd<cr>", desc = "Yazi (cwd)" },
    },
    opts = {
      open_for_directories = false,
    },
  },

  -- ==========================================================================
  -- 6. NVIM-COLORIZER - See Colors Inline
  -- ==========================================================================
  -- Shows #ff5733 as actual color
  {
    "NvChad/nvim-colorizer.lua",
    event = "VeryLazy",
    opts = {
      filetypes = { "*" },
      user_default_options = {
        names = false,
        RGB = true,
        RRGGBB = true,
        RRGGBBAA = true,
        css = true,
        css_fn = true,
        mode = "background",
        tailwind = true,
        virtualtext = "■",
      },
    },
  },

  -- ==========================================================================
  -- 7. MINI.ALIGN - Align Text
  -- ==========================================================================
  -- Align YAML, Terraform variables nicely
  -- Usage: ga in visual mode, then enter delimiter (e.g., "=")
  {
    "nvim-mini/mini.align",
    event = "VeryLazy",
    opts = {
      mappings = {
        start = "ga",
        start_with_preview = "gA",
      },
    },
  },

  -- ==========================================================================
  -- 8. SUBSTITUTE.NVIM - Quick Text Substitution
  -- ==========================================================================
  {
    "gbprod/substitute.nvim",
    event = "VeryLazy",
    config = function()
      require("substitute").setup({
        on_substitute = nil,
        yank_substituted_text = false,
        preserve_cursor_position = false,
        modifiers = nil,
        highlight_substituted_text = {
          enabled = true,
          timer = 200,
        },
        range = {
          prefix = "s",
          prompt_current_text = false,
          confirm = false,
          complete_word = false,
          subject = nil,
          range = nil,
          suffix = "",
          auto_apply = false,
          cursor_position = "end",
        },
        exchange = {
          motion = false,
          use_esc_to_cancel = true,
          preserve_cursor_position = false,
        },
      })
    end,
    keys = {
      { "sx", function() require("substitute").operator() end, desc = "Substitute" },
      { "sxx", function() require("substitute").line() end, desc = "Substitute line" },
      { "sX", function() require("substitute").eol() end, desc = "Substitute to EOL" },
      { "sx", function() require("substitute").visual() end, mode = "x", desc = "Substitute" },
    },
  },

  -- ==========================================================================
  -- 9. TINY-INLINE-DIAGNOSTIC.NVIM - Better Inline Diagnostics
  -- ==========================================================================
  {
    "rachartier/tiny-inline-diagnostic.nvim",
    event = "VeryLazy",
    priority = 1000,
    config = function()
      -- Disable default virtual text since this plugin replaces it
      vim.diagnostic.config({ virtual_text = false })
      require("tiny-inline-diagnostic").setup({
        preset = "modern",
        options = {
          show_source = true,
          multilines = true,
        },
      })
    end,
  },

  -- ==========================================================================
  -- 10. DIFFVIEW.NVIM - Git Diff Viewer (Trending 2025)
  -- ==========================================================================
  -- Beautiful side-by-side git diffs
  {
    "sindrets/diffview.nvim",
    cmd = { "DiffviewOpen", "DiffviewFileHistory" },
    keys = {
      { "<leader>gd", "<cmd>DiffviewOpen<cr>", desc = "Git Diff View" },
      { "<leader>gh", "<cmd>DiffviewFileHistory %<cr>", desc = "File History" },
      { "<leader>gH", "<cmd>DiffviewFileHistory<cr>", desc = "Repo History" },
    },
    opts = {
      enhanced_diff_hl = true,
      view = {
        default = { layout = "diff2_horizontal" },
        merge_tool = { layout = "diff3_horizontal" },
      },
    },
  },

  -- ==========================================================================
  -- 11. OIL.NVIM - Edit Filesystem Like a Buffer (Trending 2025)
  -- ==========================================================================
  -- Navigate files like editing text - very fast
  {
    "stevearc/oil.nvim",
    cmd = "Oil",
    keys = {
      { "-", "<cmd>Oil<cr>", desc = "Open Oil (parent dir)" },
    },
    opts = {
      default_file_explorer = false, -- Keep neo-tree as default
      columns = { "icon" },
      view_options = {
        show_hidden = true,
      },
      keymaps = {
        ["<C-h>"] = false, -- Don't conflict with tmux
        ["<C-l>"] = false,
      },
    },
    dependencies = { "nvim-tree/nvim-web-devicons" },
  },

}
