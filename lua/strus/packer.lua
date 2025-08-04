local ensure_packer = function()
  local fn = vim.fn
  local install_path = fn.stdpath('data') .. '/site/pack/packer/start/packer.nvim'
  if fn.empty(fn.glob(install_path)) > 0 then
    fn.system({ 'git', 'clone', '--depth', '1', 'https://github.com/wbthomason/packer.nvim', install_path })
    vim.cmd [[packadd packer.nvim]]
  end
end

ensure_packer()

return require('packer').startup({
  function(use)
    use 'wbthomason/packer.nvim'

    -- navigation
    use {
      'nvim-telescope/telescope.nvim', branch = '0.1.x',
    }
    use { 'nvim-telescope/telescope-fzf-native.nvim',
      run =
      'cmake -S. -Bbuild -DCMAKE_BUILD_TYPE=Release && cmake --build build --config Release && cmake --install build --prefix build' }
    use 'princejoogie/dir-telescope.nvim'
    use 'barrett-ruth/telescope-http.nvim'
    use 'theprimeagen/harpoon'
    use {
      'SmiteshP/nvim-navbuddy',
      requires = {
        'neovim/nvim-lspconfig',
        'SmiteshP/nvim-navic',
        'MunifTanjim/nui.nvim'
      }
    }
    use 'nvim-tree/nvim-tree.lua'
    use {
      'folke/trouble.nvim',
      config = function()
        require('trouble').setup {
          mode = 'document_diagnostics'
        }
      end,
      cmd = 'Trouble',
    }
    use 'RRethy/vim-illuminate'

    -- themes
    use 'EdenEast/nightfox.nvim'
    use 'sainnhe/everforest'
    use 'maxmx03/solarized.nvim'

    -- code-specific (lsp etc.)
    use {
      'nvim-treesitter/nvim-treesitter',
      run = ':TSUpdate'
    }
    use {
      'VonHeikemen/lsp-zero.nvim',
      branch = 'v1.x',
      requires = {
        -- LSP Support
        { 'neovim/nvim-lspconfig' },             -- Required
        { 'williamboman/mason.nvim' },           -- Optional
        { 'williamboman/mason-lspconfig.nvim' }, -- Optional

        -- Autocompletion
        { 'hrsh7th/nvim-cmp' },         -- Required
        { 'hrsh7th/cmp-nvim-lsp' },     -- Required
        { 'hrsh7th/cmp-buffer' },       -- Optional
        { 'hrsh7th/cmp-path' },         -- Optional
        { 'saadparwaiz1/cmp_luasnip' }, -- Optional
        { 'hrsh7th/cmp-nvim-lua' },     -- Optional
        { 'hrsh7th/cmp-nvim-lsp-signature-help' },

        -- Snippets
        { 'L3MON4D3/LuaSnip' },             -- Required
        { 'rafamadriz/friendly-snippets' }, -- Optional
      }
    }
    use { "rcarriga/nvim-dap-ui",
      requires = {
        "mfussenegger/nvim-dap",
        "nvim-neotest/nvim-nio",
      }
    }
    use { 'j-hui/fidget.nvim', tag = 'v1.4.5' }
    use 'rust-lang/rust.vim'
    use {
      'simrat39/rust-tools.nvim',
      config = function()
        require("rust-tools").setup({
          server = {
            on_attach = setLspMappings(bufnr, "RustFmt", "RustDebuggables"),
            settings = {
              ["rust-analyzer"] = {
                check = {
                  command = "clippy",
                  extraArgs = { "--all", "--", "-W", "clippy::all" }
                }
              }
            }
          },
          dap = {
            adapter = require('rust-tools.dap').get_codelldb_adapter(
              vim.fn.expand('~/.local/share/nvim/mason/bin/codelldb'),
              vim.fn.expand('~/.local/share/nvim/mason/packages/codelldb/extension/lldb/lib/liblldb.dylib'))
          },
        })
      end,
      ft = { 'rs' },
    }
    use 'nvimtools/none-ls.nvim'
    use 'mfussenegger/nvim-dap-python'
    use 'Vimjas/vim-python-pep8-indent'
    use 'p00f/clangd_extensions.nvim'
    use 'google/vim-jsonnet'
    use 'echasnovski/mini.trailspace'

    -- ui improvements
    use 'fgheng/winbar.nvim'
    use 'petertriho/nvim-scrollbar'
    use 'kevinhwang91/nvim-bqf'
    use 'nvim-lualine/lualine.nvim'
    use 'luukvbaal/statuscol.nvim'
    use {
      'lewis6991/gitsigns.nvim',
      config = function()
        require('gitsigns').setup({
          signcolumn = false,
        })
        require('scrollbar.handlers.gitsigns').setup()
      end
    }
    use { 'weilbith/nvim-code-action-menu', cmd = 'CodeActionMenu' }

    -- code testing
    use 'vim-test/vim-test'
    use 'okcompute/vim-nose'
    use {
      'nvim-neotest/neotest',
      requires = {
        'antoinemadec/FixCursorHold.nvim',
        'nvim-neotest/neotest-python',
      }
    }
    use { 'ej-shafran/compile-mode.nvim', tag = 'v4.*' }

    -- editing
    use 'terrortylor/nvim-comment'
    use {
      'windwp/nvim-autopairs',
      config = function()
        require('nvim-autopairs').setup()
      end
    }
    use { 'danymat/neogen', tag = '*' }
    use({
      'kylechui/nvim-surround',
      tag = '*',
      config = function()
        require('nvim-surround').setup()
      end
    })
    use 'ThePrimeagen/refactoring.nvim'

    -- project management
    use {
      'ahmedkhalf/project.nvim',
      config = function()
        require("project_nvim").setup({
          detection_methods = { "pattern" },
          patterns = {}
        })
      end,
      key = '<leader>P',
    }
    use 'jandamm/vim-projplugin'
    use 'airblade/vim-rooter'

    -- misc
    use 'gelguy/wilder.nvim'
    use 'wakatime/vim-wakatime'
    use 'mbbill/undotree'
    use({
      'iamcco/markdown-preview.nvim',
      run = function() vim.fn['mkdp#util#install']() end,
    })
    use({
      'asiryk/auto-hlsearch.nvim',
      config = function()
        require('auto-hlsearch').setup()
      end
    })
    use {
      'tpope/vim-fugitive',
      key = {
        '<leader>gs',
        '<leader>gb',
        '<leader>gL',
        '<leader>gH',
      }
    }
    use "sindrets/diffview.nvim"
    use {
      'NeogitOrg/neogit',
      cmd = 'Neogit',
      config = function()
        require("neogit").setup({
          disable_context_highlighting = true,
          git_services = {
            ["git.dev.box.net"] = "https://git.dev.box.net/${owner}/${repository}/compare/${branch_name}?expand=1",
            ["github.com"] = "https://github.com/${owner}/${repository}/compare/${branch_name}?expand=1",
          },
          kind = "split",
          sections = {
            untracked = {
              folded = true,
            },
          },
        })
      end
    }
    use "zbirenbaum/copilot.lua"
    use "olimorris/codecompanion.nvim"
    use 'echasnovski/mini.nvim'

    -- plugin utilities
    use 'nvim-lua/plenary.nvim'
    use 'tpope/vim-dispatch'
    use 'nvim-tree/nvim-web-devicons'
    use 'Shougo/denite.nvim'
    use { 'm00qek/baleia.nvim', tag = 'v1.3.0' }
  end,
  config = {
    profile = {
      enable = false,
      threshold = 1 -- the amount in ms that a plugin's load time must be over for it to be included in the profile
    },
    max_jobs = 70,
  },
})
