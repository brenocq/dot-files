return {
  {
    "nvim-neo-tree/neo-tree.nvim",
    branch = "v3.x",
    dependencies = {
      "nvim-lua/plenary.nvim",
      "nvim-tree/nvim-web-devicons",
      "MunifTanjim/nui.nvim",
      "3rd/image.nvim",
    },
    config = function()
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
    end
  },
  {
    'sainnhe/gruvbox-material',
    lazy = false,
    priority = 1000,
    config = function()
      vim.g.gruvbox_material_enable_italic = true
      vim.g.gruvbox_material_background = 'hard'
      vim.o.termguicolors = true
      vim.cmd.colorscheme('gruvbox-material')

      -- gruvbox-material gives Visual and NormalFloat the SAME bg (#3c3836),
      -- so selections are invisible inside floating windows (e.g. the
      -- ipynb.nvim output float). Lift Visual one step to bg2.
      vim.api.nvim_set_hl(0, 'Visual', { bg = '#504945' })

      -- Reapply Git diff highlights after colorscheme loads
      vim.api.nvim_create_autocmd("ColorScheme", {
        pattern = "*",
        callback = function()
          vim.cmd [[
              highlight DiffAdd    ctermbg=22 guibg=#b8bb26
              highlight DiffChange ctermbg=22 guibg=#fabd2f
              highlight DiffDelete ctermbg=124 guibg=#cc241d
              highlight DiffText   cterm=bold gui=bold
              highlight CommitHash  ctermfg=130 guifg=#d65d0e
              highlight CommitAuthor ctermfg=117 guifg=#fabd2f
              highlight CommitDate   ctermfg=109 guifg=#b8bb26
          ]]
        end
      })

    end
  },
  {
    "lewis6991/gitsigns.nvim",
    event = { "BufReadPre", "BufNewFile" }, -- Loads when a buffer is opened or created
    config = function()
      require("gitsigns").setup()
    end,
  },
  {
    "nvim-lualine/lualine.nvim",
    dependencies = { "nvim-tree/nvim-web-devicons" },
    config = function()
      -- Notebook state for the current buffer: the notebook itself, or a
      -- cell being edited, which ipynb.nvim opens in a float with its own
      -- buffer (the plugin's statusline helpers only check the former).
      -- pcall keeps the bar working if ipynb.nvim fails to load.
      local function notebook_state()
        local ok, state = pcall(require, "ipynb.state")
        if not ok then
          return nil
        end
        local buf = vim.api.nvim_get_current_buf()
        return state.get(buf) or state.get_from_edit_buf(buf)
      end
      -- Jupyter kernel status: IDLE / BUSY / DISC, colored by state.
      local kernel_status = {
        function()
          return (require("ipynb.kernel").statusline(notebook_state()))
        end,
        cond = function()
          return notebook_state() ~= nil
        end,
        color = function()
          local kernel = require("ipynb.kernel")
          local _, hl_state = kernel.statusline(notebook_state())
          return kernel.statusline_color(hl_state)
        end,
      }
      -- Notebook state if the current buffer is a cell's edit buffer.
      local function cell_state()
        local ok, state = pcall(require, "ipynb.state")
        return ok and state.get_from_edit_buf(vim.api.nvim_get_current_buf()) or nil
      end
      -- Git branch of the notebook's repo while editing a cell. The cell
      -- buffer's name is not a real path, so lualine's branch component falls
      -- back to nvim's cwd and would show that repo's branch instead.
      local function notebook_branch()
        local root = vim.fs.root(vim.api.nvim_buf_get_name(cell_state().facade_buf), ".git")
        if not root then
          return ""
        end
        local git_dir = root .. "/.git"
        if vim.fn.isdirectory(git_dir) == 0 then
          -- Worktree: .git is a file holding "gitdir: <path>"
          local ok, lines = pcall(vim.fn.readfile, git_dir, "", 1)
          git_dir = ok and (lines[1] or ""):match("^gitdir: (.+)$") or ""
          if git_dir:sub(1, 1) ~= "/" then
            git_dir = root .. "/" .. git_dir
          end
        end
        local ok, head = pcall(vim.fn.readfile, git_dir .. "/HEAD", "", 1)
        head = ok and head[1] or ""
        return head:match("^ref: refs/heads/(.+)$") or head:sub(1, 7)
      end
      require("lualine").setup({
        options = {
          theme = "gruvbox-material",
          -- One bar that follows the focused window, so it stays complete
          -- while editing a notebook cell in its float.
          globalstatus = true,
        },
        sections = {
          lualine_b = {
            { "branch", cond = function() return cell_state() == nil end },
            { notebook_branch, icon = "", cond = function() return cell_state() ~= nil end },
            "diff", "diagnostics",
          },
          lualine_x = { kernel_status, "encoding", "filetype" },
        },
      })
      vim.o.showmode = false -- lualine already shows the mode
    end,
  },
  {
    "Davidyz/VectorCode",
    version = "*",
    dependencies = { "nvim-lua/plenary.nvim" },
    cmd = "VectorCode",
  },
  {
    "OXY2DEV/markview.nvim",
    lazy = false,
    priority = 49, -- Make sure it is loaded after treesitter
    opts = {
      preview = {
        filetypes = { "markdown" },
        ignore_buftypes = {},
      },
    },
  },
  {
    "hrsh7th/nvim-cmp",
    event = "InsertEnter", -- Lazy load on Insert mode start
    dependencies = {
      "hrsh7th/cmp-buffer",         -- Buffer completions
      "hrsh7th/cmp-path",           -- Path completions
      "hrsh7th/cmp-nvim-lsp",       -- LSP completions
      "hrsh7th/cmp-nvim-lua",       -- Lua API completions for Neovim config
      "saadparwaiz1/cmp_luasnip",   -- Snippet completions
      "L3MON4D3/LuaSnip",           -- Snippet engine
      "rafamadriz/friendly-snippets" -- Collection of snippets
    },
    config = function()
      local cmp = require("cmp")
      cmp.setup({
        snippet = {
          expand = function(args)
            require("luasnip").lsp_expand(args.body) -- Use LuaSnip for snippet expansion
          end,
        },
        mapping = cmp.mapping.preset.insert({
          ["<C-d>"] = cmp.mapping.scroll_docs(-4),
          ["<C-f>"] = cmp.mapping.scroll_docs(4),
          ["<C-Space>"] = cmp.mapping.complete(),
          ["<C-e>"] = cmp.mapping.abort(),
          ["<CR>"] = cmp.mapping.confirm({ select = true }),
        }),
        sources = cmp.config.sources({
          { name = "nvim_lsp" },
          { name = "luasnip" },
        }, {
          { name = "buffer" },
          { name = "path" },
        })
      })
    end,
  },
  {
    "nvim-treesitter/nvim-treesitter",
    branch = "main", -- master is frozen and its query directives crash on nvim 0.12+
    lazy = false,    -- the main rewrite asks not to be lazy-loaded
    build = ":TSUpdate",
    config = function()
      -- Parsers to install (async; already-installed ones are skipped). The main
      -- rewrite builds them with the tree-sitter CLI — without it every install
      -- errors on each startup, so skip and say so once instead.
      if vim.fn.executable("tree-sitter") == 1 then
        require("nvim-treesitter").install({
          "bash", "c", "cpp", "cuda", "cmake", "javascript", "typescript", "tsx", "python", "lua", "html", "css", "glsl", "ini"
        })
      else
        vim.notify_once(
          "nvim-treesitter: `tree-sitter` CLI not found — parsers not installed "
            .. "(brew install tree-sitter, then :TSUpdate). Falling back to regex highlighting.",
          vim.log.levels.WARN
        )
      end
      -- The main rewrite has no highlight/indent modules: highlighting is
      -- vim.treesitter.start() per buffer (no-op fail when no parser exists,
      -- leaving regex highlighting), indent is an indentexpr.
      vim.api.nvim_create_autocmd("FileType", {
        group = vim.api.nvim_create_augroup("TreesitterStart", {}),
        callback = function(args)
          if pcall(vim.treesitter.start, args.buf) then
            vim.bo[args.buf].indentexpr = "v:lua.require'nvim-treesitter'.indentexpr()"
          end
        end,
      })
    end,
  },
  {
    'nvim-telescope/telescope.nvim',
    tag = '0.1.8',
    dependencies = { 'nvim-lua/plenary.nvim' }
  },
  {
    "folke/which-key.nvim",
    event = "VeryLazy",
    keys = {
      {
        "<leader>?",
        function()
          require("which-key").show({ global = false })
        end,
        desc = "Buffer Local Keymaps (which-key)",
      },
    },
  },
  {
    'powerman/vim-plugin-AnsiEsc',
    config = function()
      vim.cmd [[
        autocmd BufReadPost,BufNewFile *.log,*.out,*.diff,*.patch set ft=ansi
      ]]
    end
  },
  --{
  --  'https://github.com/github/copilot.vim',
  --  config = function()
  --    vim.api.nvim_set_keymap("i", "<C-l>", 'copilot#Accept("<CR>")', { expr = true, silent = true, noremap = true })
  --  end,
  --},
  {
    'neovim/nvim-lspconfig',
    config = function()
      -- 1. Verible
      -- Define the configuration
      vim.lsp.config('verible', {
        cmd = { "verible-verilog-ls", "--rules_config_search", "--indentation_spaces=4" },
        filetypes = { "verilog", "systemverilog" },
        -- root_markers helps Neovim know when to start the server (replaces root_dir)
        root_markers = { ".git", "verible.filelist" },
      })
      -- Enable it (activates filetype detection)
      vim.lsp.enable('verible')

      -- 2. Clangd (C++)
      vim.lsp.config('clangd', {
        cmd = { "clangd" },
        filetypes = { "c", "cpp", "objc", "objcpp" },
        root_markers = { ".clangd", "compile_commands.json", ".git" },
      })
      vim.lsp.enable('clangd')

      -- 3. CMake
      vim.lsp.config('neocmakelsp', {
        cmd = { "neocmakelsp", "--stdio" },
        filetypes = { "cmake" },
        root_markers = { "CMakeLists.txt", "CMakePresets.json" },
        init_options = {
          format = {
            enable = true, -- Auto-formatting
          },
          lint = {
            enable = true,
          },
        }
      })
      vim.lsp.enable('neocmakelsp')

      -- 4. Dart (Flutter)
      vim.lsp.config('dartls', {
        cmd = { "dart", "language-server" },
        filetypes = { "dart" },
        root_markers = { "pubspec.yaml" },
        init_options = {
          closingLabels = true,
          flutterOutline = true,
          onlyAnalyzeProjectsWithOpenFiles = true,
          suggestFromUnimportedLibraries = true,
        },
        settings = {
          dart = {
            completeFunctionCalls = true,
            enableSdkFormatter = true,
          }
        }
      })
      vim.lsp.enable('dartls')
    end
  },
  {
    "lervag/vimtex",
    lazy = false,
    init = function()
      vim.g.vimtex_view_method = 'zathura'
      vim.g.vimtex_compiler_latexmk = {
        build_dir = 'build',
        out_dir = 'build',
        options = {
          '-outdir=build',
          '-pdf',
          '-interaction=nonstopmode',
          '-file-line-error',
          '-synctex=1',
        }
      }
      -- VimTeX's \l... maps live under <leader>k instead (\ll -> <leader>kl,
      -- \lv -> <leader>kv, ...), the prefix notebooks use. VimTeX makes them
      -- buffer-local to .tex files, so they never meet ipynb.nvim's.
      vim.g.vimtex_mappings_prefix = '<leader>k'
      -- Name the <leader>k group in which-key's popup, in .tex buffers only.
      vim.api.nvim_create_autocmd("FileType", {
        pattern = "tex",
        group = vim.api.nvim_create_augroup("vimtex_which_key", { clear = true }),
        callback = function(ev)
          local ok, wk = pcall(require, "which-key")
          if ok then
            wk.add({ { "<leader>k", group = "latex", buffer = ev.buf } })
          end
        end,
      })
    end
  },
  {
    "ggandor/leap.nvim",
  },
  {
    "ThePrimeagen/harpoon",
    config = function()
      require("harpoon").setup({
        settings = {
          save_on_toggle = true,
          save_on_change = true,
          return_to_original_window = true
        }
      })
    end
  },
  {
    "ThePrimeagen/vim-be-good",
  },
  {
    "christoomey/vim-tmux-navigator",
    cmd = {
      "TmuxNavigateLeft",
      "TmuxNavigateDown",
      "TmuxNavigateUp",
      "TmuxNavigateRight",
      "TmuxNavigatePrevious",
      "TmuxNavigatorProcessList",
    },
    keys = {
      { "<c-h>", "<cmd><C-U>TmuxNavigateLeft<cr>" },
      { "<c-j>", "<cmd><C-U>TmuxNavigateDown<cr>" },
      { "<c-k>", "<cmd><C-U>TmuxNavigateUp<cr>" },
      { "<c-l>", "<cmd><C-U>TmuxNavigateRight<cr>" },
      { "<c-\\>", "<cmd><C-U>TmuxNavigatePrevious<cr>" },
    },
  },
  {
  'mfussenegger/nvim-dap',
    config = function()
      local dap = require('dap')
      -- Add keymaps for easy debugging
      vim.keymap.set('n', '<leader>0', dap.continue, { desc = 'Debug: Continue' })
      vim.keymap.set('n', '<leader>1', dap.step_over, { desc = 'Debug: Step Over' })
      vim.keymap.set('n', '<leader>2', dap.step_into, { desc = 'Debug: Step Into' })
      vim.keymap.set('n', '<leader>3', dap.step_out, { desc = 'Debug: Step Out' })
      vim.keymap.set('n', '<leader>9', dap.terminate, { desc = 'Debug: Terminate' })
      vim.keymap.set('n', '<leader>b', dap.toggle_breakpoint, { desc = 'Debug: Toggle Breakpoint' })
    end
   },
  {
    -- Modal Jupyter notebook editor: cell-isolated editing buffers, kernel
    -- execution (<C-CR> run cell, <S-CR> run + next, <leader>ks start kernel),
    -- ]] / [[ cell navigation. Needs python3 with jupyter_client.
    -- Personal fork of ajbucci/ipynb.nvim. `dev = true` makes lazy load it
    -- from ~/Github/ipynb.nvim when that checkout exists (see dev.path in
    -- config/lazy.lua) and fall back to cloning the fork from GitHub when it
    -- does not. Lazy never runs `build` for a local checkout on its own, so
    -- after cloning the fork by hand run `:Lazy build ipynb.nvim` once.
    "brenocq/ipynb.nvim",
    -- Loading the breno-dev worktree: main plus the branches in daily use
    -- (feat/latex-rendering, fix/which-key-buffer-local), merged. To go back
    -- to ~/Github/ipynb.nvim, restore `dev = true` and drop `name` and `dir`.
    -- A new worktree has no compiled parser; build it once with the `build`
    -- command below (or :Lazy build ipynb.nvim).
    name = "ipynb.nvim",
    dir = "~/Github/ipynb.nvim/.worktrees/breno-dev",
    -- No `ft` lazy-trigger: nvim detects .ipynb as json, and the plugin
    -- registers its own notebook handling at setup time.
    --
    -- build: compile the bundled ipynb treesitter grammar with cc instead of
    -- relying on the plugin's auto-compile through the nvim-treesitter API.
    -- Re-runs on every plugin update.
    build = "cd tree-sitter-ipynb && mkdir -p parser"
      .. " && cc -O2 -shared -fPIC -I src src/parser.c src/scanner.c -o parser/ipynb.so",
    dependencies = {
      "nvim-treesitter/nvim-treesitter",
      "neovim/nvim-lspconfig",
      "nvim-tree/nvim-web-devicons",
      "folke/snacks.nvim", -- inline image rendering (kitty graphics protocol)
    },
    opts = {
      keymaps = {
        execute_cell = "<leader><CR>",     -- simple execute (replaces <C-CR>)
        execute_all_below = "<leader>kA",  -- current cell + everything after
        add_cell_above = "<leader>kt",     -- (default ka is used for run-all below)
        add_cell_below = "<leader>kb",     -- plugin default, kept explicit
        -- make_raw stays on its default <leader>kr.
      },
    },
    config = function(_, opts)
      require("ipynb").setup(opts)

      -- Commands with no keymap slot in the plugin's config, bound per
      -- notebook buffer: run ALL cells from the top (<leader>ka is free
      -- because add_cell_above was moved to kt above) and delete the
      -- current cell (<leader>kd).
      vim.api.nvim_create_autocmd("FileType", {
        pattern = "ipynb",
        group = vim.api.nvim_create_augroup("ipynb_extra_maps", { clear = true }),
        callback = function(ev)
          vim.schedule(function()
            if vim.api.nvim_buf_is_valid(ev.buf) then
              vim.keymap.set("n", "<leader>ka", "<cmd>NotebookExecuteAll<cr>",
                { buffer = ev.buf, desc = "Notebook: run all cells from top" })
              vim.keymap.set("n", "<leader>kd", "<cmd>NotebookDeleteCell<cr>",
                { buffer = ev.buf, desc = "Notebook: delete current cell" })
            end
          end)
        end,
      })
      -- Auto-start the Jupyter kernel when a notebook opens. The plugin's
      -- kernel.auto_connect option is declared but not implemented (v. c35d3d9),
      -- so do it ourselves. Python is discovered per notebook: walks up from
      -- the notebook's dir for a .venv (e.g. analysis/.venv), else system.
      --
      -- NOTE: the plugin sets the filetype EARLY and creates its buffer-local
      -- commands asynchronously afterwards, so :NotebookKernelStart does not
      -- exist yet when FileType fires (a plain vim.schedule loses that race).
      -- Poll for the command (50 ms, up to 5 s) before invoking it.
      vim.api.nvim_create_autocmd("FileType", {
        pattern = "ipynb",
        group = vim.api.nvim_create_augroup("ipynb_kernel_autostart", { clear = true }),
        callback = function(ev)
          local tries = 0
          local function try_start()
            if not vim.api.nvim_buf_is_valid(ev.buf) then
              return
            end
            if vim.api.nvim_buf_get_commands(ev.buf, {}).NotebookKernelStart then
              vim.api.nvim_buf_call(ev.buf, function()
                pcall(vim.cmd, "NotebookKernelStart")
              end)
            elseif tries < 100 then
              tries = tries + 1
              vim.defer_fn(try_start, 50)
            end
          end
          try_start()
        end,
      })
    end,
  }
}
