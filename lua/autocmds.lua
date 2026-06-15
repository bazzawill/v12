local autocmd = vim.api.nvim_create_autocmd
local augroup = vim.api.nvim_create_augroup
local map = vim.keymap.set
local bs = { buffer = true, silent = true }
local brs = { buffer = true, remap = true, silent = true }

-- Detect zsh filetypes
autocmd({ "BufRead", "BufNewFile" }, {
    pattern = { "*.zsh", "*.zshrc", "*.zshenv", "*.zprofile", "*.zlogin", "*.zlogout" },
    callback = function()
        vim.bo.filetype = "zsh"
    end,
})
autocmd("BufRead", {
    pattern = "*",
    callback = function()
        local first_line = vim.fn.getline(1)
        if first_line:match("^#!.*/zsh") or first_line:match("^#!.*env zsh") then
            vim.bo.filetype = "zsh"
        end
    end,
})

-- Highlight yanked text
local highlight_group = augroup("YankHighlight", { clear = true })
autocmd("TextYankPost", {
    pattern = "*",
    callback = function()
        vim.highlight.on_yank({ timeout = 170 })
    end,
    group = highlight_group,
})

vim.api.nvim_create_autocmd("FileType", {
    pattern = "netrw",
    callback = function()
        map("n", "<C-c>", "<cmd>bd<CR>", bs)
        map("n", "<Tab>", "mf", brs)
        map("n", "<S-Tab>", "mF", brs)
        map("n", "%", function()
            local dir = vim.b.netrw_curdir or vim.fn.expand("%:p:h")
            vim.ui.input({ prompt = "Enter filename: " }, function(input)
                if input and input ~= "" then
                    local filepath = dir .. "/" .. input
                    vim.cmd("!touch " .. vim.fn.shellescape(filepath))
                    vim.api.nvim_feedkeys("<C-l>", "n", false)
                end
            end)
        end, bs)
    end,
})

vim.api.nvim_create_autocmd("FileType", {
    pattern = "*",
    callback = function(ev)
        local ft = vim.bo[ev.buf].filetype
        local formatting = "lua vim.lsp.buf.format()"

        if ft == "lua" then
            formatting = "!stylua %"
        elseif ft == "tex" then
            formatting = "!latexindent -s -l -w %"
        elseif ft == "python" then
            formatting = "!black %"
        end

        local cmd = function()
            vim.cmd("write")
            vim.cmd("silent " .. formatting)
        end

        map("n", "<leader>fo", cmd, { buffer = ev.buf })
    end,
})
