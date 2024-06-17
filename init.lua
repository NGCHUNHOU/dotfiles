-- init.lua windows 7/10 location: /c/Users/knxuser/AppData/Local/nvim/init.lua
-- init.lua unix location: ~/.config/nvim/init.lua
-- rc order: plugin load -> lua script -> vim script
local lazypath = os.getenv("VIM") .. "/runtime/lazy.nvim"
local bundlepath =  os.getenv("VIM") .. "/runtime/bundle/"
vim.opt.rtp:prepend(lazypath)

require("lazy").setup({
  { dir = bundlepath .. "catppuccin", lazy = true },
  { dir = bundlepath .. "lightline.vim", lazy = false },
  { dir = bundlepath .. "plenary.nvim", lazy = true },
  { dir = bundlepath .. "nui.nvim", lazy = true },
  { dir = bundlepath .. "neo-tree.nvim", lazy = true },
  { dir = bundlepath .. "telescope.nvim", lazy = false },
  { dir = bundlepath .. "toggleterm.nvim", lazy = true }
})

require("catppuccin").setup()

vim.g.lightline = {colorscheme = "catppuccin"}

require("neo-tree").setup({
  window = {
    mappings = {
      ["h"] = {"toggle_node", nowait = false},
      ["l"] = "open"
    }
  }
})

vim.api.nvim_set_keymap("n", "<C-h>", ":Neotree<cr>", {silent = true, noremap = true})

if package.config:sub(1,1) == "\\" then
  vim.o.shell = "C:/Program Files/Git/bin/bash.exe"
  vim.o.shellcmdflag = "-s"
end

require("toggleterm").setup({
  open_mapping = [[<C-\>]],
  direction = 'float'
})

vim.cmd([[
set number
set autochdir
set splitbelow
set splitright
set wildmode=longest,list,full
set wildmenu
set tabstop=2
set shiftwidth=2
set expandtab
set title
set clipboard=unnamed

colorscheme catppuccin-mocha
set background=dark

nnoremap <leader>ff <cmd>Telescope find_files<cr>
nnoremap <leader>fg <cmd>Telescope live_grep<cr>
nnoremap <leader>fb <cmd>Telescope buffers<cr>
nnoremap <leader>fh <cmd>Telescope help_tags<cr>
nnoremap <leader>fo <cmd>Telescope oldfiles<cr>
nnoremap <F11> <C-]>
nnoremap <F12> <C-T>
]])
