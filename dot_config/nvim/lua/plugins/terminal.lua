return {
  {
    "mtikekar/nvim-send-to-term",
    enabled = false,
    cmd = { "SendTo", "SendHere" },
    init = function()
      vim.g.send_disable_mapping = true -- dont use default
      local function send_to_wez(opts)
        local pane_id = opts.args
        local function send_to_pane(lines)
          lines = table.concat(lines, "\n"):gsub('"', '\\"') -- Escape double quote since it's used to wrap lines
          os.execute("wezterm cli send-text --pane-id=" .. pane_id .. ' "' .. lines .. '"')
          os.execute("wezterm cli send-text --pane-id=" .. pane_id .. ' --no-paste "\r\r"')
        end
        vim.g.send_target = { send = send_to_pane }
      end
      vim.api.nvim_create_user_command("SendToWez", send_to_wez, { nargs = 1 })
      local function send_to_jupyter(opts)
        if vim.b.jupyter_attached == nil then
          vim.notify("No jupyter kernel attached")
          return
        end
        vim.g.send_target = {
          send = function(lines)
            lines = table.concat(lines, "\n")
            vim.fn.JupyterExecute(lines)
          end,
        }
      end
      vim.api.nvim_create_user_command("SendToJupyter", send_to_jupyter, {})
    end,
    -- keys = {
    --   { "<CR>",   "<Plug>Send",     desc = "Send", mode = { "n", "v" } },
    --   { "<S-CR>", "vap<Plug>Send}", desc = "Send", mode = "n" },
    -- },
  },
  {
    "nikvdp/neomux",
    enabled = false,
    event = "VeryLazy",
    init = function()
      vim.g.neomux_start_term_map = ""
      vim.g.neomux_win_num_status = ""
      vim.g.neomux_winswap_map_prefix = "<leader>ws"
      vim.g.neomux_term_sizefix_map = "<leader>wf"
      vim.g.neomux_dont_fix_term_ctrlw_map = 1
      vim.g.neomux_no_term_autoinsert = 1
    end,
  },
  {
    "voldikss/vim-floaterm",
    enabled = false,
    keys = "<Home>",
    init = function()
      vim.g.floaterm_keymap_next = "<End>" -- Hyper+o
      vim.g.floaterm_keymap_prev = "<S-End>" -- Hyper+Command+o
      vim.g.floaterm_keymap_new = "<S-Home>" -- Hyper+Command+i
      vim.g.floaterm_keymap_toggle = "<Home>" -- Hyper+i
      vim.g.floaterm_position = "center"
      vim.g.floaterm_width = 0.9
      vim.g.floaterm_height = 0.9
    end,
  },
  {
    "chomosuke/term-edit.nvim",
    event = "TermOpen",
    version = "1.*",
  },
  -- from old setup
  {
    "akinsho/toggleterm.nvim",
    cmd = "ToggleTerm",
    version = false,
    opts = function() require("toggleterm").setup() end,
    keys = {
      {
        "<leader>tf",
        "<cmd>ToggleTerm direction=float<cr>",
        desc = "Terminal (float)",
      },
      {
        "<leader>tt",
        "<cmd>ToggleTerm size=15 direction=horizontal<cr>",
        desc = "Terminal (horizontal)",
      },
      {
        "<leader>tv",
        "<cmd>ToggleTerm size=80 direction=vertical<cr>",
        desc = "Terminal (vertical)",
      },
    },
  },
  {
    "lmburns/lf.nvim",
    config = function()
      -- This feature will not work if the plugin is lazy-loaded
      vim.g.lf_netrw = 1
      require("lf").setup({
        escape_quit = true,
        border = "rounded",
        -- highlights = { FloatBorder = { guifg = require("gruvbox-material.palette").colors.magenta } }
      })
    end,
    keys = {
      {
        "<leader>fm",
        ":Lf<CR>",
        desc = "LF file manager",
      },
    },
    requires = { "plenary.nvim", "toggleterm.nvim" },
  },
  -- {
  --   "lvim-tech/lvim-fm",
  --   dependencies = { "lvim-tech/lvim-shell" },
  --   config = function()
  --     require("lvim-fm").setup({
  --       -- your configuration comes here
  --       -- or leave it empty to use the default settings
  --       -- refer to the configuration section below
  --     })
  --   end,
  --   keys = {
  --     {
  --       "<leader>tl",
  --       "<cmd>LvimFileManager<cr>",
  --       desc = "Terminal (lvim)",
  --     },
  --   }
  -- },
}
