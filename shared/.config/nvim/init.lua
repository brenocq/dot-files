require("config.lazy")

-- Neo-tree
require("neo-tree").setup({
    close_if_last_window = true,
    popup_border_style = "rounded",
    enable_git_status = true,
    enable_diagnostics = true,
    sort_case_insensitive = false,
    filesystem = {
	    use_libuv_file_watcher = true,
        filtered_items = {
            visible = true,
            hide_dotfiles = false,
            hide_gitignored = false,
        },
    },
})

vim.api.nvim_create_autocmd({ "BufReadPost", "BufNewFile" }, {
  pattern = "*.log,*.out,*.diff,*.patch",
  command = "set ft=ansi",
})

vim.api.nvim_create_autocmd("VimEnter", {
  callback = function()
    if vim.fn.argc() == 0 and not filetype == "ansi" then
      -- No files passed and not ansi file (git related file), open Neo-tree
      vim.cmd("Neotree")
    end
  end
})

vim.api.nvim_set_keymap('n', '<C-n>', ':Neotree toggle<CR>', { noremap = true, silent = true })

-- Set the leader key to space
vim.g.mapleader = ' '

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
vim.api.nvim_set_keymap('n', '<leader>c', '<cmd>lua vim.lsp.buf.format({ async = true })<CR>', { noremap = true, silent = true })

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
vim.api.nvim_set_keymap('n', ';', ':', { noremap = true, silent = false })

-- Window movement keybindings
vim.api.nvim_set_keymap('n', '<C-j>', '<C-w>j', { noremap = true, silent = true })
vim.api.nvim_set_keymap('n', '<C-k>', '<C-w>k', { noremap = true, silent = true })
vim.api.nvim_set_keymap('n', '<C-h>', '<C-w>h', { noremap = true, silent = true })
vim.api.nvim_set_keymap('n', '<C-l>', '<C-w>l', { noremap = true, silent = true })
vim.api.nvim_set_keymap('n', '<leader>t', ':tabnew<CR>', { noremap = true, silent = true })

-- Remember last cursor position
vim.api.nvim_exec([[
  augroup RememberCursor
    autocmd!
    autocmd BufReadPost * if line("'\"") > 0 && line("'\"") <= line("$") | exe "normal! g`\"" | endif
  augroup END
]], false)

-- Scrolling
vim.api.nvim_set_keymap('n', '<S-k>', '<C-u>', { noremap = true, silent = true })
vim.api.nvim_set_keymap('n', '<S-j>', '<C-d>', { noremap = true, silent = true })
vim.api.nvim_set_keymap('v', '<S-k>', '<C-u>', { noremap = true, silent = true })
vim.api.nvim_set_keymap('v', '<S-j>', '<C-d>', { noremap = true, silent = true })

-- Search
vim.api.nvim_set_keymap('n', '<leader>s', ':Telescope live_grep<CR>', { noremap = true, silent = true })
vim.api.nvim_set_keymap('n', '<leader>f', ':Telescope find_files<CR>', { noremap = true, silent = true })

-- Toggle search highlight
vim.o.hlsearch = true
vim.api.nvim_set_keymap('n', '<leader>h', ':set hlsearch!<CR>', { noremap = true, silent = true })

-- Copy/paste
vim.api.nvim_set_keymap('v', '<leader>c', '"+y', { noremap = true, silent = true })
vim.api.nvim_set_keymap('n', '<leader>v', '"+p', { noremap = true, silent = true })

-- Code Generation: Guide navigation
vim.api.nvim_set_keymap('n', ',m', '<Esc>/<++><CR>cf>', { noremap = true, silent = true })
vim.api.nvim_set_keymap('i', ',m', '<Esc>/<++><CR>cf>', { noremap = true, silent = true })
vim.api.nvim_set_keymap('v', ',m', '<Esc>/<++><CR>cf>', { noremap = true, silent = true })

-- Code Generation for C++ using autocommands
vim.api.nvim_exec([[
  autocmd FileType cpp,c inoremap ,fun (<++>)<CR>{<CR><++><CR><Backspace><Backspace>}<CR><CR><++><Esc>?(<++>)<CR>i
  autocmd FileType cpp,c inoremap ,if if(<++>)<CR>{<CR><++><CR><Backspace><Backspace>}<CR><CR><++><Esc>?<++>)<CR>cf>
  autocmd FileType cpp,c inoremap ,while while(<++>)<CR>{<CR><++><CR><Backspace><Backspace>}<CR><CR><++><Esc>?<++>)<CR>cf>
  autocmd FileType cpp,c inoremap ,for for(<++>; <++>; <++>)<CR>{<CR><++><CR><Backspace><Backspace>}<CR><CR><++><Esc>?(<++><CR>lcf>
]], false)

-- Git
vim.api.nvim_set_keymap('n', '<leader>d', ':vertical Gitsigns diffthis<CR>', { noremap = true, silent = true })

-- ChatGPT
vim.api.nvim_set_keymap('v', '<leader>gc', ':ChatGPTRun bcq_complete<CR>', { noremap = true, silent = true })
vim.api.nvim_set_keymap('v', '<leader>ge', ':ChatGPTRun bcq_explain<CR>', { noremap = true, silent = true })
vim.api.nvim_set_keymap('v', '<leader>gd', ':ChatGPTRun bcq_doxygen<CR>', { noremap = true, silent = true })
vim.api.nvim_set_keymap('v', '<leader>gi', ':ChatGPTEditWithInstructions<CR>', { noremap = true, silent = true })
