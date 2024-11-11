return {
  'nvim-lualine/lualine.nvim',
  config = function()
    -- Function to prompt for a terminal number and run a command
    local function run_in_terminal(cmd)
      local term_number = vim.fn.input("Enter Terminal Number: ")
      if term_number == "" then
        print("No terminal selected.")
        return
      end
      vim.cmd(string.format('%sTermExec cmd="%s"', term_number, cmd))
    end

    -- Function to create a virtual environment
    local function create_env()
      run_in_terminal("python3 -m venv .venv")
    end

    -- Function to activate the virtual environment
    local function activate_env()
      run_in_terminal("source .venv/bin/activate")
    end

    -- Function to run the current Python file
    local function run_python_file()
      local filepath = vim.fn.expand('%:p')
      run_in_terminal("python3 " .. filepath)
    end

    -- Function to kill all terminals
    local function kill_terminal()
      vim.cmd('ToggleTermToggleAll')
    end

    -- Button definitions for lualine
    local buttons = {
      create_env_button = {
        function() return '🔧 [Create Env]' end,
        color = { fg = '#98c379' },
        cond = function() return vim.bo.filetype == 'python' end,
        on_click = function() create_env() end,
      },
      activate_env_button = {
        function() return '⚡ [Activate Env]' end,
        color = { fg = '#61afef' },
        cond = function() return vim.bo.filetype == 'python' end,
        on_click = function() activate_env() end,
      },
      run_python_button = {
        function() return '▶️ [Run]' end,
        color = { fg = '#e86671' },
        cond = function() return vim.bo.filetype == 'python' end,
        on_click = function() run_python_file() end,
      },
      kill_terminal_button = {
        function() return '🛑 [Kill Terminal]' end,
        color = { fg = '#f7768e' },
        cond = function() return vim.bo.filetype == 'python' end,
        on_click = function() kill_terminal() end,
      },
    }

    -- Setup lualine with the custom sections
    require('lualine').setup({
      options = {
        theme = 'dracula',
      },
      sections = {
        lualine_c = {
          'filename',
          buttons.create_env_button,
          buttons.activate_env_button,
          buttons.run_python_button,
          buttons.kill_terminal_button,
        },
      },
    })
  end
}

