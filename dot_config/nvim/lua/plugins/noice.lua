return {
  "folke/noice.nvim",
  opts = function(_, opts)
    opts.routes = opts.routes or {}
    -- W325 still (datei in zweiter instanz offen)
    table.insert(opts.routes, {
      filter = { event = "msg_show", find = "W325" },
      opts = { skip = true },
    })
  end,
}
