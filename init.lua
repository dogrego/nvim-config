vim.o.expandtab = true
vim.o.shiftwidth = 4
vim.o.tabstop = 4
vim.o.number = true
vim.o.relativenumber = true
vim.o.splitright = true
vim.o.splitbottom = true

vim.api.nvim_set_keymap("n", "<C-h>", "<C-w>h", {noremap = true, silent = true})
vim.api.nvim_set_keymap("n", "<C-j>", "<C-w>j", {noremap = true, silent = true})
vim.api.nvim_set_keymap("n", "<C-k>", "<C-w>k", {noremap = true, silent = true})
vim.api.nvim_set_keymap("n", "<C-l>", "<C-w>l", {noremap = true, silent = true})

local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
  vim.fn.system({
    "git",
    "clone",
    "--filter=blob:none",
    "https://github.com/folke/lazy.nvim.git",
    "--branch=stable", -- latest stable release
    lazypath,
  })
end
vim.opt.rtp:prepend(lazypath)

require("lazy").setup({
    {"rebelot/kanagawa.nvim"},
    { "tpope/vim-fugitive",   lazy = false },
    { "tpope/vim-surround",   lazy = false },
    {"neovim/nvim-lspconfig", lazy = false},
    {"nvim-lualine/lualine.nvim", lazy = false},
    {"nvim-lua/plenary.nvim"},
    {"nvim-telescope/telescope.nvim", cmd = "Telescope", dependencies = {"nvim-lua/plenary.nvim"}},
    {"nvim-tree/nvim-web-devicons"},
    {"nvim-telescope/telescope-file-browser.nvim", depedencies = {"nvim-tree/nvim-web-devicons"}}
  },
  {}
)

vim.cmd("colorscheme kanagawa")

local lspconfig = require("lspconfig")
lspconfig.clangd.setup {
        capabilities = { offsetEncoding = "utf-8" },
        cmd = { "/bin/bash", "-c", "BUILD_CONFIGS='Linux_x86_64.debug' /app/epg/tools/bin/wsclangd" },
        singleFileSupport = true
}

vim.keymap.set("n", "<space>e", vim.diagnostic.open_float, {noremap = true, silent = true})
vim.keymap.set("n", "[d", vim.diagnostic.goto_prev, {noremap = true, silent = true})
vim.keymap.set("n", "]d", vim.diagnostic.goto_next, {noremap = true, silent = true})

vim.api.nvim_create_autocmd('LspAttach', {
  group = vim.api.nvim_create_augroup('UserLspConfig', {}),
  callback = function(ev)
    -- Enable completion triggered by <c-x><c-o>
    vim.bo[ev.buf].omnifunc = 'v:lua.vim.lsp.omnifunc'

    -- Buffer local mappings.
    -- See `:help vim.lsp.*` for documentation on any of the below functions
    local opts = { buffer = ev.buf }
    vim.keymap.set('n', 'gD', vim.lsp.buf.declaration, opts)
    vim.keymap.set('n', 'gd', ':Telescope lsp_definitions<cr>', opts)
    vim.keymap.set('n', 'K', vim.lsp.buf.hover, opts)
    vim.keymap.set('n', 'gi', ':Telescope lsp_implementations<cr>', opts)
    vim.keymap.set('n', '<C-k>', vim.lsp.buf.signature_help, opts)
    --vim.keymap.set('n', '<space>wa', vim.lsp.buf.add_workspace_folder, opts)
    --vim.keymap.set('n', '<space>wr', vim.lsp.buf.remove_workspace_folder, opts)
    --vim.keymap.set('n', '<space>wl', function()
    --  print(vim.inspect(vim.lsp.buf.list_workspace_folders()))
    --end, opts)
    vim.keymap.set('n', '<space>D', vim.lsp.buf.type_definition, opts)
    vim.keymap.set('n', '<space>rn', vim.lsp.buf.rename, opts)
    vim.keymap.set({ 'n', 'v' }, '<space>ca', vim.lsp.buf.code_action, opts)
    vim.keymap.set('n', 'gr', ':Telescope lsp_references<cr>', opts)
    vim.keymap.set('n', 'go', ':Telescope lsp_outgoing_calls<cr>', opts)
    vim.keymap.set('n', 'gn', ':Telescope lsp_incoming_calls<cr>', opts)
    --vim.keymap.set('n', '<space>F', function()
    --  vim.lsp.buf.format { async = false }
    --end, opts)
    vim.cmd('command! FormatBuffer lua vim.lsp.buf.format { async = false }')
  end,
})

require('lualine').setup {
  options = {
    icons_enabled = true,
    theme = 'auto',
    component_separators = { left = '', right = ''},
    section_separators = { left = '', right = ''},
    disabled_filetypes = {
      statusline = {},
      winbar = {},
    },
    ignore_focus = {},
    always_divide_middle = true,
    globalstatus = true,
    refresh = {
      statusline = 1000,
      tabline = 1000,
      winbar = 1000,
    }
  },
  sections = {
    lualine_a = {'mode'},
    lualine_b = {'branch', 'diff', 'diagnostics'},
    lualine_c = {'filename'},
    lualine_x = {'encoding', 'fileformat', 'filetype'},
    lualine_y = {'progress'},
    lualine_z = {'location'}
  },
  inactive_sections = {
    lualine_a = {},
    lualine_b = {},
    lualine_c = {'filename'},
    lualine_x = {'location'},
    lualine_y = {},
    lualine_z = {}
  },
  tabline = {},
  winbar = {},
  inactive_winbar = {},
  extensions = {}
}

require("telescope").setup {
    defaults = {
        layout_config = {
            width = 0.99,
            height = 0.99
        }
    }
}

vim.keymap.set('n', '<space>ff', ':Telescope find_files<cr>')
vim.keymap.set('n', '<space>fg', ':Telescope git_files<cr>')
vim.keymap.set('n', '<space>fr', ':Telescope live_grep<cr>')
vim.keymap.set('n', '<space>fb', ':Telescope buffers<cr>')
vim.keymap.set('n', '<space>bf', ':Telescope file_browser<cr>')

local _border = "single"

vim.lsp.handlers["textDocument/hover"] = vim.lsp.with(
  vim.lsp.handlers.hover, {
    border = _border
  }
)

vim.lsp.handlers["textDocument/signatureHelp"] = vim.lsp.with(
  vim.lsp.handlers.signature_help, {
    border = _border
  }
)

vim.diagnostic.config{
  float={border=_border}
}
