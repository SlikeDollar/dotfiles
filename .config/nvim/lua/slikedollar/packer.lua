return require('packer').startup(function(use)
  use 'wbthomason/packer.nvim'

  use {
	  'nvim-telescope/telescope.nvim', tag = '0.1.4',
	   requires = { {'nvim-lua/plenary.nvim'} }
  }

  use("ellisonleao/gruvbox.nvim")

  use('stevearc/conform.nvim')

  use({
   'numToStr/Comment.nvim',
    config = function()
        require('Comment').setup()
    end
  })

  use("numToStr/FTerm.nvim")

  use({
      "folke/trouble.nvim",
      config = function()
          require("trouble").setup {
              icons = false,
          }
      end
  })

  use {
			'nvim-treesitter/nvim-treesitter',
			run = function()
				local ts_update = require('nvim-treesitter.install').update({ with_sync = true })
				ts_update()
	end,}

  use("tpope/vim-fugitive")
  use("nvim-treesitter/nvim-treesitter-context")

  use({
   "nvim-treesitter/nvim-treesitter-textobjects",
   after = "nvim-treesitter",
   requires = "nvim-treesitter/nvim-treesitter",
  })

  use {
	  'VonHeikemen/lsp-zero.nvim',
	  branch = 'v1.x',
	  requires = {
		  -- LSP Support
		  {'neovim/nvim-lspconfig'},
		  {'williamboman/mason.nvim'},
	    {'williamboman/mason-lspconfig.nvim'},

		  -- Autocompletion
		  {'hrsh7th/nvim-cmp'},
		  {'hrsh7th/cmp-buffer'},
		  {'hrsh7th/cmp-path'},
		  {'saadparwaiz1/cmp_luasnip'},
		  {'hrsh7th/cmp-nvim-lsp'},
		  {'hrsh7th/cmp-nvim-lua'},

		  -- Snippets
		  {
        'L3MON4D3/LuaSnip',
        tag = "v2.*",
        run="make install_jsregexp",
      },
		  {'rafamadriz/friendly-snippets',},
	  }
  }

end)

