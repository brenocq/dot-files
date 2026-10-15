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
vim.keymap.set('v', '<leader>e', '<cmd>CodeCompanion /explain<CR>', { noremap = true, silent = true })
vim.keymap.set('n', '<leader>C', '<cmd>CodeCompanion /commit<CR>', { noremap = true, silent = true })


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
vim.keymap.set('n', ';', ':', { noremap = true, silent = false })

--- Window movement key bindings are managed by vim-tmux-navigator
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

-- Markdown: preview rendered as on GitHub (needs `gh extension install yusukebe/gh-markdown-preview`),
-- on the key VimTeX opens a PDF with (<leader>kl), buffer-local as VimTeX's. One server per file,
-- reloading the page on save; pressing again reopens it. The servers stop with nvim.
local markdown_previews = {} -- file -> { job, url }
vim.api.nvim_create_autocmd("FileType", {
  pattern = "markdown",
  group = vim.api.nvim_create_augroup("markdown_preview", { clear = true }),
  callback = function(ev)
    vim.keymap.set("n", "<leader>kl", function()
      local file = vim.fn.expand("%:p")
      local running = markdown_previews[file]
      if running then
        vim.ui.open(running.url)
        vim.notify("GitHub preview: " .. running.url)
        return
      end
      local port = 3333 + vim.tbl_count(markdown_previews)
      local url = "http://localhost:" .. port
      local errors = {}
      local opened = false
      local job = vim.fn.jobstart({ "gh", "markdown-preview", "--disable-auto-open", "-p", tostring(port), file }, {
        on_stderr = function(_, lines)
          for _, line in ipairs(lines) do
            if line:find("Watching") and not opened then
              -- The server is up once it watches the folder: open the page.
              opened = true
              vim.defer_fn(function() vim.ui.open(url) end, 300)
            elseif line ~= "" then
              table.insert(errors, line)
            end
          end
        end,
        on_exit = function(_, code)
          markdown_previews[file] = nil
          if code ~= 0 and code ~= 143 then
            vim.notify("GitHub preview failed: " .. table.concat(errors, "\n"), vim.log.levels.ERROR)
          end
        end,
      })
      if job <= 0 then
        vim.notify("GitHub preview: could not run gh", vim.log.levels.ERROR)
        return
      end
      markdown_previews[file] = { job = job, url = url }
      vim.notify("GitHub preview: starting " .. url)
    end, { buffer = ev.buf, desc = "GitHub preview" })
  end,
})
vim.api.nvim_create_autocmd("VimLeavePre", {
  group = "markdown_preview",
  callback = function()
    for _, preview in pairs(markdown_previews) do
      -- gh runs the extension as a child, which outlives gh unless stopped too.
      vim.fn.system({ "pkill", "-P", tostring(vim.fn.jobpid(preview.job)) })
      vim.fn.jobstop(preview.job)
    end
  end,
})

-- Auto reload
vim.o.autoread = true
vim.api.nvim_create_autocmd(
  -- A list of events that trigger the check
  { "FocusGained", "BufEnter", "CursorHold", "CursorHoldI" },
  {
    command = "if mode() != 'c' | checktime | endif",
    pattern = "*",
  }
)
