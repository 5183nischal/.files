return {

  { "lervag/vimtex", lazy = false },
  {
    "iurimateus/luasnip-latex-snippets.nvim",
    dependencies = { "L3MON4D3/LuaSnip", "lervag/vimtex" },
    config = function()
      require('luasnip-latex-snippets').setup()
    end,
    ft = { "tex", "markdown" },
  },
  {
    "L3MON4D3/LuaSnip",
    event = { "InsertEnter" },
    config = function()
      require("luasnip").setup({
        history = true,
        store_selection_keys = "<tab>",
        update_events = "TextChanged,TextChangedI",
        region_check_events = "InsertEnter",
        delete_check_events = "TextChanged",
        enable_autosnippets = true,
      })

      vim.cmd [[
      imap <silent><expr> <tab> luasnip#expand_or_jumpable() ? "<Plug>luasnip-expand-or-jump" : "<tab>"
      smap <silent><expr> <tab> luasnip#jumpable(1) ? "<Plug>luasnip-jump-next" : "<tab>"
      imap <silent><expr> <s-tab> luasnip#jumpable(-1) ? "<Plug>luasnip-jump-prev" : "<s-tab>"
      smap <silent><expr> <s-tab> luasnip#jumpable(-1) ? "<Plug>luasnip-jump-prev" : "<s-tab>"
      ]]

      require("luasnip.loaders.from_lua").load({ paths = "~/.config/nvim/LuaSnip/" })
    end,
  },
  { "anufrievroman/vim-angry-reviewer", event = "VeryLazy" },
  {
    "echasnovski/mini.pairs",
    enabled = false,
  },
  {
    "nvim-treesitter/nvim-treesitter",
    config = function()
      require("nvim-treesitter.configs").setup({
        highlight = {
          enable = true,
          disable = { "latex" },
        },
      })
    end,
  },


  -- Improved ltex integration, supporting code actions
  { "barreiroleo/ltex-extra.nvim" },

  -- add various LSP to lspconfig
  {
    "neovim/nvim-lspconfig",
    version = false,
    opts = {
      -- suppress virtual text
      -- diagnostics = {
      --   virtual_text = false,
      -- },
      -- https://github.com/neovim/nvim-lspconfig/blob/master/doc/server_configurations.md
      servers = {
        -- use LanguageTool via ltex for spell checking
        ltex = {
          filetypes = {
            "bib",
            "latex",
            "tex",
            "markdown",
            "pandoc",
            "text",
          },
          settings = {
            -- https://valentjn.github.io/ltex/settings.html
            ltex = {
              language = "en-US",
              additionalRules = {
                enablePickyRules = true,
                motherTongue = "en",
                -- languageModel = '~/en/',
              },
              -- https://community.languagetool.org/rule/list?lang=en
              disabledRules = {
                ["en-US"] = { "TOO_LONG_SENTENCE", "OXFORD_SPELLING_Z_NOT_S", "DASH_RULE" },
                fr = { "APOS_TYP", "FRENCH_WHITESPACE", "FR_SPELLING_RULE", "COMMA_PARENTHESIS_WHITESPACE" },
              },
            },
          },
        },
      },
      setup = {
        -- integrate ltex_extra with lazyvim
        -- https://github.com/LazyVim/LazyVim/discussions/403
        ltex = function(_, opts)
          vim.api.nvim_create_autocmd("LspAttach", {
            callback = function(args)
              local client = vim.lsp.get_client_by_id(args.data.client_id)
              if client.name == "ltex" then
                require("ltex_extra").setup({
                  load_langs = { "en-US" },                    -- languages for witch dictionaries will be loaded
                  init_check = true,                           -- whether to load dictionaries on startup
                  path = vim.fn.stdpath("config") .. "/spell", -- path to store dictionaries.
                  log_level = "none",                          -- "none", "trace", "debug", "info", "warn", "error", "fatal"
                })
              end
            end,
          })
        end,
      },
    },
  },
}
