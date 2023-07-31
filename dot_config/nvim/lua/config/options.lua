-- Options are automatically loaded before lazy.nvim startup
-- Default options that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/options.lua
-- Add any additional options here

local g, o, opt = vim.g, vim.o, vim.opt

g.mapleader = " "
g.maplocalleader = " "
g.transparent_enabled = true

o.clipboard = "" -- use gy and gp to interact with osc52-system clipbard
o.splitright = true

o.scrolloff = 999
o.breakindent = true -- Indent wrapped lines to match line start
o.showbreak = "|>" -- character show in front of wrapped lines
-- o.breakindentopt = "shift:-2" -- dedent showbreak
o.linebreak = true -- Wrap long lines at 'breakat' (if 'wrap' is set)

o.number = true
o.relativenumber = true
o.numberwidth = 3
o.cursorline = true

o.ignorecase = true -- Ignore case when searching (use `\C` to force not doing that)
o.incsearch = true -- Show search results while typing
o.infercase = true -- Infer letter cases for a richer built-in keyword completion
o.smartcase = true -- Don't ignore case when searching if pattern has upper case
o.smartindent = true -- Make indenting smart

o.virtualedit = "block,onemore" -- Allow going past the end of line in visual block mode
o.guifont = "JetBrainsMono Nerd Font Mono Medium:h17"

o.list = false
o.listchars = "tab:->,extends:…,precedes:…,nbsp:␣,eol:↲" -- Define which helper symbols to show
o.fillchars = [[eob: ,fold: ,foldopen:,foldsep: ,foldclose:]]

opt.path:append("**")
opt.shortmess:append("s")
opt.conceallevel = 2

g.jukit_output_new_os_window = 1
g.jukit_outhist_new_os_window = 1
-- g.jukit_notebook_viewer = "code"
-- g.jukit_highlight_markers = 1
-- vim.cmd[[
-- let g:jukit_layout = {
--     \'split': 'horizontal',
--     \'p1': 0.7,
--     \'val': [
--         \'file_content',
--         \{
--             \'split': 'vertical',
--             \'p1': 0.6,
--             \'val': ['output', 'output_history']
--         \}
--     \]
-- \}
-- ]]

g.gruvbox_material_ui_contrast = "high"
g.gruvbox_material_transparent_background = 1
g.gruvbox_material_background = "high"
-- g.gruvbox_material_background = 'hard'
g.gruvbox_material_enable_italic = 1
g.gruvbox_material_disable_italic_comment = 0
g.gruvbox_material_menu_selection_background = "green"
g.gruvbox_material_palette = "material"
g.gruvbox_material_sign_column_background = "none"

g.nv_search_paths = { "~/Documents/notes/", "~/Documents/info and coding in the brain/" }
g.AngryReviewerEnglish = "american"

g.vimtex_context_pdf_viewer = "sioyek"
g.vimtex_view_method = "sioyek"
g.vimtex_view_sioyek_options = "--reuse-window"
g.vimtex_syntax_conceal = {
      accents = 1,
      cites = 1,
      fancy = 0,
      greek = 0,
      math_bounds = 0,
      math_delimiters = 1,
      math_fracs = 0,
      math_super_sub = 0,
      math_symbols = 0,
      sections = 1,
      styles = 0,
    }
g.vimtex_imaps_enabled = 0
g.vimtex_compiler_silent = 1
g.vimtex_doc_handlers = { "vimtex#doc#handlers#texdoc" }
g.vimtex_echo_verbose_input = 0
g.vimtex_format_enabled = 1
g.vimtex_syntax_enabled = 1
-- g.vimtex_syntax_conceal_disable = 1
g.vimtex_view_forward_search_on_start = 1
g.vimtex_imaps_enabled = 0
g.vimtex_quickfix_open_on_warning = 0
g.vimtex_delim_toggle_mod_list = {
  { "\\left", "\\right" },
  { "\\big", "\\big" },
}
g.vimtex_quickfix_mode = 0
g.vimtex_quickfix_ignore_filters = {
  "Underfull \\hbox",
  "Overfull \\hbox",
  "Underfull \\vbox",
  "Overfull \\vbox",
}
