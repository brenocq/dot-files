require("config.lazy")

vim.api.nvim_create_autocmd({ "BufReadPost", "BufNewFile" }, {
  pattern = "*.log,*.out,*.diff,*.patch",
  command = "set ft=ansi",
})

-- Set the leader key to space
vim.g.mapleader = ' '

--- Filesystem tree config
vim.api.nvim_create_autocmd("VimEnter", {
  callback = function()
    if vim.fn.argc() == 0 and not filetype == "ansi" then
      -- No files passed and not ansi file (git related file), open Neo-tree
      vim.cmd("Neotree")
    end
  end
})
vim.keymap.set('n', '<leader>n', ':Neotree toggle<CR>', { noremap = true, silent = true })

--- Navigation
-- Leap
vim.keymap.set({'n', 'x', 'o'}, '<leader>s', '<Plug>(leap)')
vim.keymap.set({'n', 'x', 'o'}, '<leader>w', '<Plug>(leap-from-window)')
-- Harpoon
vim.keymap.set("n", "<leader>a", require("harpoon.mark").add_file)
vim.keymap.set("n", "<leader>q", require("harpoon.ui").toggle_quick_menu)
for i = 0, 4 do
  vim.keymap.set("n", "<leader>" .. i, function() require("harpoon.ui").nav_file(i+1) end)
end

--- LLM config
vim.keymap.set('n', '<leader>l', '<cmd>CodeCompanionChat Toggle<CR>', { noremap = true, silent = true })

--- LSP config
vim.api.nvim_create_autocmd('LspAttach', {
  callback = function(args)
    local bufnr = args.buf
    local opts = { buffer = bufnr, noremap = true, silent = true }
    vim.keymap.set('n', '<leader>d', vim.lsp.buf.declaration, opts)
    vim.keymap.set('n', '<leader>i', vim.lsp.buf.definition, opts)
    vim.keymap.set('n', '<leader>r', vim.lsp.buf.references, opts)
  end,
})
vim.keymap.set('n', '<leader>c', '<cmd>lua vim.lsp.buf.format({ async = true })<CR>', { noremap = true, silent = true })

-- Code style
vim.o.number = true
vim.o.relativenumber = true
vim.o.expandtab = true
vim.o.shiftwidth = 4
vim.o.tabstop = 4
vim.o.softtabstop = 4
vim.o.encoding = 'UTF-8'
vim.o.spell = true
vim.o.spelllang = 'en_us'

-- Highlight trailing spaces
vim.cmd [[highlight TrailingSpaces ctermbg=red guibg=red]]
vim.cmd [[match TrailingSpaces /\s\+$/]]

-- Highlight Atta files
vim.api.nvim_create_autocmd({ "BufRead", "BufNewFile" }, {
  pattern = "*.asl",
  command = "set filetype=glsl",
})

vim.api.nvim_create_autocmd({ "BufRead", "BufNewFile" }, {
  pattern = "*.atta",
  command = "set filetype=ini",
})

-- Remap ; to :
vim.keymap.set('n', ';', ':', { noremap = true, silent = false })

-- Window movement keybindings
vim.keymap.set('n', '<C-j>', '<C-w>j', { noremap = true, silent = true })
vim.keymap.set('n', '<C-k>', '<C-w>k', { noremap = true, silent = true })
vim.keymap.set('n', '<C-h>', '<C-w>h', { noremap = true, silent = true })
vim.keymap.set('n', '<C-l>', '<C-w>l', { noremap = true, silent = true })
vim.keymap.set('n', '<leader>t', ':tabnew<CR>', { noremap = true, silent = true })

-- Scrolling
vim.keymap.set('n', '<S-k>', '<C-u>', { noremap = true, silent = true })
vim.keymap.set('n', '<S-j>', '<C-d>', { noremap = true, silent = true })
vim.keymap.set('v', '<S-k>', '<C-u>', { noremap = true, silent = true })
vim.keymap.set('v', '<S-j>', '<C-d>', { noremap = true, silent = true })

-- Search
local builtin = require('telescope.builtin') -- Ensure this is required

vim.keymap.set('n', '<leader>g', ':Telescope live_grep<CR>', { noremap = true, silent = true })
vim.keymap.set('n', '<leader>f', function()
    builtin.find_files({
        hidden = true,
        no_ignore = true
    })
end, { desc = "Find all files, including ignored ones" })

-- Toggle search highlight
vim.o.hlsearch = true
vim.keymap.set('n', '<leader>h', ':set hlsearch!<CR>', { noremap = true, silent = true })

-- Copy/paste
vim.keymap.set('v', '<leader>c', '"+y', { noremap = true, silent = true })
vim.keymap.set('n', '<leader>v', '"+p', { noremap = true, silent = true })

-- Git
-- vim.keymap.set('n', '<leader>d', ':vertical Gitsigns diffthis<CR>', { noremap = true, silent = true })
