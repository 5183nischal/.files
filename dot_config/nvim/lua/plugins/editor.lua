return {
  --smooth
  {
    "karb94/neoscroll.nvim",
    config = function()
      require("neoscroll").setup({
        -- All these keys will be mapped to their corresponding default scrolling animation
        mappings = { "<C-u>", "<C-d>", "<C-b>", "<C-f>", "<C-y>", "<C-e>", "zt", "zz", "zb" },
        hide_cursor = true, -- Hide cursor while scrolling
        stop_eof = true, -- Stop at <EOF> when scrolling downwards
        respect_scrolloff = false, -- Stop scrolling when the cursor reaches the scrolloff margin of the file
        cursor_scrolls_alone = true, -- The cursor will keep on scrolling even if the window cannot scroll further
        easing_function = nil, -- Default easing function
        pre_hook = nil, -- Function to run before the scrolling animation starts
        post_hook = nil, -- Function to run after the scrolling animation ends
        performance_mode = false, -- Disable "Performance Mode" on all buffers.
      })
    end,
  },
  {
    "HampusHauffman/block.nvim",
    config = function() require("block").setup({}) end,
    event = "BufRead"
  },
  {
    "declancm/cinnamon.nvim",
    config = function() require("cinnamon").setup() end,
  },

  {
    "simrat39/symbols-outline.nvim",
    cmd = "SymbolsOutline",
    keys = { { "<leader>cs", "<cmd>SymbolsOutline<cr>", desc = "Symbols Outline" } },
    opts = {
      -- add your options that should be passed to the setup() function here
      position = "right",
    },
  },
  -- marks
  {
    "chentoast/marks.nvim",
    keys = {
      { "<leader>um", "<cmd>MarksToggleSigns<cr>", desc = "Toggle marks" },
    },
    event = "VeryLazy",
    config = true,
  },

  -- file explorer
  {
    "nvim-neo-tree/neo-tree.nvim",
    opts = {
      window = { width = 30, position = "right" },
      -- source_selector = { winbar = true },
    },
  },
  -- { "stevearc/oil.nvim", cmd = "Oil", opts = {} },
  {
    "stevearc/oil.nvim",
    cmd = "Oil",
    keys = { { "<leader>o", "<cmd>Oil<CR>", desc = "Oil file manager" } },
    opts = {
      columns = {
        "icon",
        { "mtime", highlight = "Comment", format = "%T %y-%m-%d" },
      },
      skip_confirm_for_simple_edits = true,
      view_options = {
        show_hidden = true,
      },
    },
  },
  {
    "nacro90/numb.nvim",
    event = "VeryLazy",
    opts = {
      show_numbers = false,
    },
  },

  { -- Undo tree
    "simnalamburt/vim-mundo",
    cmd = "MundoToggle",
    keys = { { "<leader>uu", "<cmd>MundoToggle<CR>", desc = "Undo" } },
  },

  {
    "echasnovski/mini.map",
    config = function()
      local map = require("mini.map")
      map.setup({
        symbols = {
          encode = require("mini.map").gen_encode_symbols.dot("4x2"),
        },
        integrations = {
          require("mini.map").gen_integration.builtin_search(),
          require("mini.map").gen_integration.gitsigns(),
          require("mini.map").gen_integration.diagnostic(),
        },
        window = {
          show_integration_count = false,
        },
      })
    end,
    keys = {
      { "<leader>mm", "<Cmd>lua MiniMap.toggle()<CR>", desc = "MiniMap" },
      { "<leader>mf", "<Cmd>lua MiniMap.toggle_focus()<CR>", desc = "MiniMap" },
      { "<leader>ms", "<Cmd>lua MiniMap.toggle_side()<CR>", desc = "MiniMap" },
    },
  },
  -- { "smjonas/live-command.nvim",
  --   opts = { commands = { Norm = { cmd = "norm" }, } }
  -- },

  {
    "folke/trouble.nvim",
    keys = {
      { "<leader>xx", "<cmd>TroubleToggle<CR>", desc = "Trouble Toggle" },
      { "<leader>xr", "<cmd>TroubleToggle lsp_references<cr>", desc = "References (Trouble)" },
      { "<leader>xf", "<cmd>TroubleToggle lsp_definitions<cr>", desc = "Definitions (Trouble)" },
      {
        "<leader>xd",
        "<cmd>TroubleToggle document_diagnostics<cr>",
        desc = "Diagnostics (Trouble)",
      },
      {
        "<leader>xw",
        "<cmd>TroubleToggle workspace_diagnostics<cr>",
        desc = "Workspace Diagnostics (Trouble)",
      },
      { "<leader>xq", "<cmd>TroubleToggle quickfix<cr>", desc = "QuickFix (Trouble)" },
      { "<leader>xl", "<cmd>TroubleToggle loclist<cr>", desc = "LocationList (Trouble)" },
    },
  },

  {
    "mattboehm/vim-unstack",
    init = function() vim.g.unstack_mapkey = "<leader>uS" end,
    keys = { { "<leader>uS", "<Cmd>Unstack<CR>", desc = "Un-stack trace" } },
  },
  {
    "echasnovski/mini.bracketed",
    event = "VeryLazy",
    opts = {
      comment = { suffix = "gc" }, -- ]c is for git/diff change
      indent = { options = { change_type = "diff" } },
      treesitter = { suffix = "n" },
    },
    config = function(_, opts) require("mini.bracketed").setup(opts) end,
  },
  { "RRethy/vim-illuminate", enabled = false },
  {
    "echasnovski/mini.cursorword",
    config = function(_, opts) require("mini.cursorword").setup(opts) end,
    event = "VeryLazy",
  },
  -- remoce noice lsp load
  {
    "folke/noice.nvim",
    opts = {
      lsp = {
        progress = {
          enabled = false,
        },
      },
    },
  },
}
