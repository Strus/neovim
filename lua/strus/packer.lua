vim.cmd [[packadd packer.nvim]]

return require('packer').startup(function(use)
    use 'wbthomason/packer.nvim'

    -- navigation
    use {
        'nvim-telescope/telescope.nvim', branch = '0.1.x',
        requires = { { 'nvim-lua/plenary.nvim' } }
    }
    use { 'nvim-telescope/telescope-fzf-native.nvim',
        run =
        'cmake -S. -Bbuild -DCMAKE_BUILD_TYPE=Release && cmake --build build --config Release && cmake --install build --prefix build' }
    use 'barrett-ruth/telescope-http.nvim'
    use 'theprimeagen/harpoon'
    use {
        "SmiteshP/nvim-navbuddy",
        requires = {
            "neovim/nvim-lspconfig",
            "SmiteshP/nvim-navic",
            "MunifTanjim/nui.nvim"
        }
    }
    use 'nvim-tree/nvim-tree.lua'
    use {
        'ggandor/leap.nvim',
        config = function()
            require('leap').add_default_mappings()
        end,
    }
    use {
        "folke/trouble.nvim",
        config = function()
            require("trouble").setup {
                mode = "document_diagnostics"
            }
        end
    }

    -- themes
    use 'monsonjeremy/onedark.nvim'
    use 'EdenEast/nightfox.nvim'
    use 'sainnhe/everforest'
    use 'ellisonleao/gruvbox.nvim'
    use 'rebelot/kanagawa.nvim'

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

            -- Snippets
            { 'L3MON4D3/LuaSnip' },             -- Required
            { 'rafamadriz/friendly-snippets' }, -- Optional
        }
    }
    use { "rcarriga/nvim-dap-ui", requires = { "mfussenegger/nvim-dap" } }
    use 'j-hui/fidget.nvim'
    use { 'akinsho/flutter-tools.nvim', requires = 'nvim-lua/plenary.nvim' }
    use { 'simrat39/rust-tools.nvim' }
    use 'jose-elias-alvarez/null-ls.nvim'
    use 'rust-lang/rust.vim'
    use 'mfussenegger/nvim-dap-python'
    use 'Vimjas/vim-python-pep8-indent'
    use 'p00f/clangd_extensions.nvim'

    -- ui improvements
    use { 'fgheng/winbar.nvim' }
    use { 'petertriho/nvim-scrollbar' }
    use { 'shortcuts/no-neck-pain.nvim', tag = '*' }
    use 'kevinhwang91/nvim-bqf'
    use 'nvim-lualine/lualine.nvim'
    use({
        "luukvbaal/statuscol.nvim",
    })
    use {
        'lewis6991/gitsigns.nvim',
        config = function()
            require('gitsigns').setup()
            require("scrollbar.handlers.gitsigns").setup()
        end
    }
    use { 'weilbith/nvim-code-action-menu', cmd = "CodeActionMenu" }

    -- code testing
    use 'vim-test/vim-test'
    use 'okcompute/vim-nose'
    use {
        "nvim-neotest/neotest",
        requires = {
            "nvim-lua/plenary.nvim",
            "nvim-treesitter/nvim-treesitter",
            "antoinemadec/FixCursorHold.nvim",
            "nvim-neotest/neotest-python",
        }
    }

    -- editing
    use 'terrortylor/nvim-comment'
    use {
        "windwp/nvim-autopairs",
        config = function() require("nvim-autopairs").setup {} end
    }
    use {
        "danymat/neogen",
        requires = "nvim-treesitter/nvim-treesitter",
        tag = "*"
    }
    use({
        "kylechui/nvim-surround",
        tag = "*",
        config = function()
            require("nvim-surround").setup()
        end
    })
    use {
        "ThePrimeagen/refactoring.nvim",
        requires = {
            { "nvim-lua/plenary.nvim" },
            { "nvim-treesitter/nvim-treesitter" }
        }
    }

    -- project management
    use { "ahmedkhalf/project.nvim" }
    use 'jandamm/vim-projplugin'
    use 'airblade/vim-rooter'

    -- misc
    use 'wakatime/vim-wakatime'
    use 'mbbill/undotree'
    use({
        "iamcco/markdown-preview.nvim",
        run = function() vim.fn["mkdp#util#install"]() end,
    })
    use({
        'asiryk/auto-hlsearch.nvim',
        config = function()
            require("auto-hlsearch").setup()
        end
    })
    use "tpope/vim-fugitive"
    use { "akinsho/toggleterm.nvim", tag = '*' }

    -- plugin utilities
    use 'tpope/vim-dispatch'
    use 'nvim-tree/nvim-web-devicons'
    use 'Shougo/denite.nvim'
end)
