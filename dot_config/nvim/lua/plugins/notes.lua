return {
  {
    "nvim-neorg/neorg",
    ft = "norg",
    build = ":Neorg sync-parsers",
    event = "VeryLazy",
    cmd = "Neorg",
    keys = {
      { "<leader>ni", "<cmd>Neorg index<cr>", desc = "Index" },
      { "<leader>nj", "<cmd>Neorg journal today<cr>", desc = "Journal" },
      { "<leader>nr", "<cmd>Neorg return<cr>", desc = "Return" },
      { "<leader>ns", "<cmd>Neorg workspace scratch<cr>", desc = "Scratch workspace" },
      { "<leader>na", "<cmd>Neorg workspace authors<cr>", desc = "Authors workspace" },
      { "<leader>nn", "<cmd>Neorg workspace notes<cr>", desc = "Personal workspace" },
    },
    config = function()
      require("neorg").setup({
        load = {
          ["core.defaults"] = {},
          ["core.completion"] = { config = { engine = "nvim-cmp", name = "[Norg]" } },
          ["core.integrations.nvim-cmp"] = {},
          ["core.concealer"] = {
            config = {
              dim_code_blocks = {
                padding = { left = 4 },
              },
              icon_preset = "diamond",
            },
          },
          ["core.export"] = {},
          ["core.keybinds"] = {
            -- https://github.com/nvim-neorg/neorg/blob/main/lua/neorg/modules/core/keybinds/keybinds.lua
            config = {
              default_keybinds = true,
              neorg_leader = "n",
            },
          },
          ["core.dirman"] = {
            config = {
              workspaces = {
                notes = "~/Documents/notes/personal",
                authors = "~/Documents/notes/authors",
                scratch = "~/Documents/notes/scratch",
              },
            },
          },
        },
      })
    end,
  },
  { "alok/notational-fzf-vim" },
  { "junegunn/fzf" },
}
