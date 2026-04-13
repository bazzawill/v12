local wk = require("which-key")
wk.add({
	{
		"<leader>-",
		mode = { "n", "v" },
		"<cmd>Yazi<cr>",
		desc = "Open yazi at the current file",
		icon = " ",
	},
	{
		-- Open in the current working directory
		"<leader>cw",
		"<cmd>Yazi cwd<cr>",
		desc = "Open the file manager in nvim's working directory",
		icon = " ",
	},
	{
		"<c-up>",
		"<cmd>Yazi toggle<cr>",
		desc = "Resume the last yazi session",
		icon = " ",
	},
	{ "<leader>r", "<cmd>restart<CR>", desc = "Restart Neovim / Reload Conf", icon = "󰑓 ", mode = "n" },
	{ "<leader>p", group = "Plugins", icon = " " },
	{ "<leader>pm", "<cmd>Mason<CR>", desc = "Language and Formatters", mode = "n" },
	{ "<leader>f", group = "find", icon = " " }, -- group
	{
		"<leader>ff",
		"<cmd>FzfLua files<CR>",
		desc = "Find File",
		mode = "n",
		icon = "󰈔 ",
	},
	{
		"<leader>fk",
		"<cmd>FzfLua keymap<CR>",
		desc = "Find Keybinding",
		mode = "n",
        icon = "󰋖 ",
	},
	{
		"<leader>f?",
		"<cmd>FzfLua<CR>",
		desc = "Find Menu",
		mode = "n",
	},
	{
		mode = "n",
		"<leader>fg",
		"<cmd>FzfLua grep_project<CR>",
		desc = "Find word in project",
        icon = "󰈞 ",
	},
	{
		mode = "n",
		"<leader>fl",
		"<cmd>FzfLua grep_last<CR>",
		desc = "Grep Last",
	},
	{
		mode = "n",
		"<leader>fh",
		"<cmd>FzfLua help_tags<CR>",
		desc = "Search Help",
        icon = "󰋖 ",
	},
	{ "<leader>n", "<cmd>enew<CR>", desc = "New File" },
	{ "<leader>t", group = "tabs" },
	{ mode = "n", "<Leader>te", "<cmd>tabnew<CR>", desc = "new tab" },
	{ mode = "n", "<Leader>tn", "<cmd>tabn<CR>", desc = "next tab" },
	{ mode = "n", "<Leader>tp", "<cmd>tabp<CR>", desc = "previous tab" },
	{ "<leader>w", proxy = "<c-w>", group = "windows" }, -- proxy to window mappings
	{
		"<leader>b",
		group = "buffers",
		expand = function()
			return require("which-key.extras").expand.buf()
		end,
	},
	{
		"<leader>e",
		function()
			require("yazi").yazi()
		end,
		desc = "File Explorer",
	},
	icon = " ",
	{
		-- Nested mappings are allowed and can be added in any order
		-- Most attributes can be inherited or overridden on any level
		-- There's no limit to the depth of nesting
		mode = { "n", "v" }, -- NORMAL and VISUAL mode
		{ "<leader>q", "<cmd>confirm q<cr>", desc = "Quit" }, -- no need to specify mode since it's inherited
		{ "<leader>w", "<cmd>w<cr>", desc = "Write" },
	},
})
local keymap = vim.keymap.set
local s = { silent = true }

keymap("n", "<space>", "<Nop>")

-- movement
keymap("n", "j", "v:count == 0 ? 'gj' : 'j'", { expr = true, silent = true })
keymap("n", "k", "v:count == 0 ? 'gk' : 'k'", { expr = true, silent = true })
keymap("n", "<C-d>", "<C-d>zz")
keymap("n", "<C-u>", "<C-u>zz")

--- split windows
keymap("n", "<Leader>_", "<cmd>vsplit<CR>", { silent = true, desc = "vertical split" })
keymap("n", "<Leader>-", "<cmd>split<CR>", { silent = true, desc = "horizontal split" })

-- copy and paste
keymap("v", "<Leader>p", '"_dP')
keymap("x", "y", [["+y]], s)

-- terminal
keymap("t", "<Esc>", "<C-\\><C-N>")

-- cd current dir
keymap("n", "<leader>cd", '<cmd>lua vim.fn.chdir(vim.fn.expand("%:p:h"))<CR>', { desc = "cd to current directory" })

local ns = { noremap = true, silent = true }
local er = { expr = true, replace_keycodes = false }
keymap("n", "grd", "<cmd>lua vim.lsp.buf.definition()<CR>", ns)
keymap("n", "<leader>dn", "<cmd>lua vim.diagnostic.jump({count = 1})<CR>", ns)
keymap("n", "<leader>dp", "<cmd>lua vim.diagnostic.jump({count = -1})<CR>", ns)

keymap("n", "<leader>ps", "<cmd>lua vim.pack.update()<CR>", { desc = "Update Plugins" })
keymap("n", "<leader>gs", "<cmd>Git<CR>", ns)
keymap("n", "<leader>gp", "<cmd>Git push<CR>", ns)
keymap("n", "<leader>co", "<cmd>CommandExecute<CR>")
keymap("n", "<leader>cr", "<cmd>CommandExecuteLast<CR>")
keymap("n", "<leader>ma", require("miniharp").toggle_file, { desc = "MiniHarp toggle file" })
keymap("n", "<leader>mc", require("miniharp").clear)
keymap("n", "<leader>l", require("miniharp").show_list)
keymap("n", "<C-n>", require("miniharp").next)
keymap("n", "<C-p>", require("miniharp").prev)
-- keymap({ "n", "x" }, "<leader>gy", require("gh-permalink").yank)
keymap("n", "<leader>so", function()
	require("fzf-lua").files({
		actions = {
			["default"] = function(selected)
				local file = selected[1]
				local rel_path = vim.fn.fnamemodify(file, ":.")

				rel_path = rel_path:gsub(" ", "\\ ")
				if not rel_path:match("^%.?/") then
					rel_path = "./" .. rel_path
				end

				vim.api.nvim_put({ rel_path }, "l", true, false)
			end,
		},
	})
end)
