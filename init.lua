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
  { dir = bundlepath .. "toggleterm.nvim", lazy = true },
  { dir = bundlepath .. "nvim-treesitter", lazy = false },
  { dir = bundlepath .. "nvim-dap", lazy = true },
  { dir = bundlepath .. "nvim-nio", lazy = true },
  { dir = bundlepath .. "nvim-dap-ui", lazy = true }
})

require("dapui").setup()
local dap, dapui = require("dap"), require("dapui")

dap.adapters["pwa-node"] = {
  type = "server",
  host = "localhost",
  port = "${port}",
  executable = {
    command = "node",
    args = { bundlepath .. "js-debug/src/dapDebugServer.js", "${port}"},
  }
}

dap.configurations.javascript = {
  {
    type = "pwa-node",
    request = "launch",
    name = "Launch file",
    program = function()
      return vim.fn.input('Path to executable: ', vim.fn.getcwd() .. '/', 'file')
    end,
    cwd = "${workspaceFolder}",
    args = function()
      local args_string = vim.fn.input('Arguments: ')
      return vim.split(args_string, " ")
    end,
  },
}

dap.listeners.before.attach.dapui_config = function()
  dapui.open()
end
dap.listeners.before.launch.dapui_config = function()
  dapui.open()
end
dap.listeners.before.event_terminated.dapui_config = function()
  dapui.close()
end
dap.listeners.before.event_exited.dapui_config = function()
  dapui.close()
end

require("nvim-treesitter.configs").setup({
  highlight = { enable = true }
})

-- build parser from source if treesitter failed to download parser packages
-- require("nvim-treesitter.install").prefer_git = false
-- use windows default native c compiler. use x64 version of cl if neovim is x64
-- require 'nvim-treesitter.install'.compilers = { "cl" }

require("catppuccin").setup({
  styles = {
    conditionals = {}
  }
})

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
vim.api.nvim_set_keymap("n", "<leader>db", ":lua require('dap').toggle_breakpoint()<cr>", {silent = true, noremap = true})
vim.api.nvim_set_keymap("n", "<leader>dc", ":lua require('dap').continue()<cr>", {silent = true, noremap = true})
vim.api.nvim_set_keymap("n", "<leader>ds", ":lua require('dap').step_over()<cr>", {silent = true, noremap = true})
vim.api.nvim_set_keymap("n", "<leader>di", ":lua require('dap').step_into()<cr>", {silent = true, noremap = true})

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
