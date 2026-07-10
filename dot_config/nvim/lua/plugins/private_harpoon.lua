-- Harpoon - Quick file switching (by ThePrimeagen)
-- Mark files and jump between them instantly
return {
  "ThePrimeagen/harpoon",
  branch = "harpoon2",
  dependencies = { "nvim-lua/plenary.nvim" },
  keys = {
    { "<leader>a", function() require("harpoon"):list():add() end, desc = "Harpoon: Add file" },
    { "<C-e>", function() require("harpoon").ui:toggle_quick_menu(require("harpoon"):list()) end, desc = "Harpoon: Menu" },
    { "<C-1>", function() require("harpoon"):list():select(1) end, desc = "Harpoon: File 1" },
    { "<C-2>", function() require("harpoon"):list():select(2) end, desc = "Harpoon: File 2" },
    { "<C-3>", function() require("harpoon"):list():select(3) end, desc = "Harpoon: File 3" },
    { "<C-4>", function() require("harpoon"):list():select(4) end, desc = "Harpoon: File 4" },
    { "<leader>hp", function() require("harpoon"):list():prev() end, desc = "Harpoon: Previous" },
    { "<leader>hn", function() require("harpoon"):list():next() end, desc = "Harpoon: Next" },
  },
  config = function()
    require("harpoon"):setup()
  end,
}
