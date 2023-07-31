return {
  -- "AckslD/swenv.nvim",
  {
    "nvim-lspconfig",
    opts = {
      ---@type lspconfig.options
      servers = {
        pyright = {
          -- disable hint, which are covered by ruff-lsp
          -- capabilities = (function()
          --   local capabilities = vim.lsp.protocol.make_client_capabilities()
          --   capabilities.textDocument.publishDiagnostics.tagSupport.valueSet = { 2 }
          --   return capabilities
          -- end)(),
          settings = {
            pyright = { disableOrganizeImports = true },
            python = {
              analysis = {
                diagnosticSeverityOverrides = { reportGeneralTypeIssues = "information" },
                useLibraryCodeForTypes = true,
              },
            },
          },
        },
        ruff_lsp = {
          on_attach = function(client, _) client.server_capabilities.hoverProvider = false end,
          init_options = {
            settings = {
              args = {
                "--extend-select",
                "W,UP,B,A,T10,ICN,G,SIM,PD,PL,NPY",
                "--ignore",
                "E501,W291,PLR0913",
              },
            },
          },
        },
      },
    },
  },

  { -- semantic hightlight
    "wookayin/semshi",
    ft = "python",
    build = ":UpdateRemotePlugins",
    init = function()
      vim.g["semshi#error_sign"] = false
      vim.g["semshi#simplify_markup"] = false
      vim.g["semshi#mark_selected_nodes"] = false
      vim.g["semshi#update_delay_factor"] = 0.001
    end,
  },
  {
    "goerz/jupytext.vim",
    event = "BufAdd *.ipynb",
    init = function() vim.g.jupytext_fmt = "py" end,
  },
  {
    "lkhphuc/jupyter-kernel.nvim",
    opts = { timeout = 0.5 },
    build = ":UpdateRemotePlugins",
    cmd = "JupyterAttach",
    keys = { { "<leader>k", "<Cmd>JupyterInspect<CR>", desc = "Inspect object in kernel" } },
  },
  {
    "michaelb/sniprun",
    build = "bash ./install.sh",
    event = "BufEnter *.py",
    config = function()
      -- code
      require("sniprun").setup({
        selected_interpreters = { "Python3_fifo" },
        repl_enable = { "Python3_fifo" },
        repl_disable = {}, -- " disable REPL-like behavior for the given interpreters
        interpreter_options = {}, -- " intepreter-specific options, consult docs / :SnipInfo <name>
        -- " you can combo different display modes as desired
        display = {
          -- "TempFloatingWindowOk", -- display ok results in the floating window
          "NvimNotifyErr", -- display err results with the nvim-notify plugin
          -- "Classic", -- display results in the command line"
          "VirtualText", -- display results in virtual text"
          -- "LongTempFloatingWindow", -- display results in the long floating window
          -- "Terminal" -- display results in a vertical split
          -- "TerminalWithCode" -- display results and code history in a vertical split
        },
        display_options = {
          terminal_width = 45,
          notification_timeout = 5000,
        },
        -- " miscellaneous compatibility/adjustement settings
        inline_messages = 0, -- " inline_message (0/1) is a one-line way to display messages
        -- " to workaround sniprun not being able to display anything
        borders = "single", -- " display borders around floating windows
        -- " possible values are 'none', 'single', 'double', or 'shadow'
        snipruncolors = {
          SniprunVirtualTextOk = {
            bg = "#1d2021",
            fg = "#ddc7a1",
            ctermbg = "Cyan",
            cterfg = "Black",
          },
          -- SniprunFloatingWinOk = { fg = "#66eeff", ctermfg = "Cyan" },
          -- SniprunVirtualTextErr = { bg = "#881515", fg = "#000000", ctermbg = "DarkRed", cterfg = "Black" },
          -- SniprunFloatingWinErr = { fg = "#881515", ctermfg = "DarkRed" },
        },
      })
    end,
  },
  {
    "luk400/vim-jukit",
    ft = { "python", "json", "quarto" },
    keys = {
      { "<leader>jo", ":call jukit#splits#output()<cr>", desc = "Open viewing terminal" },
      { "<leader>jh", ":call jukit#splits#history()<cr>", desc = "Open history terminal" },
      { "<leader>jc", ":call jukit#splits#close_output_and_history(1)<cr>", desc = "close all" },
      { "<leader>cD", ":call jukit#cells#delete()<cr>", desc = "Delete cell" },
      { "<leader>jj", ":call jukit#cells#jump_to_next_cell()<cr>", desc = "move down a cell" },
      { "<leader>jk", ":call jukit#cells#jump_to_previous_cell()<cr>", desc = "move up a cell" },
    },
  },
  {
    "WhiteBlackGoose/magma-nvim-goose",
    build = ":UpdateRemotePlugins",
    cmd = "MagmaInit",
    keys = {
      { "<leader>r", "<cmd>MagmaEvaluateOperator<CR>", expr = true },
      { "<leader>rr", "<cmd>MagmaEvaluateLine<CR>" },
      { "<leader>rc", "<cmd>MagmaReevaluateCell<CR>" },
      { "<leader>rd", "<cmd>MagmaDelete<CR>" },
      { "<leader>ro", "<cmd>MagmaShowOutput<CR>" },
      { "<leader>r", ":<C-u>MagmaEvaluateVisual<CR>", mode = "v" },
    },
  },
}
