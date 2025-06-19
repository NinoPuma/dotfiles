vim.cmd("set expandtab")
vim.cmd("set tabstop=2")
vim.cmd("set softtabstop=2")
vim.cmd("set shiftwidth=2")

--
--Keybinds
--leader = spacebar
--
vim.g.mapleader = " "

--
--lazy
--
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
	vim.fn.system({
		"git",
		"clone",
		"--filter=blob:none",
		"https://github.com/folke/lazy.nvim.git",
		"--branch=stable", -- latest stable release
		lazypath,
	})
end
vim.opt.rtp:prepend(lazypath)

--
--keys combinations
--
require("lazy").setup("plugins")
local builtin = require("telescope.builtin")
vim.keymap.set('n', '<C-p>', builtin.find_files, {})
--spacebar + fg to use grep
vim.keymap.set('n', '<leader>fg', builtin.live_grep, {})

--spacerbar + n to show files
vim.keymap.set('n', '<C-n>', ':Neotree filesystem reveal left<CR>', {})

--
--autoindent for certain programming languages etc
--
local config = require("nvim-treesitter.configs")
config.setup({
  ensure_installed = {"lua", "java", "json", "python", "swift"},
  hightlight = { enable = true },
  indent = { enable = true }, -- :wa
})

require("catppuccin").setup()
vim.cmd.colorscheme "catppuccin"
