-- init.lua windows 7/10 location: /c/Users/knxuser/AppData/Local/nvim/init.lua
vim.cmd("execute pathogen#infect('$VIM/runtime/bundle/{}')")
require("gruvbox").setup({
  undercurl = true,
  underline = true,
  bold = true,
  italic = {
    strings = false,
    comments = true,
    operators = false,
    folds = true,
  },
  strikethrough = true,
  invert_selection = false,
  invert_signs = false,
  invert_tabline = false,
  invert_intend_guides = false,
  inverse = true, -- invert background for search, diffs, statuslines and errors
  contrast = "", -- can be "hard", "soft" or empty string
  palette_overrides = {},
  overrides = {},
  dim_inactive = false,
  transparent_mode = false,
})

vim.g.loaded_netrw = 1
vim.g.loaded_netrwPlugin = 1
vim.opt.termguicolors = true

require("nvim-tree").setup()
vim.cmd([[
set number
set splitbelow
set splitright
set wildmode=longest,list,full
set wildmenu
set tabstop=4
set shiftwidth=4
set title
set clipboard=unnamed

set background=dark
colorscheme gruvbox
let g:lightline = { 'colorscheme': 'gruvbox' }

nnoremap <leader>ff <cmd>Telescope find_files<cr>
nnoremap <leader>fg <cmd>Telescope live_grep<cr>
nnoremap <leader>fb <cmd>Telescope buffers<cr>
nnoremap <leader>fh <cmd>Telescope help_tags<cr>
nnoremap <F11> <C-]>
nnoremap <F12> <C-T>
nnoremap <leader>e <cmd>NvimTreeToggle<cr>

set shell=\"C:/Program\ Files/Git/bin/bash.exe"\
nnoremap <leader>t <cmd>split \| terminal<cr>i
]])
