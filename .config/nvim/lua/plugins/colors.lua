Icons = require("config.constants").icons
return {
  -- {{{ nvim-treesitter
  {
    "nvim-treesitter/nvim-treesitter",
    event = "LazyFile",
    build = ":TSUpdate",
    -- version = "v0.9.1",
    keys = {
      { "<c-space>", desc = "Increment selection" },
      { "<bs>", desc = "Decrement selection", mode = "x" },
    },
    opts = {
      -- autopairs = { enable = true },
      autotag = { enable = true, disable = { "xml" } },
      autoinstall = true,
      context_commenting = { enable = true, enable_autocmd = false },
      highlight = {
        enable = true,
        disable = Constants.disabled.treesitter,
        additional_vim_regex_highlighting = true,
      },
      textobjects = {
        select = {
          enable = true,
          lookahead = true,
          keymaps = {
            ["af"] = "@function.outer",
            ["if"] = "@function.inner",
            ["ac"] = "@class.outer",
            ["ic"] = "@class.inner",
          },
          selection_modes = {},
          include_surrounding_whitespace = true,
        },
      },
      indent = { enable = false, disable = { "yml", "yaml" } },
      rainbow = {
        enable = true,
        extended_mode = false,
        max_file_lines = nil,
        query = "rainbow-parens",
        -- colors = Constants.colors.rainbow,
      },
      disable = { "latex" },
      ensure_installed = Constants.ensure_installed.treesitter,
      incremental_selection = {
        enable = true,
        keymaps = {
          init_selection = "<C-space>",
          node_incremental = "<C-space>",
          scope_incremental = "<nop>",
          node_decremental = "<bs>",
        },
      },
    },

    config = function(_, opts)
      require("nvim-treesitter.configs").setup(opts)
    end,

    dependencies = {
      "windwp/nvim-ts-autotag",
      {
        "JoosepAlviste/nvim-ts-context-commentstring",
        config = function(_, opts)
          require("ts_context_commentstring").setup(opts)

          vim.g.skip_ts_context_commentstring_module = true
        end,
      },
      {
        "nvim-treesitter/nvim-treesitter-textobjects",
        init = function()
          -- PERF: no need to load the plugin, if we only need its queries for mini.ai
          local plugin = require("lazy.core.config").spec.plugins["nvim-treesitter"]
          local opts = require("lazy.core.plugin").values(plugin, "opts", false)
          local enabled = false
          if opts.textobjects then
            for _, mod in ipairs({ "move", "select", "swap", "lsp_interop" }) do
              if opts.textobjects[mod] and opts.textobjects[mod].enable then
                enabled = true
                break
              end
            end
          end
          if not enabled then
            require("lazy.core.loader").disable_rtp_plugin("nvim-treesitter-textobjects")
          end
        end,
      },
    },
  },
  -- ----------------------------------------------------------------------- }}}
  -- {{{ rainbow-delimiters
  {
    "HiPhish/rainbow-delimiters.nvim",
    opts = {},
    enabled = false,
    event = "LazyFile",
    main = "rainbow-delimiters.setup",
  },
  -- }}}
  -- {{{ solarized-osaka.nvim
  {
    "craftzdog/solarized-osaka.nvim",
    priority = 1000,
    opts = {
      transparent = true,
      styles = {
        sidebars = "transparent",
        floats = "transparent",
      },
    },
    lazy = false,
    config = function(_, opts)
      require("solarized-osaka").setup(opts)

      vim.cmd.colorscheme("solarized-osaka")
    end,
    enabled = false,
  },
  -- }}}
  -- {{{ nvim-colorizer
  {
    "JosefLitos/colorizer.nvim",
    event = "LazyFile",
    opts = {
      filetypes = { "*" },
      mode = "background",
    },
    config = function(_, opts)
      require("colorizer").setup(opts)
    end,
  },
  -- ----------------------------------------------------------------------- }}}
  -- {{{ gruvbox
  {
    "ellisonleao/gruvbox.nvim",
    priority = 1000,
    enabled = true,
    lazy = false,
    opts = {
      transparent_mode = true,
      terminal_colors = true,
    },
    config = function(_, opts)
      require("gruvbox").setup(opts)
      vim.cmd.colorscheme("gruvbox")
    end,
  },
  -- }}}gruvbox
  -- {{{ zenbones
  {
    "zenbones-theme/zenbones.nvim",
    priority = 1000,
    enabled = false,
    lazy = false,
    dependencies = "rktjmp/lush.nvim",
    config = function()
      vim.g.zenbones = {
        darken_comments = 45,
      }

      vim.cmd.colorscheme("zenbones")
    end,
  },
  -- }}}
  -- {{{ gruber-darker
  {
    "blazkowolf/gruber-darker.nvim",
    enabled = false,
    priority = 1000,
    lazy = false,
    config = function(_, opts)
      vim.cmd.colorscheme("gruber-darker")
    end,
  },
  -- }}}
  -- {{{ hyper.nvim
  {
    "paulo-granthon/hyper.nvim",
    enabled = false,
    priority = 1000,
    lazy = false,
    config = function(_, opts)
      require("hyper").load()
    end,
  },
  -- }}}
}
