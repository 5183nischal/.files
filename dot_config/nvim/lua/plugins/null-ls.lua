return {
  -- change null-ls config
  {
    "jose-elias-alvarez/null-ls.nvim",
    dependencies = { "mason.nvim" },
    event = { "BufReadPre", "BufNewFile" },
    opts = function()
      local null_ls = require("null-ls")
      local formatting = null_ls.builtins.formatting
      local diagnostics = null_ls.builtins.diagnostics

      null_ls.setup({
        -- debug = true, -- Turn on debug for :NullLsLog
        debug = false,
        -- diagnostics_format = "#{m} #{s}[#{c}]",
        sources = {
          -- list of supported sources:
          -- https://github.com/jose-elias-alvarez/null-ls.nvim/blob/main/doc/BUILTINS.md
          formatting.stylua,
          formatting.latexindent,
          formatting.isort,
          -- formatting.yafp.with({
          --   extra_args = function(params)
          --     return params
          --       and {
          --         "--style={indent_width:" .. vim.fn.shiftwidth() .. "}",
          --       }
          --   end,
          -- }),
          formatting.black.with({
            filetypes = { "python" },
            extra_args = { "--fast", "--line-length", "120" },
          }),
          diagnostics.ruff,
          -- diagnostics.vale,
          null_ls.builtins.code_actions.shellcheck,
          null_ls.builtins.hover.dictionary,
          null_ls.builtins.hover.printenv,
        },
      })
    end,
  },
}
