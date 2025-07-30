-- init.lua windows 7/10 location: /c/Users/knxuser/AppData/Local/nvim/init.lua
-- init.lua unix location: ~/.config/nvim/init.lua
-- rc order: plugin load -> lua script -> vim script
if vim.fn.has("win32") == 1 and vim.fn.executable("bash") == 1 then
  vim.o.shell = '"C:\\Program Files\\Git\\bin\\bash.exe"'
  vim.o.shellcmdflag = "-c"
  vim.o.shellquote = ''
  vim.o.shellxquote = ''
  vim.o.shellslash = true
  vim.o.shellxescape = ''
end

local lazypath = os.getenv("VIM") .. "/runtime/bundle/lazy.nvim"
local bundlepath =  os.getenv("VIM") .. "/runtime/bundle/"
vim.opt.rtp:prepend(lazypath)

require("lazy").setup({
  { dir = bundlepath .. "catppuccin", lazy = true },
  { dir = bundlepath .. "lightline.vim", lazy = false },
  { dir = bundlepath .. "oil.nvim", lazy = true },
  { dir = bundlepath .. "telescope.nvim", lazy = false, dependencies = {{ dir = bundlepath .. "plenary.nvim", lazy = true }}},
  { dir = bundlepath .. "toggleterm.nvim", lazy = true },
  { dir = bundlepath .. "nvim-treesitter", lazy = false },
  { dir = bundlepath .. "nvim-dap-ui", lazy = true, dependencies = {{ dir = bundlepath .. "nvim-nio", lazy = true }, { dir = bundlepath .. "nvim-dap", lazy = true }}},
  { dir = bundlepath .. "vim-dadbod-ui", lazy = true, cmd = {"DBUI","DBUIToggle","DBUIAddConnection","DBUIFindBuffer"}, dependencies = {{dir = bundlepath .. "vim-dadbod", lazy = true}}}
})

require("dapui").setup({
  controls = {
    element = "repl",
    enabled = true,
    icons = {
      disconnect = "disconnect",
      pause = "pause",
      play = "continue",
      run_last = "run_last",
      step_back = "step_back",
      step_into = "step_into",
      step_out = "step_out",
      step_over = "step_over",
      terminate = "stop"
    }
  },
  layouts = { {
    elements = { {
      id = "repl",
      size = 0.6
    }, {
      id = "watches",
      size = 0.25
    }, {
      id = "scopes",
      size = 0.1
    }, {
      id = "stacks",
      size = 0.1
    }
  },
    position = "right",
    size = 90
  } }
})

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

dap.adapters.python = function(cb, config)
  if config.request == 'attach' then
    ---@diagnostic disable-next-line: undefined-field
    local port = (config.connect or config).port
    ---@diagnostic disable-next-line: undefined-field
    local host = (config.connect or config).host or '127.0.0.1'
    cb({
      type = 'server',
      port = assert(port, '`connect.port` is required for a python `attach` configuration'),
      host = host,
      options = {
        source_filetype = 'python',
      },
    })
  else
    cb({
      type = 'executable',
      command = 'D:\\winapps\\apps\\python\\3.9.6\\python.exe',
      args = { '-m', 'debugpy.adapter' },
      options = {
        source_filetype = 'python',
      },
    })
  end
end

dap.configurations.python = {
  {
    type = 'python',
    request = 'launch',
    name = "Launch file",
    program = function()
      return vim.fn.input('Path to executable: ', vim.fn.getcwd() .. '/', 'file')
    end,
    pythonPath = "D:\\winapps\\apps\\python\\3.9.6\\python.exe",
    args = function()
      local args_string = vim.fn.input('Arguments: ')
      return vim.split(args_string, " ")
    end,
  },
}

dap.adapters.lldb = {
  type = 'executable',
  command = 'D:\\winapps\\apps\\llvm-mingw\\bin\\lldb-vscode.exe',
  name = 'lldb'
}

dap.configurations.cpp = {
  {
    name = 'Launch',
    type = 'lldb',
    request = 'launch',
    program = function()
      return vim.fn.input('Path to executable: ', vim.fn.getcwd() .. '/', 'file')
    end,
    cwd = '${workspaceFolder}',
    stopOnEntry = false,
    args = function()
      local args_string = vim.fn.input('Arguments: ')
      return vim.split(args_string, " ")
    end,
  }
}

dap.listeners.before.attach.dapui_config = function()
  dapui.open()
  vim.cmd("wincmd j")
end
dap.listeners.before.launch.dapui_config = function()
  dapui.open()
  vim.cmd("wincmd j")
end
dap.listeners.before.event_terminated.dapui_config = function()
  dapui.close()
end
dap.listeners.before.event_exited.dapui_config = function()
  dapui.close()
end

-- require("nvim-treesitter.configs").setup({
--   highlight = { enable = true }
-- })

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

require("oil").setup()

vim.keymap.set('n', '<F4>', function() dap.toggle_breakpoint() end)
vim.keymap.set('n', '<F5>', function() dap.continue() end)
vim.keymap.set('n', '<F6>', function() dap.step_over() end)
vim.keymap.set('n', '<F7>', function() dap.step_into() end)
vim.keymap.set('n', '<F8>', function() dap.step_out() end)
vim.keymap.set('n', '<F9>', function() dap.terminate() end)

function set_toggleterm_keymaps()
  local opts = {buffer = 0}
  vim.keymap.set('t', '<esc>', [[<C-\><C-n>]], opts)
end
vim.cmd('autocmd! TermOpen term://*toggleterm#* lua set_toggleterm_keymaps()')

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
nnoremap <leader>fm <cmd>Oil<cr>
nnoremap <F11> <C-]>
nnoremap <F12> <C-T>
]])
