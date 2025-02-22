return {
    {
	  "nvim-neo-tree/neo-tree.nvim",
      branch = "v3.x",
      dependencies = {
        "nvim-lua/plenary.nvim",
        "nvim-tree/nvim-web-devicons",
        "MunifTanjim/nui.nvim",
        "3rd/image.nvim",
      }
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
    event = { "BufReadPost", "BufNewFile" }, -- Load Treesitter when opening a buffer
    build = ":TSUpdate",                     -- Automatically update Treesitter parsers
    config = function()
      require("nvim-treesitter.configs").setup({
        -- List of parsers to install
        ensure_installed = {
          "bash", "c", "cpp", "cuda", "cmake", "javascript", "typescript", "python", "lua", "html", "css"
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
    "easymotion/vim-easymotion",
    keys = { "s" },  -- Lazy load when 's' is pressed
    config = function()
      -- Disable default EasyMotion mappings
      vim.g.EasyMotion_do_mapping = 0
      -- Custom EasyMotion mapping
      vim.api.nvim_set_keymap('n', 's', '<Plug>(easymotion-overwin-f2)', {})
    end,
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
    "jackMort/ChatGPT.nvim",
    event = "VeryLazy",
    config = function()
      require("chatgpt").setup({
        openai_params = {
            model = "gpt-4o",
            frequency_penalty = 0,
            presence_penalty = 0,
            max_tokens = 4095,
            temperature = 0.2,
            top_p = 0.1,
            n = 1,
        },
        openai_edit_params = {
            model = "gpt-4o",
            frequency_penalty = 0,
            presence_penalty = 0,
            temperature = 0.2,
            top_p = 1,
            n = 1,
        },
	    keymaps = {
            close = { "<C-Esc>" },
            submit = "<C-CR>",
            yank_last = "<C-y>",
            next_screen = "<C-k>"
        },
        actions_paths = {
            "~/.config/nvim/lua/plugins/chatgpt.json"
        }
      })
    end,
    dependencies = {
      "MunifTanjim/nui.nvim",
      "nvim-lua/plenary.nvim",
      "folke/trouble.nvim",
      "nvim-telescope/telescope.nvim"
    }
  },
  --{
  --  "tpope/vim-fugitive",
  --  cmd = { "Gdiffsplit", "Gvdiffsplit", "Gdiff" },
  --},
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
      local lspconfig = require('lspconfig')
      -- Verilog Language Server
      lspconfig.verible.setup{
        cmd = { "verible-verilog-ls", "--rules_config_search", "--indentation_spaces=4" },
        filetypes = { "verilog", "systemverilog" },
      }
      -- C++ Language Server
      lspconfig.clangd.setup{
        cmd = { "clangd" },
        filetypes = { "c", "cpp", "objc", "objcpp" },
        root_dir = lspconfig.util.root_pattern("compile_commands.json", "compile_flags.txt", ".git"),
        settings = {
          clangd = {
            fallbackFlags = { "-std=c++17" },
          }
        }
      }
      -- Dart Language Server
      lspconfig.dartls.setup{
        cmd = { "dart", "language-server" },
        filetypes = { "dart" },
        root_dir = lspconfig.util.root_pattern("pubspec.yaml"),
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
      }
    end
  }
}
