return {
  -- {{{ plenary
  {
    "nvim-lua/plenary.nvim",
    lazy = true,
  },
  -- ----------------------------------------------------------------------- }}}
  -- {{{ mini.bufremove
  {
    "echasnovski/mini.bufremove",
    opts = {
      silent = true,
    },
    keys = {
      {
        "<leader>bd",
        function()
          require("mini.bufremove").delete(0)
        end,
        desc = "Delete Buffer",
      },
    -- stylua: ignore
    { "<leader>bD", function() require("mini.bufremove").delete(0, true) end, desc = "Delete Buffer (Force)" },
    },
  },
  -- }}}
  -- {{{ nfnlk
  {
    "Olical/nfnl",
    ft = { "fennel" },
  },
  -- }}}
  {
    dir = "~/pipka.nvim",
    opts = {
      split = "left",
    },
    keys = {
      { "<leader>P", "<cmd>Pipka<cr>" },
    },
    cmd = "Pipka",
  },
  {
    "numToStr/FTerm.nvim",
    keys = {
      { "<A-i>", '<CMD>lua require("FTerm").toggle()<CR>' },
      { "<A-i>", '<C-\\><C-n><CMD>lua require("FTerm").toggle()<CR>', mode = "t" },
    },
  },
}
