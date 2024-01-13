local conform = require('conform')

conform.setup({
  formatters_by_ft = {
    javascript = { { "prettierd", "prettier" } },
    typescript = { { "prettierd", "prettier" } },
    python = {"black"}
  },

  format_on_save = {
    lsp_fallback = true,
    timeout_ms = 500,
  },

  format_after_save = {
    lsp_fallback = true,
  },
})

vim.keymap.set("n", "gq", function() conform.format() end)
