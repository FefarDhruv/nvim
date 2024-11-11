-- Bootstrap lazy.nvim
vim.g.mapleader = " "
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not (vim.uv or vim.loop).fs_stat(lazypath) then
  local lazyrepo = "https://github.com/folke/lazy.nvim.git"
  local out = vim.fn.system({ "git", "clone", "--filter=blob:none", "--branch=stable", lazyrepo, lazypath })
  if vim.v.shell_error ~= 0 then
    vim.api.nvim_echo({
      { "Failed to clone lazy.nvim:\n", "ErrorMsg" },
      { out, "WarningMsg" },
      { "\nPress any key to exit..." },
    }, true, {})
    vim.fn.getchar()
    os.exit(1)
  end
end
vim.opt.rtp:prepend(lazypath)

-- Setup lazy.nvim
require("lazy").setup({
  spec = {
    -- Include your plugins here
    { import = "plugins" },

    -- Treesitter configuration
    {
      "nvim-treesitter/nvim-treesitter",
      build = ":TSUpdate",
      config = function()
        local configs = require("nvim-treesitter.configs")
        configs.setup({
          ensure_installed = { "c", "lua", "vim", "vimdoc", "query", "elixir", "heex", "javascript", "html" , "python" , "ninja" , "rst"},
          sync_install = false,
          auto_install = true , 
          highlight = { enable = true },
          indent = { enable = true },
        })
      end,
    },
    
    -- Catppuccin colorscheme (assuming you want to include this)
    {
      "catppuccin/nvim",
      name = "catppuccin",
      priority = 1000,
    },
  },
  
  -- Additional lazy.nvim configurations
  install = { colorscheme = { "habamax" } },
  checker = { enabled = true },
})

-- Python environment
      local util = require("lspconfig/util")
      local path = util.path
      require('lspconfig').pyright.setup {
        on_attach = on_attach,
        capabilities = capabilities,
        before_init = function(_, config)
          default_venv_path = path.join(vim.env.HOME, "virtualenvs", "nvim-venv", "bin", "python")
          config.settings.python.pythonPath = default_venv_path
        end,
      }

-- Telescope key mappings
local builtin = require('telescope.builtin')

-- Telescope key mappings
vim.keymap.set('n', '<leader>ff', builtin.find_files, { desc = 'Telescope find files' })
vim.keymap.set('n', '<leader>fg', builtin.live_grep, { desc = 'Telescope live grep' })
vim.keymap.set('n', '<leader>fb', builtin.buffers, { desc = 'Telescope buffers' })
vim.keymap.set('n', '<leader>fh', builtin.help_tags, { desc = 'Telescope help tags' })

-- ToggleTerm command for sudo shell
vim.keymap.set('n', '<leader>tr', ':ToggleTerm size=10 direction=horizontal name=desktop cmd="sudo su"<CR>', {})

-- Function to prompt for terminal number and execute command
local function run_in_terminal(cmd)
  local term_number = vim.fn.input("Enter Terminal Number: ")
  if term_number == "" then
    print("No terminal selected.")
    return
  end
  vim.cmd(string.format('%sTermExec cmd="%s"', term_number, cmd))
end

-- Create virtual environment
vim.keymap.set('n', '<C-g>', function()
  run_in_terminal("python3 -m venv .venv")
end, { noremap = true, silent = true, desc = 'Create virtual environment' })

-- Activate virtual environment
vim.keymap.set('n', '<leader>rev', function()
  run_in_terminal("source .venv/bin/activate")
end, { noremap = true, silent = true, desc = 'Activate virtual environment' })

-- NeoTree toggle
vim.keymap.set('n', '<C-n>', ':Neotree filesystem reveal left<CR>', { desc = 'Toggle NeoTree' })

-- Save file
vim.keymap.set('n', '<C-s>', ':w<CR>', { desc = 'Save file' })

-- Format Python code with Black
vim.keymap.set('n', '<leader>fmp', ':silent !black %<CR>', { desc = 'Format Python file with Black' })

-- Run the current Python file
vim.keymap.set('n', '<leader>rf', function()
  local filename = vim.fn.expand('%:t')  -- Get only the current file name
  run_in_terminal("python3 " .. filename)
end, { noremap = true, silent = true, desc = 'Run current Python file in terminal' })

local Terminal = require('toggleterm.terminal').Terminal

-- Function to prompt for a terminal number, send Ctrl+C, and then exit
-- Function to close a specific terminal by sending Ctrl+C and exit
local function close_terminal()
  local term_number = vim.fn.input("Enter Terminal Number to Close: ")
  if term_number == "" then
    print("No terminal selected.")
    return
  end

  -- Send Ctrl+C to the terminal
  vim.cmd(string.format('%sTermExec cmd="printf \'\\003\'"', term_number))
  -- Exit the terminal
  vim.cmd(string.format('%sTermExec cmd="exit"', term_number))
end

-- Key mapping to close a specific terminal
vim.keymap.set('n', '<leader>tc', close_terminal, { noremap = true, silent = true, desc = 'Close specific terminal' })

