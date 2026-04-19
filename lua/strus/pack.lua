-- Hooks for plugins that need post-install/update build steps
vim.api.nvim_create_autocmd('PackChanged', {
  callback = function(ev)
    local name, kind = ev.data.spec.name, ev.data.kind

    -- nvim-treesitter: update parsers on install/update
    if name == 'nvim-treesitter' and (kind == 'install' or kind == 'update') then
      if not ev.data.active then vim.cmd.packadd('nvim-treesitter') end
      vim.cmd('TSUpdate')
    end

    -- telescope-fzf-native.nvim: cmake build on install/update
    if name == 'telescope-fzf-native.nvim' and (kind == 'install' or kind == 'update') then
      local dir = vim.fn.stdpath('data') .. '/site/pack/core/opt/telescope-fzf-native.nvim'
      vim.fn.system(
        'cd ' .. vim.fn.shellescape(dir) ..
        ' && cmake -S. -Bbuild -DCMAKE_BUILD_TYPE=Release' ..
        ' && cmake --build build --config Release' ..
        ' && cmake --install build --prefix build'
      )
    end

    -- markdown-preview.nvim: install mkdp on install/update
    if name == 'markdown-preview.nvim' and (kind == 'install' or kind == 'update') then
      if not ev.data.active then vim.cmd.packadd('markdown-preview.nvim') end
      vim.fn['mkdp#util#install']()
    end
  end
})

vim.pack.add({
  -- navigation
  'https://github.com/nvim-telescope/telescope.nvim',
  'https://github.com/nvim-telescope/telescope-fzf-native.nvim',
  'https://github.com/princejoogie/dir-telescope.nvim',
  'https://github.com/SmiteshP/nvim-navic',
  'https://github.com/MunifTanjim/nui.nvim',
  'https://github.com/SmiteshP/nvim-navbuddy',
  'https://github.com/nvim-tree/nvim-tree.lua',
  'https://github.com/folke/trouble.nvim',
  'https://github.com/RRethy/vim-illuminate',

  -- themes
  'https://github.com/EdenEast/nightfox.nvim',
  'https://github.com/sainnhe/everforest',
  'https://github.com/maxmx03/solarized.nvim',

  -- code-specific (lsp etc.)
  { src = 'https://github.com/nvim-treesitter/nvim-treesitter', version = 'main' },
  'https://github.com/neovim/nvim-lspconfig',
  'https://github.com/williamboman/mason.nvim',
  'https://github.com/williamboman/mason-lspconfig.nvim',
  'https://github.com/hrsh7th/nvim-cmp',
  'https://github.com/hrsh7th/cmp-nvim-lsp',
  'https://github.com/hrsh7th/cmp-buffer',
  'https://github.com/hrsh7th/cmp-path',
  'https://github.com/saadparwaiz1/cmp_luasnip',
  'https://github.com/hrsh7th/cmp-nvim-lua',
  'https://github.com/hrsh7th/cmp-nvim-lsp-signature-help',
  'https://github.com/L3MON4D3/LuaSnip',
  'https://github.com/rafamadriz/friendly-snippets',
  'https://github.com/mfussenegger/nvim-dap',
  'https://github.com/nvim-neotest/nvim-nio',
  'https://github.com/rcarriga/nvim-dap-ui',
  'https://github.com/j-hui/fidget.nvim',
  'https://github.com/rust-lang/rust.vim',
  -- 'https://github.com/simrat39/rust-tools.nvim', -- TODO: change to https://github.com/mrcjkb/rustaceanvim
  'https://github.com/nvimtools/none-ls.nvim',
  'https://github.com/mfussenegger/nvim-dap-python',
  'https://github.com/Vimjas/vim-python-pep8-indent',
  'https://github.com/p00f/clangd_extensions.nvim',
  'https://github.com/google/vim-jsonnet',
  'https://github.com/tpope/vim-rails',

  -- ui improvements
  'https://github.com/Bekaboo/dropbar.nvim',
  'https://github.com/petertriho/nvim-scrollbar',
  'https://github.com/kevinhwang91/nvim-bqf',
  'https://github.com/nvim-lualine/lualine.nvim',
  'https://github.com/luukvbaal/statuscol.nvim',
  'https://github.com/lewis6991/gitsigns.nvim',

  -- code testing
  'https://github.com/vim-test/vim-test',
  'https://github.com/okcompute/vim-nose',
  'https://github.com/antoinemadec/FixCursorHold.nvim',
  'https://github.com/nvim-neotest/neotest-python',
  'https://github.com/nvim-neotest/neotest',
  { src = 'https://github.com/ej-shafran/compile-mode.nvim',    version = vim.version.range('4.x') },

  -- editing
  'https://github.com/terrortylor/nvim-comment',
  'https://github.com/windwp/nvim-autopairs',
  'https://github.com/danymat/neogen',
  'https://github.com/kylechui/nvim-surround',
  'https://github.com/ThePrimeagen/refactoring.nvim',
  'https://github.com/MagicDuck/grug-far.nvim',

  -- project management
  'https://github.com/jandamm/vim-projplugin',
  'https://github.com/airblade/vim-rooter',

  -- misc
  'https://github.com/gelguy/wilder.nvim',
  'https://github.com/wakatime/vim-wakatime',
  'https://github.com/iamcco/markdown-preview.nvim',
  'https://github.com/asiryk/auto-hlsearch.nvim',
  'https://github.com/folke/snacks.nvim',
  'https://github.com/tpope/vim-fugitive',
  'https://github.com/sindrets/diffview.nvim',
  'https://github.com/NeogitOrg/neogit',
  'https://github.com/zbirenbaum/copilot.lua',
  'https://github.com/copilotlsp-nvim/copilot-lsp',
  { src = 'https://github.com/nvim-mini/mini.nvim', version = 'stable' },

  -- plugin utilities
  'https://github.com/nvim-lua/plenary.nvim',
  'https://github.com/tpope/vim-dispatch',
  'https://github.com/nvim-tree/nvim-web-devicons',
  'https://github.com/Shougo/denite.nvim',
  'https://github.com/m00qek/baleia.nvim',
  'https://github.com/nvim-flutter/flutter-tools.nvim',

  -- from original plugins.lua
  'https://github.com/theprimeagen/harpoon',
})
