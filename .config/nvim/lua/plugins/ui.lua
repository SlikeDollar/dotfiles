Icons = require("config.constants").icons

return {
  -- {{{ bufferline.nvim
  {
    "akinsho/bufferline.nvim",
    enabled = true,
    keys = {
      { "te", "<cmd>:tabedit<cr>", desc = "Create new tab" },
      { "<Tab>", "<Cmd>BufferLineCycleNext<CR>", desc = "Cycle tabs forwards" },
      { "gt", "<cmd>BufferLinePick<cr>", desc = "Pick tab" },
      { "gT", "<cmd>BufferLinePickClose<cr>", desc = "Pick tab to close" },
      { "gtd", "<cmd>BufferLineClose<cr>", desc = "Close all tabs" },
      { "<S-Tab>", "<Cmd>BufferLineCyclePrev<CR>", desc = "Cycle tabs backwards" },
      { "<C-Tab>", "<cmd>tablast<cr>", desc = "Jump to the last tab" },
      { "<C-S-Tab>", "<cmd>tabfirst<cr>", desc = "Jump to the first tab" },
      { "<leader>tp", "<cmd>BufferLineTogglePin<cr>", desc = "Pin tab" },
    },
    opts = {
      options = {
        mode = "tabs",
        separator_style = "thin",
        show_buffer_close_icons = false,
        show_close_icon = false,
        color_icons = true,
        diagnostics = "nvim_lsp",
        always_show_bufferline = false,
        diagnostics_indicator = function(_, _, diag)
          local icons = Constants.icons.diagnostics
          local ret = (diag.error and icons.Error .. diag.error .. " " or "")
            .. (diag.warning and icons.Warning .. diag.warning or "")
          return vim.trim(ret)
        end,
      },
      highlights = {
        buffer_selected = {
          italic = true,
          bold = false,
        },
      },
    },
  },
  -- ----------------------------------------------------------------------- }}}
  -- {{{ dressing
  {
    "stevearc/dressing.nvim",
    lazy = true,
    init = function()
      ---@diagnostic disable-next-line: duplicate-set-field
      vim.ui.select = function(...)
        require("lazy").load({ plugins = { "dressing.nvim" } })
        return vim.ui.select(...)
      end
      ---@diagnostic disable-next-line: duplicate-set-field
      vim.ui.input = function(...)
        require("lazy").load({ plugins = { "dressing.nvim" } })
        return vim.ui.input(...)
      end
    end,
  },

  -- ----------------------------------------------------------------------- }}}
  -- {{{ gitsigns.nvim
  {
    "lewis6991/gitsigns.nvim",
    event = "LazyFile",
    enabled = false,
    keys = {
      { "<leader>SR", '<cmd>lua require "gitsigns".reset_hunk()<cr>' },
      { "<leader>SS", '<cmd>lua require "gitsigns".stage_hunk()<cr>' },
      { "<leader>Sd", "<cmd>Gitsigns diffthis HEAD<cr>" },
      { "<leader>Sh", '<cmd>lua require "gitsigns".undo_stage_hunk()<cr>' },
      { "<leader>Sj", '<cmd>lua require "gitsigns".next_hunk()<cr>' },
      { "<leader>Sk", '<cmd>lua require "gitsigns".prev_hunk()<cr>' },
      { "<leader>Sp", '<cmd>lua require "gitsigns".preview_hunk()<cr>' },
      { "<leader>Sr", '<cmd>lua require "gitsigns".reset_buffer()<cr>' },
    },
    opts = {
      signs = {
        add = { text = "▎" },
        change = { text = "▎" },
        delete = { text = "" },
        topdelete = { text = "" },
        changedelete = { text = "▎" },
        untracked = { text = "▎" },
      },
      signcolumn = true,
      numhl = true,
      linehl = false,
      word_diff = false,
      watch_gitdir = {
        interval = 1000,
        follow_files = true,
      },
      attach_to_untracked = true,
      current_line_blame = true,
      current_line_blame_opts = {
        virt_text = true,
        virt_text_pos = "eol",
        delay = 1000,
        ignore_whitespace = false,
      },
      current_line_blame_formatter_opts = {
        relative_time = false,
      },
      sign_priority = 6,
      update_debounce = 100,
      status_formatter = nil,
      max_file_length = 40000,
      preview_config = {
        border = "rounded",
        style = "minimal",
        relative = "cursor",
        row = 0,
        col = 1,
      },
    },
  },

  -- ----------------------------------------------------------------------- }}}
  -- {{{ nvim-notify
  {
    "rcarriga/nvim-notify",
    keys = {
      {
        "<leader>un",
        function()
          require("notify").dismiss({ silent = true, pending = true })
        end,
        desc = "Dismiss notification",
      },
    },
    opts = {
      -- level = 3,
      render = "wrapped-compact",
      stages = "static",
      timeout = 3000,
      max_height = function()
        return math.floor(vim.o.lines * 0.75)
      end,
      max_width = function()
        return math.floor(vim.o.columns * 0.75)
      end,
    },
  },
  -- ----------------------------------------------------------------------- }}}
  -- {{{ trouble.nvim

  {
    "folke/trouble.nvim",
    keys = {
      {
        "<leader>Ld",
        "<cmd>TroubleToggle lsp_document_symbols<cr>",
        desc = "open trouble with lsp symbols",
      },
      {
        "<leader>T",
        "<cmd>TroubleToggle lsp_references<cr>",
        desc = "open trouble with lsp references",
      },
      -- stylua: ignore
			{ "<leader>t", "<cmd>TroubleToggle workspace_diagnostics<cr>", desc = "Toggle Trouble with workspace diagnostics", },
      { "<leader>Td", "<cmd>TroubleToggle<cr>", desc = "Toggle trouble" },
    },
    opts = { use_diagnostic_signs = true },
  },

  -- ----------------------------------------------------------------------- }}}
}
