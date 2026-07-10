-- ============================================================================
-- DISABLED PLUGINS - Replaced by Snacks.nvim
-- ============================================================================
-- These LazyVim defaults are now handled by snacks.nvim

return {
  -- Telescope → Snacks.picker
  { "nvim-telescope/telescope.nvim", enabled = false },
  { "nvim-telescope/telescope-fzf-native.nvim", enabled = false },

  -- Neo-tree → Snacks.explorer
  { "nvim-neo-tree/neo-tree.nvim", enabled = false },

  -- Dashboard → Snacks.dashboard
  { "nvimdev/dashboard-nvim", enabled = false },
  { "goolord/alpha-nvim", enabled = false },

  -- Indent guides → Snacks.indent
  { "lukas-reineke/indent-blankline.nvim", enabled = false },

  -- Word highlight → Snacks.words
  { "RRethy/vim-illuminate", enabled = false },

  -- Notifications → Snacks.notifier
  { "rcarriga/nvim-notify", enabled = false },
}
