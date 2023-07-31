
if true then return {} end

return {
  "hrsh7th/nvim-cmp",
  event = { "InsertEnter", "CmdlineEnter" },
  opts = function(_, opts)
    local luasnip = require("luasnip")
    local cmp = require("cmp")
    local compare = require("cmp.config.compare")

    opts.completion = { completeopt = "menu,menuone,noselect" }
    opts.window = {
      completion = {
        col_offset = -2, -- to align text when 2 icons are prepended
      },
    }
    opts.view = { entries = { name = "custom", selection_order = "near_cursor" } }

    opts.formatting = {
      fields = { "kind", "abbr", "menu" },
      format = function(entry, item)
        local kind_icons = require("lazyvim.config").icons.kinds
        local source_icons = {
          nvim_lsp = "",
          luasnip = "",
          treesitter = "",
          tags = "",
          buffer = "",
          fuzzy_buffer = "󱔘",
          path = "",
          fuzzy_path = "󰉓",
          omni = "",
          copilot = "",
          cmp_tabnine = "󰌒",
          rg = "",
          cmdline = "",
          cmdline_history = "",
          jupyter = "",
        }
        item.menu = source_icons[entry.source.name] or entry.source.name
        item.menu = item.menu .. " " .. item.kind
        item.kind = kind_icons[item.kind]:sub(1, -2) or " "
        return item
      end,
    }
    opts.sources = cmp.config.sources({
      { name = "jupyter", priority = 750 },
      { name = "nvim_lsp" },
      { name = "luasnip" },
      -- { name = "buffer", keyword_length = 5 },
      {
        name = "fuzzy_buffer",
        keyword_length = 5, -- all buffers
        option = { get_bufnrs = vim.api.nvim_list_bufs },
      },
      { name = "fuzzy_path" },
      { name = "copilot", keyword_length = 15 },
    })
    opts.sorting = {
      priority_weight = 2,
      comparators = {
        require("copilot_cmp.comparators").prioritize,
        require("copilot_cmp.comparators").score,
        require("cmp_fuzzy_path.compare"),
        require("cmp_fuzzy_buffer.compare"),
        compare.offset,
        compare.exact,
        compare.score,
        require("cmp-under-comparator").under,
        compare.recently_used,
        compare.kind,
        compare.sort_text,
        compare.length,
        compare.order,
      },
    }
  end,

  config = function(_, opts)
    local cmp = require("cmp")
    cmp.setup(opts) -- normal completion
    cmp.setup.cmdline({ "/", "?" }, {
      mapping = cmp.mapping.preset.cmdline(),
      sources = {
        -- { name = "treesitter" },
        { name = "fuzzy_buffer" },
      },
    })

    cmp.setup.cmdline(":", {
      mapping = cmp.mapping.preset.cmdline(),
      sources = cmp.config.sources({
        { name = "cmdline" },
        { name = "cmdline_history" },
        { name = "fuzzy_path" },
      }),
    })
  end,
  dependencies = {
    {
      "L3MON4D3/LuaSnip",
      keys = function() return {} end, -- override LazyVim to configure suptertab
      config = function()
        -- require("luasnip.loaders.from_vscode").lazy_load()
        -- require("luasnip.loaders.from_snipmate").lazy_load()
      end,
    },
    "saadparwaiz1/cmp_luasnip",
    "lukas-reineke/cmp-under-comparator",
    "hrsh7th/cmp-nvim-lsp",
    -- "hrsh7th/cmp-nvim-lsp-document-symbol", -- For / search command
    "hrsh7th/cmp-buffer",
    -- "hrsh7th/cmp-emoji",
    "hrsh7th/cmp-cmdline",
    "dmitmel/cmp-cmdline-history",
    -- "ray-x/cmp-treesitter",
    -- "quangnguyen30192/cmp-nvim-tags",

    "tzachar/fuzzy.nvim",
    "tzachar/cmp-fuzzy-path",
    "tzachar/cmp-fuzzy-buffer",
    -- 'lukas-reineke/cmp-rg',

    -- {'tzachar/cmp-tabnine', build='./install.sh' },
    {
      "zbirenbaum/copilot-cmp",
      opts = {},
      init = function() vim.api.nvim_set_hl(0, "CmpItemKindCopilot", { fg = "#6CC644" }) end,
      dependencies = { "zbirenbaum/copilot.lua", opts = {} },
    },
  },
}
