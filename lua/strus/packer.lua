local ensure_packer = function()
  local fn = vim.fn
  local install_path = fn.stdpath('data') .. '/site/pack/packer/start/packer.nvim'
  if fn.empty(fn.glob(install_path)) > 0 then
    fn.system({ 'git', 'clone', '--depth', '1', 'https://github.com/Strus/packer.nvim', install_path })
    vim.cmd [[packadd packer.nvim]]
  end
end

ensure_packer()

return require('packer').startup({
  function(use)
    use 'Strus/packer.nvim'

    -- navigation
    use {
      'nvim-telescope/telescope.nvim',
      branch = '0.1.x'
    }
    use {
      'nvim-telescope/telescope-fzf-native.nvim',
      run = 'cmake -S. -Bbuild -DCMAKE_BUILD_TYPE=Release && cmake --build build --config Release && cmake --install build --prefix build'
    }
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
    use 'folke/trouble.nvim'
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
    use 'neovim/nvim-lspconfig'
    use 'williamboman/mason.nvim'
    use 'williamboman/mason-lspconfig.nvim'
    use 'hrsh7th/nvim-cmp'
    use 'hrsh7th/cmp-nvim-lsp'
    use 'hrsh7th/cmp-buffer'
    use 'hrsh7th/cmp-path'
    use 'saadparwaiz1/cmp_luasnip'
    use 'hrsh7th/cmp-nvim-lua'
    use 'hrsh7th/cmp-nvim-lsp-signature-help'
    use 'L3MON4D3/LuaSnip'
    use 'rafamadriz/friendly-snippets'
    use {
      "rcarriga/nvim-dap-ui",
      requires = {
        "mfussenegger/nvim-dap",
        "nvim-neotest/nvim-nio",
      }
    }
    use 'j-hui/fidget.nvim'
    use 'rust-lang/rust.vim'
    use 'simrat39/rust-tools.nvim'
    use 'nvimtools/none-ls.nvim'
    use 'mfussenegger/nvim-dap-python'
    use 'Vimjas/vim-python-pep8-indent'
    use 'p00f/clangd_extensions.nvim'
    use 'google/vim-jsonnet'
    use 'tpope/vim-rails'

    -- ui improvements
    use 'fgheng/winbar.nvim'
    use 'petertriho/nvim-scrollbar'
    use 'kevinhwang91/nvim-bqf'
    use 'nvim-lualine/lualine.nvim'
    use 'luukvbaal/statuscol.nvim'
    use 'lewis6991/gitsigns.nvim'

    use {
      'weilbith/nvim-code-action-menu',
      cmd = 'CodeActionMenu'
    }

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
    use {
      'ej-shafran/compile-mode.nvim',
      tag = 'v4.*'
    }

    -- editing
    use 'terrortylor/nvim-comment'
    use 'windwp/nvim-autopairs'

    use 'danymat/neogen'
    use 'kylechui/nvim-surround'

    use 'ThePrimeagen/refactoring.nvim'
    use 'MagicDuck/grug-far.nvim'

    -- project management
    use 'jandamm/vim-projplugin'
    use 'airblade/vim-rooter'

    -- misc
    use 'gelguy/wilder.nvim'
    use 'wakatime/vim-wakatime'
    use 'mbbill/undotree'
    use {
      'iamcco/markdown-preview.nvim',
      run = function() vim.fn['mkdp#util#install']() end,
    }
    use 'asiryk/auto-hlsearch.nvim'
    use 'folke/snacks.nvim'

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
    use 'NeogitOrg/neogit'
    use "zbirenbaum/copilot.lua"
    use "olimorris/codecompanion.nvim"
    use {
      'nvim-mini/mini.nvim',
      branch = 'stable'
    }

    -- plugin utilities
    use 'nvim-lua/plenary.nvim'
    use 'tpope/vim-dispatch'
    use 'nvim-tree/nvim-web-devicons'
    use 'Shougo/denite.nvim'
    use 'm00qek/baleia.nvim'
    use 'nvim-flutter/flutter-tools.nvim'
  end,
  config = {
    profile = {
      enable = false,
      threshold = 1 -- the amount in ms that a plugin's load time must be over for it to be included in the profile
    },
    max_jobs = 16,
  },
})
