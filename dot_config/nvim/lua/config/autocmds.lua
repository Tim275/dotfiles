-- Autocmds are automatically loaded on the VeryLazy event
-- Default autocmds that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/autocmds.lua
-- Add any additional autocmds here
--
-- disable completion on markdown files by default
-- vim.api.nvim_create_autocmd("FileType", {
--   pattern = { "gitcommit", "markdown" },
--   callback = function()
--     require("cmp").setup({ enabled = false })
--   end,
-- })

-- Set textwidth to 80 and automatic line breaks for markdown files
-- vim.api.nvim_create_autocmd("FileType", {
--   pattern = { "gitcommit", "markdown", "pandoc" },
--   callback = function()
--     require("cmp").setup({ enabled = false })
--     -- vim.opt_local.textwidth = 80
--     -- vim.opt_local.formatoptions:append("a")
--     -- vim.opt_local.colorcolumn = "80"
--   end,
-- })

-- attemting to disable terraform ls on fixture file
-- vim.api.nvim_create_autocmd("BufEnter", {
--   pattern = "*fixture*",
--   callback = function()
--     vim.diagnostic.disable(0)
--
--     this one also didnt work:     vim.lsp.stop_client(vim.lsp.get_active_clients())
--   end,
-- })

-- wrap and check for spell in text filetypes
-- added to disable spelling
-- vim.api.nvim_create_autocmd("FileType", {
--   -- group = augroup("wrap_spell"),
--   pattern = { "gitcommit", "markdown", "pandoc" },
--   callback = function()
--     vim.opt_local.wrap = true
--     -- vim.opt_local.spell = false
--   end,
-- })

-- Disable spelling

-- vim.api.nvim_create_autocmd("filetype", {
--   -- group = augroup("wrap_spell"),
--   pattern = { "gitcommit", "markdown", "pandoc" },
--   command = "set nospell",
-- })

-- vim.api.nvim_create_autocmd("filetype", {
--   -- group = augroup("wrap_spell"),
--   pattern = { "pandoc" },
--   command = "PandocFolding none",
-- })

-- Go related

-- Disable auto formatting and markdown rendering on the Index
-- Also conceals brackets on the Index for cleaner consistent formatting

vim.api.nvim_create_autocmd("BufEnter", {
	pattern = "00.00 Index.md",
	callback = function()
		if vim.bo.filetype == "markdown" then
			vim.cmd("RenderMarkdown disable")
			vim.cmd("LspStop")
			vim.b.autoformat = false

			vim.o.conceallevel = 2
			vim.o.concealcursor = "nvic"

			-- Conceal the opening [[ and closing ]] brackets, but show the text inside
			vim.fn.matchadd("Conceal", "\\[\\[", 10, -1, { conceal = "" })
			vim.fn.matchadd("Conceal", "\\]\\]", 10, -1, { conceal = "" })

			-- Optionally, define a syntax for the content inside [[ ]] to ensure it’s not concealed
			vim.cmd([[syntax region WikiLink start=/\[\[/ end=/\]\]/ concealends]])
		end
	end,
})

-- Ignore Non existent & Ambigious link warnings in Marksman

vim.api.nvim_create_autocmd("LspAttach", {
	pattern = "00.00 Index.md",
	callback = function(args)
		local client = vim.lsp.get_client_by_id(args.data.client_id)
		if client.name == "marksman" then
			-- Override the diagnostic handler to filter out unwanted messages
			client.handlers["textDocument/publishDiagnostics"] = function(_, result, ctx, config)
				-- Filter diagnostics
				local filtered_diagnostics = {}
				for _, diagnostic in ipairs(result.diagnostics) do
					local message = diagnostic.message
					if
						not (
							message:match("Link to non%-existent document")
							or message:match("Ambiguous link to document")
						)
					then
						table.insert(filtered_diagnostics, diagnostic)
					end
				end
				result.diagnostics = filtered_diagnostics
				-- Call the default handler with filtered diagnostics
				vim.lsp.diagnostic.on_publish_diagnostics(_, result, ctx, config)
			end
		end
	end,
})
