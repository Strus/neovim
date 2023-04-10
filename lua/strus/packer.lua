vim.cmd [[packadd packer.nvim]]

return require('packer').startup(function(use)
    use 'wbthomason/packer.nvim'
    use {
        'nvim-telescope/telescope.nvim', tag = '0.1.1',
        requires = { { 'nvim-lua/plenary.nvim' } }
    }
    use { 'nvim-telescope/telescope-fzf-native.nvim',
        run =
        'cmake -S. -Bbuild -DCMAKE_BUILD_TYPE=Release && cmake --build build --config Release && cmake --install build --prefix build' }
    use 'barrett-ruth/telescope-http.nvim'
    use 'monsonjeremy/onedark.nvim'
    use {
        'nvim-treesitter/nvim-treesitter',
        run = ':TSUpdate'
    }
    use 'theprimeagen/harpoon'
    use 'mbbill/undotree'
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
    use {
        "SmiteshP/nvim-navbuddy",
        requires = {
            "neovim/nvim-lspconfig",
            "SmiteshP/nvim-navic",
            "MunifTanjim/nui.nvim"
        }
    }
    use 'j-hui/fidget.nvim'
    use 'smithbm2316/centerpad.nvim'
    use { 'shortcuts/no-neck-pain.nvim', tag = '*' }
    use 'kevinhwang91/nvim-bqf'
    use 'nvim-tree/nvim-web-devicons'
    use 'nvim-tree/nvim-tree.lua'
    use {
        "ThePrimeagen/refactoring.nvim",
        requires = {
            { "nvim-lua/plenary.nvim" },
            { "nvim-treesitter/nvim-treesitter" }
        }
    }
    use { "rcarriga/nvim-dap-ui", requires = { "mfussenegger/nvim-dap" } }
    use { 'akinsho/flutter-tools.nvim', requires = 'nvim-lua/plenary.nvim' }
    use { 'simrat39/rust-tools.nvim' }
    use { "ahmedkhalf/project.nvim" }
    use 'terrortylor/nvim-comment'
    use {
        "windwp/nvim-autopairs",
        config = function() require("nvim-autopairs").setup {} end
    }
    use({
        "luukvbaal/statuscol.nvim",
        config = function() require("statuscol").setup() end,
        commit = "5269fb1220f0909c82be8a0c9eab657a55a5f1fa",
    })
    use "tpope/vim-fugitive"
    use 'vim-test/vim-test'
    use 'tpope/vim-dispatch'
    use 'okcompute/vim-nose'
    use 'airblade/vim-rooter'
    use 'jandamm/vim-projplugin'
    use {
        "nvim-neotest/neotest",
        requires = {
            "nvim-lua/plenary.nvim",
            "nvim-treesitter/nvim-treesitter",
            "antoinemadec/FixCursorHold.nvim",
            "nvim-neotest/neotest-python",
        }
    }
    use 'Shougo/denite.nvim'
    use {
        "danymat/neogen",
        requires = "nvim-treesitter/nvim-treesitter",
        tag = "*"
    }
    use 'jose-elias-alvarez/null-ls.nvim'
    use 'rust-lang/rust.vim'
    use 'nvim-lualine/lualine.nvim'
    use { 'fgheng/winbar.nvim' }
    use { "akinsho/toggleterm.nvim", tag = '*' }
    use({
        "kylechui/nvim-surround",
        tag = "*",
        config = function()
            require("nvim-surround").setup()
        end
    })
    use({
        'asiryk/auto-hlsearch.nvim',
        config = function()
            require("auto-hlsearch").setup()
        end
    })
    use {
        "folke/trouble.nvim",
        config = function()
            require("trouble").setup {
                mode = "document_diagnostics"
            }
        end
    }
    use 'wakatime/vim-wakatime'
    use 'mfussenegger/nvim-dap-python'
    use 'Vimjas/vim-python-pep8-indent'
    use {
        'lewis6991/gitsigns.nvim',
        config = function()
            require('gitsigns').setup()
            require("scrollbar.handlers.gitsigns").setup()
        end
    }
    use { 'weilbith/nvim-code-action-menu', cmd = "CodeActionMenu" }
    use({
        "iamcco/markdown-preview.nvim",
        run = function() vim.fn["mkdp#util#install"]() end,
    })
    use { 'petertriho/nvim-scrollbar' }
    use {
        "chrisgrieser/nvim-early-retirement",
        config = function()
            require("early-retirement").setup()
        end,
    }
    use {
        'ggandor/leap.nvim',
        config = function()
            require('leap').add_default_mappings()
        end,
    }
end)
