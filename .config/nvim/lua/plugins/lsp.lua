Constants = require("config.constants")

return {
  -- {{{ mason.nvim
  {
    "williamboman/mason.nvim",
    cmd = "Mason",
    opts = {
      ui = {
        border = "rounded",
        icons = {
          package_installed = "◍",
          package_pending = "◍",
          package_uninstalled = "◍",
        },
      },
      log_level = vim.log.levels.INFO,
      max_concurrent_installers = 4,
      ensure_installed = Constants.ensure_installed.mason,
    },
    config = function(_, opts)
      require("mason").setup(opts)
      local mr = require("mason-registry")
      mr:on("package:install:success", function()
        vim.defer_fn(function()
          -- trigger FileType event to possibly load this newly installed LSP server
          require("lazy.core.handler.event").trigger({
            event = "FileType",
            buf = vim.api.nvim_get_current_buf(),
          })
        end, 100)
      end)
      local function ensure_installed()
        for _, tool in ipairs(opts.ensure_installed) do
          local p = mr.get_package(tool)
          if not p:is_installed() then
            p:install()
          end
        end
      end
      if mr.refresh then
        mr.refresh(ensure_installed)
      else
        ensure_installed()
      end
    end,
  },
  -- ----------------------------------------------------------------------- }}}
  -- {{{ nvim-lspconfig
  {
    "neovim/nvim-lspconfig",
    event = "LazyFile",
    keys = {
      -- stylua: ignore
			{ "<leader>Ll", function() vim.lsp.codelens.run() end, },
      -- stylua: ignore
			{ "<leader>Lq", function() vim.lsp.diagnostic.set_loclist() end, },
      -- stylua: ignore
			{ "gI", function() vim.lsp.buf.code_action() end, },
      -- stylua: ignore
			{ "<leader>r", function() vim.lsp.buf.rename() end, desc = "Rename variable" },
      -- stylua: ignore
			{ "K", function() vim.lsp.buf.hover() end, },
    },

    dependencies = {
      { "folke/neoconf.nvim", cmd = "Neoconf", config = true },
      { "folke/neodev.nvim", opts = { experimental = { pathStrict = true } } },
      "williamboman/mason-lspconfig.nvim",
      {
        "hrsh7th/cmp-nvim-lsp",
      },
    },
    opts = {
      diagnostics = {
        underline = true,
        update_in_insert = false,
        virtual_text = { spacing = 4, source = "if_many", prefix = "●" },
        severity_sort = true,
        signs = {
          text = {
            [vim.diagnostic.severity.ERROR] = "!",
            [vim.diagnostic.severity.WARN] = "?",
            [vim.diagnostic.severity.HINT] = "!!",
            [vim.diagnostic.severity.INFO] = "I",
          },
        },
      },
      format = {
        formatting_options = nil,
        timeout_ms = nil,
      },
      capabilities = {},
      servers = {
        jsonls = require("plugins.lsp.jsonls"),
        lua_ls = {
          settings = {
            Lua = Constants.lua_ls.Lua,
          },
        },
        zls = require("plugins.lsp.zls"),
      },
      setup = {
        -- example to setup with typescript.nvim
        -- tsserver = function(_, opts)
        --   require("typescript").setup({ server = opts })
        --   return true
        -- end,
        -- Specify * to use this function as a fallback for any server
        -- ["*"] = function(server, opts) end,
      },
    },
    config = function(_, opts)
      vim.diagnostic.config(opts.diagnostics)

      local servers = opts.servers

      local hasCmp, cmpNvimLsp = pcall(require, "cmp_nvim_lsp")
      local capabilities = vim.tbl_deep_extend(
        "force",
        {},
        vim.lsp.protocol.make_client_capabilities(),
        hasCmp and cmpNvimLsp.default_capabilities() or {},
        opts.capabilities or {}
      )

      local function setup(server)
        local serverOpts = vim.tbl_deep_extend("force", {
          capabilities = vim.deepcopy(capabilities),
        }, servers[server] or {})

        local border = {
          { "┌", "FloatBorder" },

          { "─", "FloatBorder" },

          { "┐", "FloatBorder" },

          { "│", "FloatBorder" },

          { "┘", "FloatBorder" },

          { "─", "FloatBorder" },

          { "└", "FloatBorder" },

          { "│", "FloatBorder" },
        }

        local handlers = {
          ["textDocument/hover"] = vim.lsp.with(vim.lsp.handlers.hover, { border = border }),
          ["textDocument/signatureHelp"] = vim.lsp.with(
            vim.lsp.handlers.signature_help,
            { border = border }
          ),
        }

        serverOpts.handlers = handlers

        if opts.setup[server] then
          if opts.setup[server](server, serverOpts) then
            return
          end
        elseif opts.setup["*"] then
          if opts.setup["*"](server, serverOpts) then
            return
          end
        end

        require("lspconfig")[server].setup(serverOpts)
      end

      local hasMason, mlsp = pcall(require, "mason-lspconfig")
      local allMslpServers = {}

      if hasMason then
        allMslpServers =
          vim.tbl_keys(require("mason-lspconfig.mappings.server").lspconfig_to_package)
      end

      local ensureInstalled = {} ---@type string[]
      for server, serverOpts in pairs(servers) do
        if serverOpts then
          serverOpts = serverOpts == true and {} or serverOpts

          if serverOpts.mason == false or not vim.tbl_contains(allMslpServers, server) then
            vim.notify(server)

            setup(server)
          elseif serverOpts.enabled ~= false then
            ensureInstalled[#ensureInstalled + 1] = server
          end
        end
      end

      if hasMason then
        mlsp.setup({ ensure_installed = ensureInstalled, handlers = { setup } })
      end
    end,
  },
  -- ----------------------------------------------------------------------- }}}
  -- {{{ conform.nvim
  {
    "stevearc/conform.nvim",
    event = { "BufWritePre" },
    keys = {
      {
        "<leader>fr",
        function()
          require("conform").format()
        end,
        mode = { "x", "n", "v" },
        desc = "Format file or selection",
      },
    },
    opts = {
      formatters_by_ft = {
        lua = { "stylua" },
        javascript = { { "prettierd" } },
        typescript = { { "prettierd" } },
        vue = { { "prettierd" } },
      },
      log_level = vim.log.levels.DEBUG,
      format_on_save = {
        lsp_fallback = true,
      },
    },
  },
  -- }}}
  -- {{{ neodev.nvim
  { "folke/neodev.nvim", enabled = false },
  -- ----------------------------------------------------------------------- }}}
  -- {{{ neoconf.nvim
  { "folke/neoconf.nvim", enabled = false, cmd = "Neoconf", config = true },
  -- ----------------------------------------------------------------------- }}}
  -- {{{
  {
    "lervag/vimtex",
    lazy = false,
    init = function()
      vim.g.vimtex_view_method = "zathura"
    end,
  },
  -- }}}
}
