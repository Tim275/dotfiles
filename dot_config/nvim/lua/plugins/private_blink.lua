-- Disable blink.cmp (needs rust to build, causes errors)
-- Use nvim-cmp instead (LazyVim default fallback)
return {
  { "saghen/blink.cmp", enabled = false },
}
