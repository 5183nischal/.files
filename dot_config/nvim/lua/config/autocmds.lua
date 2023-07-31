-- Autocmds are automatically loaded on the VeryLazy event
-- Default autocmds that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/autocmds.lua
-- Add any additional autocmds here

local augroup = vim.api.nvim_create_augroup
local autocmd = vim.api.nvim_create_autocmd

local highlight_yank = augroup('HighlightYank', { clear = true })
autocmd('TextYankPost', {
	group = highlight_yank,
  pattern = { '*' },
	callback = function()
		vim.highlight.on_yank({
			timeout = 40,
		})
	end,
})

local trim_whitespace = augroup('TrimWhitespace', { clear = true })
autocmd({ 'BufWritePre' }, {
	group = trim_whitespace,
  pattern = { '*' },
	command = [[
	let currPos = getpos(".")
	%s/\s\+$//e
	%s/\n\+\%$//e
	cal cursor(currPos[1], currPos[2])
	]],
})


-- Disable automatic commenting on newline
autocmd({ "FileType" }, {
  pattern = { "*" },
  command = "setlocal formatoptions-=cro",
})


-- Disable automatic diagnosics for python
-- vim.cmd [[
--   autocmd BufEnter *.py :lua vim.diagnostic.disable()
-- ]]

-- tex
autocmd('FileType', {
  pattern = { 'tex' },
  callback = function()
    vim.bo.tabstop = 4
    vim.bo.softtabstop = 4
    vim.bo.shiftwidth = 4
    vim.bo.expandtab = true
    vim.o.smarttab = true
    vim.bo.autoindent = true
    vim.bo.smartindent = true
    vim.bo.textwidth = 0
    vim.wo.colorcolumn = ""
    vim.wo.linebreak = true
    vim.wo.wrap = true
    vim.o.breakindent = true
    vim.wo.conceallevel = 0
  end,
})

-- semi-transparent cursorline

-- vim.cmd('highlight CursorLine ctermbg=none guibg=#0f0f0f gui=NONE cterm=NONE')
-- vim.cmd('augroup CursorLineTransparency')
-- vim.cmd('autocmd!')
-- vim.cmd('autocmd ColorScheme * highlight CursorLine guibg=#0f0f0f ctermbg=none')
-- vim.cmd('augroup END')
