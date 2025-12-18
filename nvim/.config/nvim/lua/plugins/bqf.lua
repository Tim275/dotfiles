-- ============================================================================
-- NVIM-BQF - Better Quickfix List (2025)
-- https://github.com/kevinhwang91/nvim-bqf
-- ============================================================================

return {
  {
    "kevinhwang91/nvim-bqf",
    ft = "qf",
    opts = {
      auto_enable = true,
      auto_resize_height = true,
      preview = {
        win_height = 12,
        win_vheight = 12,
        delay_syntax = 80,
        border = "rounded",
        show_title = true,
        should_preview_cb = function(bufnr)
          local ret = true
          local bufname = vim.api.nvim_buf_get_name(bufnr)
          local fsize = vim.fn.getfsize(bufname)
          if fsize > 100 * 1024 then
            -- Skip files larger than 100KB
            ret = false
          end
          return ret
        end,
      },
      func_map = {
        open = "<CR>",
        openc = "o",
        drop = "O",
        tabdrop = "",
        tab = "t",
        tabb = "T",
        tabc = "<C-t>",
        split = "<C-s>",
        vsplit = "<C-v>",
        prevfile = "<C-p>",
        nextfile = "<C-n>",
        prevhist = "<",
        nexthist = ">",
        lastleave = "'\"",
        stoggleup = "<S-Tab>",
        stoggledown = "<Tab>",
        stogglevm = "<Tab>",
        stogglebuf = "'<Tab>",
        sclear = "z<Tab>",
        pscrollup = "<C-b>",
        pscrolldown = "<C-f>",
        pscrollorig = "zo",
        ptogglemode = "zp",
        ptoggleitem = "p",
        ptoggleauto = "P",
        filter = "zn",
        filterr = "zN",
        fzffilter = "zf",
      },
      filter = {
        fzf = {
          action_for = { ["ctrl-s"] = "split", ["ctrl-v"] = "vsplit", ["ctrl-t"] = "tab drop" },
          extra_opts = { "--bind", "ctrl-o:toggle-all", "--prompt", "> " },
        },
      },
    },
  },
}
