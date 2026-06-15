---@type vim.lsp.Config
return {
    cmd = { "ansible-language-server", "--stdio" },
    filetypes = { "yaml.ansible" },
    root_markers = { ".git", "ansible.cfg", "requirements.yml" },
    settings = {
        ansible = {
            python = {
                interpreterPath = "python3",
            },
        },
    },
}
