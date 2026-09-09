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
    "Davidyz/VectorCode",
    version = "*",
    dependencies = { "nvim-lua/plenary.nvim" },
    cmd = "VectorCode",
  },
  --{
  --  "olimorris/codecompanion.nvim",
  --  dependencies = {
  --    { "nvim-lua/plenary.nvim", branch = "master" },
  --    { "nvim-treesitter/nvim-treesitter" },
  --    { "ravitemer/mcphub.nvim" },
  --    -- { "ravitemer/codecompanion-history.nvim" }
  --  },
  --  opts = {
  --    display = {
  --      chat = {
  --        window = {
  --          width = 0.35,
  --        }
  --      },
  --    },
  --    strategies = {
  --      chat = {
  --        adapter = "claude_code",
  --        roles = {
  --          llm =  function(adapter)
  --            return string.format(
  --              '✨ %s%s',
  --              adapter.formatted_name,
  --              adapter.parameters.model and ' (' .. adapter.parameters.model .. ')' or ''
  --            )
  --          end,
  --          user = "🌳🐵 brenocq",
  --        }
  --      },
  --      inline = {
  --        adapter = "gemini",
  --        keymaps = {
  --          accept_change = {
  --            modes = { n = "<leader>a" },
  --            description = "Accept the suggested change",
  --          },
  --          reject_change = {
  --            modes = { n = "<leader>r" },
  --            description = "Reject the suggested change",
  --          },
  --        },
  --      },
  --      cmd = {
  --          adapter = "gemini",
  --      },
  --    },
  --    adapters = {
  --      http = {
  --        gemini = function()
  --          return require("codecompanion.adapters").extend("gemini", {
  --            schema = {
  --              model = {
  --                default = "gemini-2.5-pro",
  --              },
  --            },
  --          })
  --        end,
  --        openai = function()
  --          return require("codecompanion.adapters").extend("openai", {
  --            schema = {
  --              model = {
  --                default = "gpt-4.1",
  --              },
  --            },
  --          })
  --        end,
  --      }
  --    },
  --    extensions = {
  --      mcphub = {
  --        callback = "mcphub.extensions.codecompanion",
  --        opts = {
  --          make_vars = true,
  --          make_slash_commands = true,
  --          show_result_in_chat = true
  --        }
  --      },
  --      -- history = {
  --      --   enabled = true,
  --      --   opts = {
  --      --     keymap = "gh",
  --      --     continue_last_chat = true,
  --      --   }
  --      -- }
  --    }
  --  }
  --},
  {
    "OXY2DEV/markview.nvim",
    lazy = false,
    priority = 49, -- Make sure it is loaded after treesitter
    opts = {
      preview = {
        filetypes = { "markdown", "codecompanion" },
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
          { name = "codecompanion" },
        }, {
          { name = "buffer" },
          { name = "path" },
        })
      })
    end,
  },
  {
    "nvim-treesitter/nvim-treesitter",
    branch = "master", -- legacy branch: the `main` rewrite removed
                       -- nvim-treesitter.configs, which this config uses
    event = { "BufReadPost", "BufNewFile" }, -- Load Treesitter when opening a buffer
    build = ":TSUpdate",                     -- Automatically update Treesitter parsers
    config = function()
      require("nvim-treesitter.configs").setup({
        -- List of parsers to install
        ensure_installed = {
          "bash", "c", "cpp", "cuda", "cmake", "javascript", "typescript", "tsx", "python", "lua", "html", "css", "glsl", "ini"
        },
        highlight = {
          enable = true,              -- Enable Treesitter-based syntax highlighting
          additional_vim_regex_highlighting = false, -- Use only Treesitter, no fallback to regex
        },
        indent = {
          enable = true,              -- Enable Treesitter-based indentation
        },
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
      -- Verilog Language Server
      vim.lsp.config('verible', {
        cmd = { "verible-verilog-ls", "--rules_config_search", "--indentation_spaces=4" },
        filetypes = { "verilog", "systemverilog" },
      })
      -- vim.lsp.enable('verible')
      -- C++ Language Server
      vim.lsp.config('clangd', {
        cmd = { "clangd", "--experimental-modules-support" },
        filetypes = { "c", "cpp", "objc", "objcpp" },
        root_markers = { ".clangd", "compile_commands.json", ".git" },
      })
      vim.lsp.enable('clangd')
      -- Dart Language Server
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
      -- vim.lsp.enable('dartls')
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
    "ajbucci/ipynb.nvim",
    -- No `ft` lazy-trigger: nvim detects .ipynb as json, and the plugin
    -- registers its own notebook handling at setup time.
    --
    -- build: compile the bundled ipynb treesitter grammar with cc. The
    -- plugin's own auto-compile registers via the nvim-treesitter MAIN-branch
    -- API and silently does nothing on the legacy `master` branch this config
    -- pins; compiling here sidesteps that and re-runs on every plugin update.
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
        execute_all_below = "<leader>kb",  -- current cell + everything after
        -- Defaults displaced by the execute bindings above/below, relocated
        -- so nothing races: add cell Above/Below -> kA/kB, make raw -> kt
        -- (its default kr stays free).
        add_cell_above = "<leader>kA",
        add_cell_below = "<leader>kB",
        make_raw = "<leader>kt",
      },
    },
    config = function(_, opts)
      require("ipynb").setup(opts)

      -- Run ALL cells from the top (no keymap slot exists for this command,
      -- so bind it per notebook buffer). <leader>ka is free because
      -- add_cell_above was relocated to kA above.
      vim.api.nvim_create_autocmd("FileType", {
        pattern = "ipynb",
        group = vim.api.nvim_create_augroup("ipynb_execute_all_map", { clear = true }),
        callback = function(ev)
          vim.schedule(function()
            if vim.api.nvim_buf_is_valid(ev.buf) then
              vim.keymap.set("n", "<leader>ka", "<cmd>NotebookExecuteAll<cr>",
                { buffer = ev.buf, desc = "Notebook: run all cells from top" })
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
