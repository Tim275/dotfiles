-- ============================================================================
-- SNACKS.NVIM - Full Power Config (Inspired by pedrorcruzz)
-- https://github.com/folke/snacks.nvim
-- ============================================================================

return {
  "folke/snacks.nvim",
  priority = 1000,
  lazy = false,
  ---@type snacks.Config
  opts = {
    bigfile = { enabled = true },
    dashboard = {
      enabled = true,
      preset = {
        keys = {
          { icon = "󰈞 ", key = "f", desc = "Find File", action = ":lua Snacks.dashboard.pick('files')" },
          { icon = "󰊄 ", key = "g", desc = "Live Grep", action = ":lua Snacks.dashboard.pick('live_grep')" },
          { icon = "󰋚 ", key = "r", desc = "Recent Files", action = ":lua Snacks.dashboard.pick('oldfiles')" },
          { icon = "󰈔 ", key = "n", desc = "New file", action = ":ene | startinsert" },
          { icon = "󰉋 ", key = "w", desc = "Yazi", action = ":Yazi cwd" },
          { icon = "󰢻 ", key = "c", desc = "Config", action = ":lua Snacks.dashboard.pick('files', {cwd = vim.fn.stdpath('config')})" },
          { icon = "󰦛 ", key = "s", desc = "Restore Session", section = "session" },
          { icon = "󰒲 ", key = "l", desc = "Lazy", action = ":Lazy", enabled = package.loaded.lazy ~= nil },
          { icon = "󰏘 ", key = "x", desc = "Colorscheme", action = ":lua Snacks.picker.colorschemes()" },
          {
            icon = "󰊢 ",
            key = "b",
            desc = "Browse Repo",
            action = function()
              Snacks.gitbrowse()
            end,
          },
          { icon = "󰗼 ", key = "q", desc = "Quit", action = ":qa" },
        },
        header = [[
  ██╗      █████╗ ███████╗██╗   ██╗██╗   ██╗██╗███╗   ███╗
  ██║     ██╔══██╗╚══███╔╝╚██╗ ██╔╝██║   ██║██║████╗ ████║
  ██║     ███████║  ███╔╝  ╚████╔╝ ██║   ██║██║██╔████╔██║
  ██║     ██╔══██║ ███╔╝    ╚██╔╝  ╚██╗ ██╔╝██║██║╚██╔╝██║
  ███████╗██║  ██║███████╗   ██║    ╚████╔╝ ██║██║ ╚═╝ ██║
  ╚══════╝╚═╝  ╚═╝╚══════╝   ╚═╝     ╚═══╝  ╚═╝╚═╝     ╚═╝
        ]],
      },
      sections = {
        -- ══════════════════════════════════════════════════════════════════
        -- WIDE VERSION (120+ columns) - Layout wie pedrorcruzz
        -- ══════════════════════════════════════════════════════════════════
        {
          enabled = function()
            return vim.o.columns >= 100
          end,
          -- LazyVim Header with zzz + Startup centered at very top
          {
            pane = 2,
            { text = { { [[  ██╗      █████╗ ███████╗██╗   ██╗██╗   ██╗██╗███╗   ███╗       ]], hl = "SnacksDashboardHeader" }, { [[Z]], hl = "SnacksDashboardZzz" } }, align = "center" },
            { text = { { [[  ██║     ██╔══██╗╚══███╔╝╚██╗ ██╔╝██║   ██║██║████╗ ████║     ]], hl = "SnacksDashboardHeader" }, { [[Z ]], hl = "SnacksDashboardZzz" } }, align = "center" },
            { text = { { [[  ██║     ███████║  ███╔╝  ╚████╔╝ ██║   ██║██║██╔████╔██║   ]], hl = "SnacksDashboardHeader" }, { [[z   ]], hl = "SnacksDashboardZzz" } }, align = "center" },
            { text = { { [[  ██║     ██╔══██║ ███╔╝    ╚██╔╝  ╚██╗ ██╔╝██║██║╚██╔╝██║ ]], hl = "SnacksDashboardHeader" }, { [[ᶻ     ]], hl = "SnacksDashboardZzz" } }, align = "center" },
            { text = { [[  ███████╗██║  ██║███████╗   ██║    ╚████╔╝ ██║██║ ╚═╝ ██║       ]], hl = "SnacksDashboardHeader" }, align = "center" },
            { text = { [[  ╚══════╝╚═╝  ╚═╝╚══════╝   ╚═╝     ╚═══╝  ╚═╝╚═╝     ╚═╝       ]], hl = "SnacksDashboardHeader" }, align = "center" },
            { section = "startup", padding = 1 },
          },
          -- PANE 1 (LEFT): Relaxo GIF + Git Graph
          {
            pane = 1,
            -- Sleeping Relaxo 😴
            {
              section = "terminal",
              cmd = "chafa -c full --fg-only --symbols braille --clear --center on --speed 1 -s 55x28 --animate on $HOME/.config/nvim/data/ascii/relaxo6.gif",
              height = 28,
              width = 55,
              padding = 1,
              align = "center",
            },
            -- Git Graph
            { icon = "󰊢 ", title = "Git Graph" },
            {
              section = "terminal",
              cmd = "git -c color.decorate.HEAD='bold 223' -c color.decorate.branch='115' -c color.decorate.remoteBranch='66' -c color.graph='66' log --graph --decorate --color=always --format='%C(73)%h%C(reset)%C(auto)%d%C(reset) %C(255)%s%C(reset)' -3 2>/dev/null || echo '  Not a git repo'",
              height = 4,
              ttl = 5 * 60,
            },
          },
          -- PANE 2 (RIGHT): Startup + Menu + Recent Files + Projects
          {
            pane = 2,
            -- Menu items
            { icon = "󰈞 ", key = "f", desc = "Find File", action = ":lua Snacks.dashboard.pick('files')" },
            { icon = "󰊄 ", key = "g", desc = "Live Grep", action = ":lua Snacks.dashboard.pick('live_grep')" },
            { icon = "󰋚 ", key = "r", desc = "Recent Files", action = ":lua Snacks.dashboard.pick('oldfiles')" },
            { icon = "󰈔 ", key = "n", desc = "New file", action = ":ene | startinsert" },
            { icon = "󰉋 ", key = "w", desc = "Yazi", action = ":Yazi cwd" },
            { icon = "󰢻 ", key = "c", desc = "Config", action = ":lua Snacks.dashboard.pick('files', {cwd = vim.fn.stdpath('config')})" },
            { icon = "󰦛 ", key = "s", desc = "Restore Session", section = "session" },
            { icon = "󰒲 ", key = "l", desc = "Lazy", action = ":Lazy", enabled = package.loaded.lazy ~= nil },
            { icon = "󰏘 ", key = "x", desc = "Colorscheme", action = ":lua Snacks.picker.colorschemes()" },
            {
              icon = "󰊢 ",
              key = "b",
              desc = "Browse Repo",
              action = function()
                Snacks.gitbrowse()
              end,
            },
            { icon = "󰗼 ", key = "q", desc = "Quit", action = ":qa" },
            { padding = 1 },
            -- Recent Files
            {
              icon = "󰋚 ",
              title = "Recent Files",
              section = "recent_files",
              indent = 2,
              padding = 1,
              limit = 8,
              width = 60,
            },
            -- Projects
            {
              icon = "󰏓 ",
              title = "Projects",
              section = "projects",
              limit = 5,
              indent = 2,
              padding = 1,
              width = 60,
            },
          },
        },

        -- ══════════════════════════════════════════════════════════════════
        -- SLIM VERSION (less than 180 columns)
        -- ══════════════════════════════════════════════════════════════════
        {
          enabled = function()
            return vim.o.columns < 100
          end,
          { section = "header" },
          { section = "startup", padding = 1 },
          { icon = "󰈞 ", key = "f", desc = "Find File", action = ":lua Snacks.dashboard.pick('files')" },
          { icon = "󰊄 ", key = "g", desc = "Live Grep", action = ":lua Snacks.dashboard.pick('live_grep')" },
          { icon = "󰋚 ", key = "r", desc = "Recent Files", action = ":lua Snacks.dashboard.pick('oldfiles')" },
          { icon = "󰈔 ", key = "n", desc = "New file", action = ":ene | startinsert" },
          { icon = "󰉋 ", key = "w", desc = "Yazi", action = ":Yazi cwd" },
          { icon = "󰢻 ", key = "c", desc = "Config", action = ":lua Snacks.dashboard.pick('files', {cwd = vim.fn.stdpath('config')})" },
          { icon = "󰦛 ", key = "s", desc = "Restore Session", section = "session" },
          { icon = "󰒲 ", key = "l", desc = "Lazy", action = ":Lazy", enabled = package.loaded.lazy ~= nil },
          { icon = "󰏘 ", key = "x", desc = "Colorscheme", action = ":lua Snacks.picker.colorschemes()" },
          {
            icon = "󰊢 ",
            key = "b",
            desc = "Browse Repo",
            action = function()
              Snacks.gitbrowse()
            end,
          },
          { icon = "󰗼 ", key = "q", desc = "Quit", action = ":qa" },
          { padding = 1 },
          {
            icon = "󰋚 ",
            title = "Recent Files",
            section = "recent_files",
            padding = 1,
            limit = 5,
          },
          {
            icon = "󰏓 ",
            title = "Projects",
            section = "projects",
            padding = 1,
            limit = 3,
          },
          -- Git Graph (slim)
          { icon = "󰊢 ", title = "Git Graph" },
          {
            section = "terminal",
            cmd = "git -c color.decorate.HEAD='bold 223' -c color.decorate.branch='115' -c color.decorate.remoteBranch='66' -c color.graph='66' log --graph --decorate --color=always --format='%C(73)%h%C(reset)%C(auto)%d%C(reset) %C(255)%s%C(reset)' -6 2>/dev/null || echo 'Not a git repo'",
            height = 8,
            ttl = 5 * 60,
          },
        },
      },
    },

    -- ══════════════════════════════════════════════════════════════════════
    -- EXPLORER
    -- ══════════════════════════════════════════════════════════════════════
    explorer = {
      enabled = true,
      replace_netrw = true,
    },

    -- ══════════════════════════════════════════════════════════════════════
    -- INDENT
    -- ══════════════════════════════════════════════════════════════════════
    indent = {
      enabled = true,
      char = "│",
      only_scope = false,
      only_current = false,
      animate = {
        enabled = false,
      },
    },

    -- ══════════════════════════════════════════════════════════════════════
    -- INPUT
    -- ══════════════════════════════════════════════════════════════════════
    input = {
      enabled = true,
      win = {
        row = 0.35,
        col = 0.35,
        border = "rounded",
        width = 65,
        height = 2,
      },
    },

    -- ══════════════════════════════════════════════════════════════════════
    -- PICKER (Replaces Telescope)
    -- ══════════════════════════════════════════════════════════════════════
    picker = {
      enabled = true,
      hidden = false,
      ignored = true,
      layout = { preset = "default", preview = true, border = "rounded" },
      sources = {
        files = { hidden = true, ignored = false },
        explorer = {
          finder = "explorer",
          diagnostics = true,
          layout = { layout = { position = "left", width = 35 }, preview = false },
          auto_close = false,
          git_untracked = true,
        },
      },
      win = {
        input = {
          keys = {
            ["<C-h>"] = { "toggle_hidden", mode = { "i", "n" } },
            ["<C-l>"] = { "toggle_ignored", mode = { "i", "n" } },
          },
        },
        list = {
          keys = {
            ["<C-h>"] = { "toggle_hidden", mode = { "i", "n" } },
            ["<C-l>"] = { "toggle_ignored", mode = { "i", "n" } },
          },
        },
      },
      icons = {
        files = {
          enabled = true,
          dir = " ",
          dir_open = " ",
          file = " ",
        },
        diagnostics = {
          Error = " ",
          Warn = " ",
          Hint = " ",
          Info = " ",
        },
        lsp = {
          unavailable = "",
          enabled = " ",
          disabled = " ",
          attached = "󰖩 ",
        },
        kinds = {
          Array = " ",
          Boolean = "󰨙 ",
          Class = " ",
          Constant = "󰏿 ",
          Constructor = " ",
          Enum = " ",
          Field = " ",
          File = " ",
          Folder = " ",
          Function = "󰊕 ",
          Interface = " ",
          Key = " ",
          Method = "󰊕 ",
          Module = " ",
          Namespace = "󰦮 ",
          Number = "󰎠 ",
          Object = " ",
          Property = " ",
          String = " ",
          Struct = "󰆼 ",
          Variable = "󰀫 ",
        },
      },
    },

    -- ══════════════════════════════════════════════════════════════════════
    -- CORE FEATURES
    -- ══════════════════════════════════════════════════════════════════════
    quickfile = { enabled = true },
    scope = { enabled = true },
    statuscolumn = { enabled = true },
    profiler = { enabled = true },
    animate = { enabled = true },
    words = { enabled = true },
    scroll = {
      enabled = true,
      animate = { duration = { step = 12, total = 100 } },
    },
    rename = { enabled = true },
    toggle = { enabled = true },
    lazygit = { enabled = true },
    terminal = { enabled = true },
    zen = { enabled = true },
    dim = { enabled = true },
    git = {
      enabled = true,
      width = 0.6,
      height = 0.6,
      border = "rounded",
      title = " Git Blame ",
      title_pos = "center",
    },
    gitbrowse = { enabled = true },
    notifier = {
      enabled = true,
      timeout = 3000,
      width = { min = 40, max = 0.4 },
      height = { min = 1, max = 0.6 },
      style = "compact",
      top_down = true,
    },
  },

  -- ════════════════════════════════════════════════════════════════════════
  -- KEYBINDINGS
  -- ════════════════════════════════════════════════════════════════════════
  keys = {
    -- Dashboard
    { "<leader>d", function() Snacks.dashboard() end, desc = "Dashboard" },

    -- Explorer
    { "<leader>e", function() Snacks.explorer() end, desc = "File Explorer" },

    -- Smart Finder
    { "<leader>fs", function() Snacks.picker.smart() end, desc = "Smart Find Files" },
    { "<leader><cr>", function() Snacks.picker.smart() end, desc = "Smart Find Files" },
    { "<leader><space>", function() Snacks.picker.files() end, desc = "Find Files" },

    -- File Pickers
    { "<leader>ff", function() Snacks.picker.files() end, desc = "Find Files" },
    { "<leader>fb", function() Snacks.picker.buffers() end, desc = "Buffers" },
    { "<leader>fc", function() Snacks.picker.files({ cwd = vim.fn.stdpath("config") }) end, desc = "Find Config" },
    { "<leader>fg", function() Snacks.picker.git_files() end, desc = "Git Files" },
    { "<leader>fr", function() Snacks.picker.recent() end, desc = "Recent Files" },

    -- TODO Comments
    { "<leader>ftt", function() Snacks.picker.todo_comments() end, desc = "All TODOs" },
    { "<leader>ftf", function() Snacks.picker.todo_comments({ keywords = { "FIX", "FIXME" } }) end, desc = "Find Fix/Fixme" },
    { "<leader>fte", function() Snacks.picker.todo_comments({ keywords = { "TODO" } }) end, desc = "Find Todo" },
    { "<leader>ftn", function() Snacks.picker.todo_comments({ keywords = { "NOTE" } }) end, desc = "Find Note" },
    { "<leader>fth", function() Snacks.picker.todo_comments({ keywords = { "HACK" } }) end, desc = "Find Hack" },
    { "<leader>ftw", function() Snacks.picker.todo_comments({ keywords = { "WARN" } }) end, desc = "Find Warn" },

    -- Git
    { "<leader>gb", function() Snacks.picker.git_branches() end, desc = "Git Branches" },
    { "<leader>gl", function() Snacks.git.blame_line() end, desc = "Git Blame Line" },
    { "<leader>gc", function() Snacks.lazygit.log() end, desc = "Git Log" },
    { "<leader>gL", function() Snacks.picker.git_log_line() end, desc = "Git Log Line" },
    { "<leader>gs", function() Snacks.picker.git_status() end, desc = "Git Status" },
    { "<leader>gS", function() Snacks.picker.git_stash() end, desc = "Git Stash" },
    { "<leader>gd", function() Snacks.picker.git_diff() end, desc = "Git Diff" },
    { "<leader>gf", function() Snacks.picker.git_log_file() end, desc = "Git Log File" },
    { "<leader>gg", function() Snacks.lazygit.open() end, desc = "Lazygit" },
    { "<leader>gB", function() Snacks.gitbrowse() end, desc = "Git Browse" },

    -- Grep
    { "<leader>sb", function() Snacks.picker.grep_buffers() end, desc = "Grep Buffers" },
    { "<leader>sg", function() Snacks.picker.grep() end, desc = "Grep" },
    { "<leader>/", function() Snacks.picker.lines() end, desc = "Buffer Lines" },
    { "<leader>sw", function() Snacks.picker.grep_word() end, desc = "Grep Word", mode = { "n", "x" } },

    -- Search
    { "<leader>s/", function() Snacks.picker.search_history() end, desc = "Search History" },
    { "<leader>sa", function() Snacks.picker.autocmds() end, desc = "Autocmds" },
    { "<leader>sc", function() Snacks.picker.command_history() end, desc = "Command History" },
    { "<leader>sC", function() Snacks.picker.commands() end, desc = "Commands" },
    { "<leader>sd", function() Snacks.picker.diagnostics() end, desc = "Diagnostics" },
    { "<leader>sD", function() Snacks.picker.diagnostics_buffer() end, desc = "Buffer Diagnostics" },
    { "<leader>sH", function() Snacks.picker.help() end, desc = "Help Pages" },
    { "<leader>sh", function() Snacks.picker.highlights() end, desc = "Highlights" },
    { "<leader>si", function() Snacks.picker.icons() end, desc = "Icons" },
    { "<leader>sj", function() Snacks.picker.jumps() end, desc = "Jumps" },
    { "<leader>sk", function() Snacks.picker.keymaps() end, desc = "Keymaps" },
    { "<leader>sl", function() Snacks.picker.loclist() end, desc = "Location List" },
    { "<leader>sm", function() Snacks.picker.marks() end, desc = "Marks" },
    { "<leader>sM", function() Snacks.picker.man() end, desc = "Man Pages" },
    { "<leader>sp", function() Snacks.picker.lazy() end, desc = "Plugin Specs" },
    { "<leader>sR", function() Snacks.picker.qflist() end, desc = "Quickfix List" },
    { "<leader>sq", function() Snacks.picker.registers() end, desc = "Registers" },
    { "<leader>su", function() Snacks.picker.undo() end, desc = "Undo History" },
    { "<leader>sx", function() Snacks.picker.colorschemes() end, desc = "Colorschemes" },
    { "<leader>:", function() Snacks.picker.command_history() end, desc = "Command History" },
    { "<leader>N", function() Snacks.picker.notifications() end, desc = "Notifications" },

    -- LSP
    { "gd", function() Snacks.picker.lsp_definitions() end, desc = "Goto Definition" },
    { "gD", function() Snacks.picker.lsp_declarations() end, desc = "Goto Declaration" },
    { "gr", function() Snacks.picker.lsp_references() end, nowait = true, desc = "References" },
    { "gI", function() Snacks.picker.lsp_implementations() end, desc = "Goto Implementation" },
    { "gy", function() Snacks.picker.lsp_type_definitions() end, desc = "Goto Type Definition" },
    { "<leader>ss", function() Snacks.picker.lsp_symbols() end, desc = "LSP Symbols" },
    { "<leader>sS", function() Snacks.picker.lsp_workspace_symbols() end, desc = "Workspace Symbols" },

    -- Notifications
    { "<leader>.", function() Snacks.notifier.hide() end, desc = "Dismiss Notification" },
    { "<leader>un", function() Snacks.notifier.hide() end, desc = "Dismiss Notifications" },
    { "<leader>uN", function() Snacks.notifier.show_history() end, desc = "Notification History" },

    -- Utils
    { "<leader>cR", function() Snacks.rename.rename_file() end, desc = "Rename File" },
    { "<leader>bd", function() Snacks.bufdelete() end, desc = "Delete Buffer" },
    { "<leader>bD", function() Snacks.bufdelete.all() end, desc = "Delete All Buffers" },
    { "<leader>t", function() Snacks.terminal() end, desc = "Terminal" },
    { "<leader>z", function() Snacks.zen() end, desc = "Toggle Zen Mode" },
  },

  -- ════════════════════════════════════════════════════════════════════════
  -- INIT
  -- ════════════════════════════════════════════════════════════════════════
  init = function()
    vim.api.nvim_create_autocmd("User", {
      pattern = "VeryLazy",
      callback = function()
        -- Debug helpers
        _G.dd = function(...) Snacks.debug.inspect(...) end
        _G.bt = function() Snacks.debug.backtrace() end
        vim.print = _G.dd

        -- Toggles
        Snacks.toggle.option("wrap", { name = "Wrap" }):map("<leader>lw")
        Snacks.toggle.option("relativenumber", { name = "Relative Number" }):map("<leader>lg")
        Snacks.toggle.line_number():map("<leader>ln")
        Snacks.toggle.zen():map("<leader>lz")
        Snacks.toggle.indent():map("<leader>li")
        Snacks.toggle.dim():map("<leader>lk")
        Snacks.toggle.diagnostics():map("<leader>ud")
        Snacks.toggle.inlay_hints():map("<leader>uh")
      end,
    })
  end,

  -- ════════════════════════════════════════════════════════════════════════
  -- CONFIG (Soft Aesthetic Dashboard Colors)
  -- ════════════════════════════════════════════════════════════════════════
  config = function(_, opts)
    require("snacks").setup(opts)

    -- Relaxo/Snorlax Dashboard Colors (Sleepy & Cozy)
    vim.api.nvim_set_hl(0, "SnacksDashboardKey", { fg = "#3B8686" })                   -- Teal (Relaxo body - keys)
    vim.api.nvim_set_hl(0, "SnacksDashboardDesc", { fg = "#E8D8B8" })                  -- Cream (Relaxo belly - menu text)
    vim.api.nvim_set_hl(0, "SnacksDashboardIcon", { fg = "#5BA3A3" })                  -- Light Teal (icons)
    vim.api.nvim_set_hl(0, "SnacksDashboardTitle", { fg = "#F5E6C8" })                 -- Warm Cream (Git Graph, Recent Files, Projects)
    vim.api.nvim_set_hl(0, "SnacksDashboardHeader", { fg = "#3B8686" })                -- Teal (header)
    vim.api.nvim_set_hl(0, "SnacksDashboardFooter", { fg = "#5BA3A3" })                -- Light Teal
    vim.api.nvim_set_hl(0, "SnacksDashboardSpecial", { fg = "#E8D8B8" })               -- Cream
    vim.api.nvim_set_hl(0, "SnacksDashboardDir", { fg = "#2C4A52" })                   -- Dark Blue (paths)
    vim.api.nvim_set_hl(0, "SnacksDashboardFile", { fg = "#87CEAB" })                  -- Soft Mint Green (files)
    vim.api.nvim_set_hl(0, "SnacksDashboardZzz", { fg = "#E8D8B8" })                   -- Cream (Relaxo zzz)
  end,
}
