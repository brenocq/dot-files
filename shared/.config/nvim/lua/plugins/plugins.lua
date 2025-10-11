return {
  {
    "nvim-neo-tree/neo-tree.nvim",
    branch = "v3.x",
    dependencies = {
      "nvim-lua/plenary.nvim",
      "nvim-tree/nvim-web-devicons",
      "MunifTanjim/nui.nvim",
      -- "3rd/image.nvim",
    },
    lazy = false, -- neo-tree will lazily load itself
    config = function()
      require("neo-tree").setup({
        source_selector = {
            winbar = false,
            statusline = false
        },
        window = {
          mappings = {
            ['p'] = {
                   "toggle_preview",
                   config = {
                     use_float = true,
                     -- use_image_nvim = true,
                     title = 'Neo-tree Preview',
                   },
                 },
          },
        },
        close_if_last_window = true,
        popup_border_style = "rounded",
        enable_git_status = true,
        enable_diagnostics = true,
        sort_case_insensitive = true,
        filesystem = {
          use_libuv_file_watcher = true,
          filtered_items = {
              visible = true,
              hide_gitignored = false,
              hide_dotfiles = false,
          },
        },
      })
    end
  },
  -- {
  --   "3rd/image.nvim",
  --   opts = {
  --     backend = "kitty",
  --     processor = "magick_rock",
  --     integrations = {
  --       markdown = {
  --         enabled = true,
  --         clear_in_insert_mode = false,
  --         download_remote_images = true,
  --         only_render_image_at_cursor = false,
  --         filetypes = { "markdown", "vimwiki" },
  --       },
  --       neorg = {
  --         enabled = true,
  --         clear_in_insert_mode = false,
  --         download_remote_images = true,
  --         only_render_image_at_cursor = false,
  --         filetypes = { "norg" },
  --       },
  --     },
  --     max_width = nil,
  --     max_height = nil,
  --     max_width_window_percentage = nil,
  --     max_height_window_percentage = 50,
  --     kitty_method = "normal",
  --     hijack_file_patterns = { "*.png", "*.jpg", "*.jpeg", "*.gif", "*.webp", "*.avif" },
  --   }
  -- },
  {
    'sainnhe/gruvbox-material',
    lazy = false,
    priority = 1000,
    config = function()
      vim.g.gruvbox_material_enable_italic = true
      vim.g.gruvbox_material_background = 'hard'
      vim.o.termguicolors = true
      vim.cmd.colorscheme('gruvbox-material')

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
  {
    "olimorris/codecompanion.nvim",
    dependencies = {
      { "nvim-lua/plenary.nvim", branch = "master" },
      { "nvim-treesitter/nvim-treesitter" },
      { "ravitemer/mcphub.nvim" },
      -- { "ravitemer/codecompanion-history.nvim" }
    },
    opts = {
      display = {
        chat = {
          window = {
            width = 0.35,
          }
        },
      },
      strategies = {
        chat = {
          adapter = "gemini",
          roles = {
            llm =  function(adapter)
              return string.format(
                '✨ %s%s',
                adapter.formatted_name,
                adapter.parameters.model and ' (' .. adapter.parameters.model .. ')' or ''
              )
            end,
            user = "🌳🐵 brenocq",
          }
        },
        inline = {
          adapter = "gemini",
          keymaps = {
            accept_change = {
              modes = { n = "<leader>a" },
              description = "Accept the suggested change",
            },
            reject_change = {
              modes = { n = "<leader>r" },
              description = "Reject the suggested change",
            },
          },
        },
        cmd = {
            adapter = "gemini",
        },
      },
      adapters = {
        http = {
          gemini = function()
            return require("codecompanion.adapters").extend("gemini", {
              schema = {
                model = {
                  default = "gemini-2.5-pro",
                },
              },
            })
          end,
          openai = function()
            return require("codecompanion.adapters").extend("openai", {
              schema = {
                model = {
                  default = "gpt-4.1",
                },
              },
            })
          end,
        },
      },
      extensions = {
        mcphub = {
          callback = "mcphub.extensions.codecompanion",
          opts = {
            make_vars = true,
            make_slash_commands = true,
            show_result_in_chat = true
          }
        },
        -- history = {
        --   enabled = true,
        --   opts = {
        --     keymap = "gh",
        --     continue_last_chat = true,
        --   }
        -- }
      }
    }
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
  -- {
  --   "OXY2DEV/markview.nvim",
  --   lazy = false,
  --   dependencies = { "nvim-treesitter/nvim-treesitter" },
  --   opts = {
  --     preview = {
  --       filetypes = { "markdown", "codecompanion" },
  --       ignore_buftypes = {},
  --     },
  --   },
  -- },
  {
    "nvim-treesitter/nvim-treesitter",
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
        -- Optional: Enable other features like rainbow brackets or text objects
        rainbow = {
          enable = true,              -- Enable rainbow parentheses
          extended_mode = true,       -- Highlight beyond parentheses
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
  {
    'https://github.com/github/copilot.vim',
    config = function()
      vim.api.nvim_set_keymap("i", "<C-l>", 'copilot#Accept("<CR>")', { expr = true, silent = true, noremap = true })
    end,
  },
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
        cmd = { "clangd" },
        filetypes = { "c", "cpp", "objc", "objcpp" },
        root_markers = {".clangd", "compile_commands.json", "compile_flags.txt", ".git"},
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
  }
}
