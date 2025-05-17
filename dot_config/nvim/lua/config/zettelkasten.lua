local function create_and_open_zk_note()
  -- Get the current line
  local line = vim.api.nvim_get_current_line()

  -- Extract the title from between double square brackets
  local title = line:match("%[%[(.-)%]%]")

  if title then
    -- Construct and execute the zk command
    local cmd = string.format('zk new --vim "%s"', title)
    local output = vim.fn.system(cmd)

    -- Extract the file path from the output and clean it
    local file_path = output:match("New note created: (.+)")
    if file_path then
      -- Remove null bytes, newlines, and trim whitespace
      file_path = file_path:gsub("%z", ""):gsub("\n", ""):gsub("^%s*(.-)%s*$", "%1")

      -- Open the file in a new buffer without changing the current window layout
      vim.cmd("badd " .. vim.fn.fnameescape(file_path))
      local bufnr = vim.fn.bufnr(file_path)

      -- Switch to the new buffer in the current window
      vim.api.nvim_set_current_buf(bufnr)

      print("Created and opened new note: " .. title)
      print("File path: " .. file_path) -- Debug print
    else
      print("Failed to create note: " .. title)
      print("Command output: " .. output)
    end
  else
    print("No title found between double square brackets")
  end
end

-- Create a Vim command to call this function
vim.api.nvim_create_user_command("CreateAndOpenZkNote", create_and_open_zk_note, {})

-- Optional: Add a key mapping
vim.keymap.set("n", "<leader>zn", ":CreateAndOpenZkNote<CR>", { desc = "Create and open zk note" })

local function yank_and_search_markdown_link()
  vim.cmd("normal! yi]")
  local yanked_text = vim.fn.getreg('"')

  -- Remove the brackets if they were captured
  yanked_text = yanked_text:gsub("%[%[(.-)%]%]", "%1")

  if yanked_text ~= "" then
    -- Escape special characters for find_files
    yanked_text = vim.fn.escape(yanked_text, "\\.")

    require("telescope.builtin").find_files({
      search_file = yanked_text,
      hidden = true,
      no_ignore = true,
      follow = true,
    })
  else
    print("No text found inside brackets")
  end
end

vim.api.nvim_create_user_command("YankAndSearchMarkdownLink", yank_and_search_markdown_link, {})

vim.keymap.set(
  "n",
  "<leader>zo",
  ":YankAndSearchMarkdownLink<CR>",
  { desc = "Zet Open - Yank and search markdown link" }
)
