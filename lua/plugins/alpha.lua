return {
  "goolord/alpha-nvim",
  event = "VimEnter",
  enabled = true,
  opts = function()
    local dashboard = require("alpha.themes.dashboard")
    local logo = [[

▗▖ ▗▖▗▖  ▗▖▗▖   ▗▄▄▄▖ ▗▄▖  ▗▄▄▖▗▖ ▗▖    ▗▄▄▖  ▗▄▖▗▄▄▄▖▗▄▄▄▖▗▖  ▗▖▗▄▄▄▖▗▄▄▄▖ ▗▄▖ ▗▖       ▗▄▄▄ ▗▖ ▗▖▗▄▄▖ ▗▖ ▗▖▗▖  ▗▖
▐▌ ▐▌▐▛▚▖▐▌▐▌   ▐▌   ▐▌ ▐▌▐▌   ▐▌ ▐▌    ▐▌ ▐▌▐▌ ▐▌ █  ▐▌   ▐▛▚▖▐▌  █    █  ▐▌ ▐▌▐▌       ▐▌  █▐▌ ▐▌▐▌ ▐▌▐▌ ▐▌▐▌  ▐▌
▐▌ ▐▌▐▌ ▝▜▌▐▌   ▐▛▀▀▘▐▛▀▜▌ ▝▀▚▖▐▛▀▜▌    ▐▛▀▘ ▐▌ ▐▌ █  ▐▛▀▀▘▐▌ ▝▜▌  █    █  ▐▛▀▜▌▐▌       ▐▌  █▐▛▀▜▌▐▛▀▚▖▐▌ ▐▌▐▌  ▐▌
▝▚▄▞▘▐▌  ▐▌▐▙▄▄▖▐▙▄▄▖▐▌ ▐▌▗▄▄▞▘▐▌ ▐▌    ▐▌   ▝▚▄▞▘ █  ▐▙▄▄▖▐▌  ▐▌  █  ▗▄█▄▖▐▌ ▐▌▐▙▄▄▖    ▐▙▄▄▀▐▌ ▐▌▐▌ ▐▌▝▚▄▞▘ ▝▚▞▘ 
                                                                                                                   

    ▗▖   ▗▄▄▄▖▗▄▄▄▖▗▄▄▖     ▗▄▄▖ ▗▄▖ ▗▄▄▄ ▗▄▄▄▖    ▗▄▄▖ ▗▄▄▖ ▗▄▄▄▖▗▖   ▗▖   ▗▄▄▄▖ ▗▄▖ ▗▖  ▗▖ ▗▄▄▖▗▄▄▄▖
    ▐▌   ▐▌     █ ▐▌       ▐▌   ▐▌ ▐▌▐▌  █▐▌       ▐▌ ▐▌▐▌ ▐▌  █  ▐▌   ▐▌     █  ▐▌ ▐▌▐▛▚▖▐▌▐▌   ▐▌   
    ▐▌   ▐▛▀▀▘  █  ▝▀▚▖    ▐▌   ▐▌ ▐▌▐▌  █▐▛▀▀▘    ▐▛▀▚▖▐▛▀▚▖  █  ▐▌   ▐▌     █  ▐▛▀▜▌▐▌ ▝▜▌▐▌   ▐▛▀▀▘
    ▐▙▄▄▖▐▙▄▄▖  █ ▗▄▄▞▘    ▝▚▄▄▖▝▚▄▞▘▐▙▄▄▀▐▙▄▄▖    ▐▙▄▞▘▐▌ ▐▌▗▄█▄▖▐▙▄▄▖▐▙▄▄▖▗▄█▄▖▐▌ ▐▌▐▌  ▐▌▝▚▄▄▖▐▙▄▄▖
                                                                                                      
                                                                                                      
                                                                                                      

]]
    
    dashboard.section.header.val = vim.split(logo, "\n")

    -- Define buttons without LazyVim references
    dashboard.section.buttons.val = {
      dashboard.button("f", "  Find file", ":Telescope find_files<CR>"),
      dashboard.button("n", "  New file", ":ene <BAR> startinsert<CR>"),
      dashboard.button("r", "  Recent files", ":Telescope oldfiles<CR>"),
      dashboard.button("g", "  Find text", ":Telescope live_grep<CR>"),
      dashboard.button("c", "  Config", ":e $MYVIMRC<CR>"),
      dashboard.button("p", "󰒲  Plugins", ":Lazy<CR>"),
      dashboard.button("q", "  Quit", ":qa<CR>"),
    }

    -- Set highlight groups
    dashboard.section.header.opts.hl = "AlphaHeader"
    dashboard.section.buttons.opts.hl = "AlphaButtons"
    dashboard.section.footer.opts.hl = "AlphaFooter"

    dashboard.opts.layout[1].val = 8
    return dashboard
  end,

  config = function(_, dashboard)
    require("alpha").setup(dashboard.opts)

    -- Update footer with plugin stats on startup
    vim.api.nvim_create_autocmd("User", {
      once = true,
      pattern = "LazyVimStarted",
      callback = function()
        local stats = require("lazy").stats()
        local ms = (math.floor(stats.startuptime * 100 + 0.5) / 100)
        dashboard.section.footer.val = "⚡ Neovim loaded "
          .. stats.loaded
          .. "/"
          .. stats.count
          .. " plugins in "
          .. ms
          .. "ms"
        pcall(vim.cmd.AlphaRedraw)
      end,
    })
  end,
}

