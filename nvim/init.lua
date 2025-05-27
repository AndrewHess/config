-- Add vim runtime path
vim.opt.runtimepath:prepend("~/.vim")
vim.opt.runtimepath:append("~/.vim/after")

-- Add custom plugins path
vim.opt.runtimepath:append("~/.config/nvim/pack/gtd")

-- Set leader key
vim.g.mapleader = "f"

-- Basic settings
vim.opt.tabstop = 4
vim.opt.softtabstop = 0
vim.opt.expandtab = true
vim.opt.shiftwidth = 4
vim.opt.smarttab = true
vim.opt.ruler = true
vim.opt.number = true
vim.opt.colorcolumn = "80,100"
vim.opt.foldmethod = "manual"
vim.opt.mouse = ""
vim.opt.tags:append(".tags")
vim.opt.wildmenu = true
vim.opt.history = 1000
vim.opt.ignorecase = true
vim.opt.termguicolors = true
vim.opt.listchars = { tab = ">-", space = "." }
vim.opt.showtabline = 2

-- Fix for build tags
vim.g.go_build_tags = 'e2e_all'

-- Bootstrap lazy.nvim
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
  vim.fn.system({
    "git",
    "clone",
    "--filter=blob:none",
    "https://github.com/folke/lazy.nvim.git",
    "--branch=stable",
    lazypath,
  })
end
vim.opt.rtp:prepend(lazypath)

-- Configure lazy.nvim
require("lazy").setup({
  -- Your plugins here
  {
    'nvim-telescope/telescope.nvim',
    branch = '0.1.x',
    dependencies = { 'nvim-lua/plenary.nvim' }
  },
  {
    "NoahTheDuke/vim-just",
    ft = { "just" },
  },
  {
    'chomosuke/term-edit.nvim',
    event = 'TermOpen',
    version = '1.*',
  },
  {
    "toppair/peek.nvim",
    event = { "VeryLazy" },
    build = "deno task --quiet build:fast",
    config = function()
        require("peek").setup()
        vim.api.nvim_create_user_command("PeekOpen", require("peek").open, {})
        vim.api.nvim_create_user_command("PeekClose", require("peek").close, {})
    end,
  },
  {
    "iamcco/markdown-preview.nvim",
    cmd = { "MarkdownPreviewToggle", "MarkdownPreview", "MarkdownPreviewStop" },
    build = "cd app && yarn install",
    init = function()
      vim.g.mkdp_filetypes = { "markdown" }
    end,
    ft = { "markdown" },
  },
  { 'nvim-treesitter/nvim-treesitter' },
  { 'neovim/nvim-lspconfig' },
  { 'tpope/vim-fugitive' },
  { 'github/copilot.vim' },
  {
    'fatih/vim-go',
    build = ':GoUpdateBinaries'
  },
  {
    'catppuccin/nvim',
    name = 'catppuccin'
  },
  { 'tpope/vim-commentary' },
  { 'gcmt/taboo.vim' },
  { 'dhruvasagar/vim-zoom' },
  { 'lewis6991/gitsigns.nvim' },
  {
    "folke/snacks.nvim",
    priority = 1000,
    lazy = false,
    ---@type snacks.Config
    opts = {
      bigfile = { enabled = true },
      dashboard = { enabled = false },
      -- indent = { enabled = true },
      input = { enabled = true },
      notifier = {
        enabled = true,
        timeout = 2000,
      },
      quickfile = { enabled = true },
      -- scroll = {
      --   animate = {
      --     duration = { step = 100, total = 75 },
      --     easing = "linear",
      --   },
      --   -- what buffers to animate
      --   filter = function(buf)
      --     return vim.g.snacks_scroll ~= false and vim.b[buf].snacks_scroll ~= false and vim.bo[buf].buftype ~= "terminal"
      --   end,
      -- },
      statuscolumn = { enabled = true },
      words = { enabled = false },
      dim = {
        animate = {
          enabled = vim.fn.has("nvim-0.10") == 1,
          easing = "outQuad",
          duration = {
            step = 10, -- ms per step
            total = 100, -- maximum duration
          },
        },
      },
      styles = {
        notification = {
          -- wo = { wrap = true } -- Wrap notifications
        }
      }
    },
    keys = {
      { "<leader>z",  function() Snacks.zen() end, desc = "Toggle Zen Mode" },
      { "<leader>Z",  function() Snacks.zen.zoom() end, desc = "Toggle Zoom" },
      { "<leader>.",  function() Snacks.scratch() end, desc = "Toggle Scratch Buffer" },
      { "<leader>S",  function() Snacks.scratch.select() end, desc = "Select Scratch Buffer" },
      { "<leader>n",  function() Snacks.notifier.show_history() end, desc = "Notification History" },
      { "<leader>db", function() Snacks.bufdelete() end, desc = "Delete Buffer" },
      { "<leader>cR", function() Snacks.rename.rename_file() end, desc = "Rename File" },
      { "<leader>un", function() Snacks.notifier.hide() end, desc = "Dismiss All Notifications" },
      { "<c-/>",      function() Snacks.terminal() end, desc = "Toggle Terminal" },
      { "<c-_>",      function() Snacks.terminal() end, desc = "which_key_ignore" },
      {
        "<leader>N",
        desc = "Neovim News",
        function()
          Snacks.win({
            file = vim.api.nvim_get_runtime_file("doc/news.txt", false)[1],
            width = 0.6,
            height = 0.6,
            wo = {
              spell = false,
              wrap = false,
              signcolumn = "yes",
              statuscolumn = " ",
              conceallevel = 3,
            },
          })
        end,
      }
    },
    init = function()
      vim.api.nvim_create_autocmd("User", {
        pattern = "VeryLazy",
        callback = function()
          -- Setup some globals for debugging (lazy-loaded)
          _G.dd = function(...)
            Snacks.debug.inspect(...)
          end
          _G.bt = function()
            Snacks.debug.backtrace()
          end
          vim.print = _G.dd -- Override print to use snacks for `:=` command

          -- Create some toggle mappings
          Snacks.toggle.option("spell", { name = "Spelling" }):map("<leader>us")
          Snacks.toggle.option("wrap", { name = "Wrap" }):map("<leader>uw")
          Snacks.toggle.option("relativenumber", { name = "Relative Number" }):map("<leader>uL")
          Snacks.toggle.diagnostics():map("<leader>ud")
          Snacks.toggle.line_number():map("<leader>ul")
          Snacks.toggle.option("conceallevel", { off = 0, on = vim.o.conceallevel > 0 and vim.o.conceallevel or 2 }):map("<leader>uc")
          Snacks.toggle.treesitter():map("<leader>uT")
          Snacks.toggle.option("background", { off = "light", on = "dark", name = "Dark Background" }):map("<leader>ub")
          Snacks.toggle.inlay_hints():map("<leader>uh")
          Snacks.toggle.indent():map("<leader>ug")
          Snacks.toggle.dim():map("<leader>uD")
        end,
      })
    end,
  }
}, {
  checker = {
    enabled = true,
    notify = false,
  },
  change_detection = {
    notify = false,
  },
})

-- Filetype-specific settings
vim.api.nvim_create_autocmd("FileType", {
    pattern = "make",
    callback = function()
        vim.opt_local.expandtab = false
        vim.opt_local.tabstop = 4
        vim.opt_local.shiftwidth = 4
    end
})

vim.api.nvim_create_autocmd("FileType", {
    pattern = "yaml",
    callback = function()
        vim.opt_local.shiftwidth = 2
        vim.opt_local.softtabstop = 2
        vim.opt_local.expandtab = true
    end
})

-- Save last tab
vim.g.lasttab = 1
vim.api.nvim_create_autocmd("TabLeave", {
    pattern = "*",
    callback = function()
        vim.g.lasttab = vim.fn.tabpagenr()
    end
})

-- Go settings
vim.g.go_fmt_command = "goimports"

-- Syntax highlighting for specific files
vim.api.nvim_create_autocmd({"BufRead", "BufNewFile"}, {
    pattern = "*.peg",
    command = "set filetype=pigeon"
})

vim.api.nvim_create_autocmd({"BufRead", "BufNewFile"}, {
    pattern = "*.mine",
    command = "set filetype=mine"
})

vim.api.nvim_create_autocmd({"BufRead", "BufNewFile"}, {
    pattern = "*.tpl",
    command = "set filetype=yaml"
})

-- LSP configurations
local function setup_go_lsp_mappings()
    local opts = { noremap = true, silent = true }
    vim.api.nvim_buf_set_keymap(0, 'n', '<leader>jr', '<cmd>lua vim.lsp.buf.rename()<CR>', opts)
    vim.api.nvim_buf_set_keymap(0, 'n', '<leader>ja', '<cmd>lua vim.lsp.buf.code_action()<CR>', opts)
    vim.api.nvim_buf_set_keymap(0, 'n', '<leader>jt', '<cmd>lua vim.lsp.buf.type_definition()<CR>', opts)
    vim.api.nvim_buf_set_keymap(0, 'n', '<leader>jd', '<cmd>lua vim.lsp.buf.definition()<CR>', opts)
    vim.api.nvim_buf_set_keymap(0, 'n', '<leader>jh', '<cmd>lua telescope_lsp_references()<CR>', opts)
    vim.api.nvim_buf_set_keymap(0, 'n', '<leader>jf', '<cmd>lua references_preserve_view()<CR>', opts)
    vim.api.nvim_buf_set_keymap(0, 'n', '<leader>ji', '<cmd>lua vim.lsp.buf.implementation()<CR>', opts)
end

vim.api.nvim_create_autocmd("FileType", {
    pattern = "go",
    callback = setup_go_lsp_mappings
})

-- Server.yaml EOL settings
vim.api.nvim_create_autocmd("BufWritePre", {
    pattern = {"server_saas.yaml"},
    command = "setlocal noendofline nofixendofline"
})

-- Helper functions
_G.ReloadTags = function()
    vim.fn.system('gotags -R . > .tags')
end

_G.GoFunctionTop = function()
    local current_pos = vim.fn.getpos(".")
    local found_line = vim.fn.search('^\\s*\\(func\\|type\\)\\s', 'bW')
    if found_line > 0 then
        vim.cmd('normal! zt')
    end
    vim.fn.setpos('.', current_pos)
end

_G.CloseQuickfixPreserveMainView = function()
    local main_win = -1
    for win = 1, vim.fn.winnr('$') do
        if vim.fn.getwinvar(win, '&buftype') ~= 'quickfix' then
            main_win = win
            break
        end
    end

    if main_win ~= -1 then
        vim.fn.win_gotoid(vim.fn.win_getid(main_win))
        local view = vim.fn.winsaveview()
        vim.cmd('cclose')
        vim.fn.win_gotoid(vim.fn.win_getid(main_win))
        vim.fn.winrestview(view)
    else
        vim.cmd('cclose')
    end
end

_G.ToggleTabs = function()
    local currenttab = vim.fn.tabpagenr()
    vim.cmd('tabn ' .. vim.g.lasttab)
    vim.g.lasttab = currenttab
end

_G.ToggleBoolean = function()
    local word = vim.fn.expand('<cword>')
    local replacements = {
        ['true'] = 'false',
        ['True'] = 'False',
        ['false'] = 'true',
        ['False'] = 'True'
    }
    if replacements[word] then
        vim.cmd('normal ciw' .. replacements[word])
    end
end


-- Disable filetype indent
vim.cmd('filetype indent off')

-- Set colorscheme
vim.cmd('colorscheme catppuccin')

-- Source syntax file
vim.cmd('source ~/.config/nvim/syntax/mine.vim')

-- Setup plugins
require('telescope').setup({
    defaults = {
        vimgrep_arguments = {
            'rg',
            '--color=never',
            '--no-heading',
            '--with-filename',
            '--line-number',
            '--column',
            '--smart-case',
            '--hidden',           -- Show hidden files
        },
        file_ignore_patterns = {
            '*.log',
            '.git/',
        },
        layout_strategy = 'horizontal',
        layout_config = {
            horizontal = {
                width = 0.9,
                height = 0.9,
                preview_width = 0.6,
            },
            vertical = {
                width = 0.9,
                height = 0.9,
                preview_height = 0.5,
            },
        },
    },
})
require('term-edit').setup { prompt_end = ' ❯ ' }

require('gitsigns').setup()

-- LSP setup
require('lspconfig').gopls.setup{
  settings = {
    gopls = {
      buildFlags = {"-tags=e2e_all"}
    }
  }
}

function telescope_lsp_references()
    require('telescope.builtin').lsp_references({
        include_declaration = true,
        show_line = false,
    })
end

function references_preserve_view()
    local main_win = nil
    for _, win in ipairs(vim.api.nvim_list_wins()) do
        local buftype = vim.api.nvim_buf_get_option(vim.api.nvim_win_get_buf(win), 'buftype')
        if buftype ~= 'quickfix' then
            main_win = win
            break
        end
    end

    if main_win then
        local view = vim.api.nvim_win_call(main_win, function()
            return vim.fn.winsaveview()
        end)

        vim.lsp.buf.references()

        vim.defer_fn(function()
            vim.api.nvim_win_call(main_win, function()
                vim.fn.winrestview(view)
            end)
        end, 100)
    else
        vim.lsp.buf.references()
    end
end

vim.api.nvim_create_autocmd("TermOpen", {
  pattern = "*",
  callback = function()
    vim.opt_local.winhighlight:append("Normal:TerminalNormal")
    vim.api.nvim_set_hl(0, "TerminalNormal", { bg = "#000000", fg = "#ffffff" })
  end
})

-- Copilot settings
vim.g.copilot_filetypes = {
    yaml = true,
    markdown = true,
}

-- Telescope bindings
vim.keymap.set('n', '<leader>t', function()
    require('telescope.builtin').find_files({
        hidden = true,
        no_ignore = false,
    })
end)
vim.keymap.set('n', '<leader>g', require('telescope.builtin').live_grep)
vim.keymap.set('n', '<leader>r', ':Telescope resume<CR><ESC>')
vim.keymap.set('n', '<leader>mm', 'yiw:Telescope live_grep<CR><C-r>"<ESC>')

-- Make commands
vim.keymap.set('n', '<leader>mh', ':set makeprg=go\\ vet\\ cmd/sigscalr/main.go<CR>:make<CR>')
vim.keymap.set('n', '<leader>ms', ':set makeprg=go\\ vet\\ cmd/siglens/main.go<CR>:make<CR>')
vim.keymap.set('n', '<leader>mc', ':set makeprg=go\\ vet\\ main.go<CR>:make<CR>')
vim.keymap.set('n', '<leader>mf', ':set makeprg=make\\ lint<CR>:make<CR>')

-- GTD and function navigation
vim.keymap.set('n', '<leader>d', function() require('gtd.view_manager').show_views_list() end)
vim.keymap.set('n', '<leader>T', function() GoFunctionTop() end)

-- Basic mappings
vim.keymap.set('n', '<leader>f', 'f')
vim.keymap.set('n', '<C-]>', function() ReloadTags() vim.cmd('normal! g<C-]>') end)
vim.keymap.set('i', 'kj', '<ESC>')
vim.keymap.set('i', '<C-k>ok', '☐')
vim.keymap.set('n', '<leader>h', ':noh<CR>')
vim.keymap.set('n', '<leader>o', ':norm o<ESC>0d$')
vim.keymap.set('n', '<leader>O', 'O<ESC>0d$')
vim.keymap.set('n', '<leader>w', ':set list!<CR>')
vim.keymap.set('n', '<leader>a', function() ToggleTabs() end)
vim.keymap.set('n', '<leader>ej', ':e %:h<CR>')
vim.api.nvim_set_keymap('n', '<leader>]', ':lua ReloadTags()<CR>g<C-]>', { noremap = true, silent = true })
vim.keymap.set('n', '<leader>k', function() CloseQuickfixPreserveMainView() end)
vim.keymap.set('n', '<leader>b', function() ToggleBoolean() end, { silent = true })
vim.keymap.set('n', '<leader>nn', [[<cmd>call search('^func \(([^)]\+) \)\?.', 'bWe')<CR>]])
vim.keymap.set('n', '<leader>s', 'F(b')
vim.keymap.set('n', '<leader>ix', '1z=')
vim.keymap.set('n', '<leader>;', ':tabe<CR>')
vim.keymap.set('n', '<leader>p', 'viwpyiw')
vim.keymap.set('n', '<leader>v', ':terminal go test -v ./%:h -count=1 -tags=e2e_all<CR>G')
vim.keymap.set('n', '<leader>nv', ':terminal go test -v ./%:h -count=1 -tags=e2e_all -run=^<C-r>=expand("<cword>")<CR>$<CR>G')
vim.keymap.set('n', '<leader>ml', ':Gitsigns blame<CR>')

-- scroll with ctrl-h and ctrl-l
vim.keymap.set('n', '<C-h>', 'g<')
vim.keymap.set('n', '<C-l>', 'g>')

-- Terminal mappings
vim.keymap.set('t', '<Esc>', '<C-\\><C-n>', {desc = 'Exit terminal mode'})
vim.keymap.set('t', '<C-w><C-w>', '<C-\\><C-n><C-w><C-w>', {desc = 'Switch terminal windows'})

-- Timestamp mappings
vim.keymap.set('n', '<leader>now', ":put =strftime('%Y-%m-%d %H:%M:%S', localtime())<CR>A ")
vim.keymap.set('n', '<leader>noww', ":put =strftime('%Y-%m-%d %H:%M:%S', localtime())<CR>A Work<ESC>zz:w<CR>")
vim.keymap.set('n', '<leader>nowd', ":put =strftime('%Y-%m-%d %H:%M:%S', localtime())<CR>A Work.Deep<ESC>zz:w<CR>")
vim.keymap.set('n', '<leader>nowr', ":put =strftime('%Y-%m-%d %H:%M:%S', localtime())<CR>A Work.Review<ESC>zz:w<CR>")
vim.keymap.set('n', '<leader>nowp', ":put =strftime('%Y-%m-%d %H:%M:%S', localtime())<CR>A Work.Prep<ESC>zz:w<CR>")
vim.keymap.set('n', '<leader>nowb', ":put =strftime('%Y-%m-%d %H:%M:%S', localtime())<CR>A Break<ESC>zz:w<CR>")
vim.keymap.set('n', '<leader>nowe', ":put =strftime('%Y-%m-%d %H:%M:%S', localtime())<CR>A Done<ESC>zz:w<CR>")

-- Misc mappings
vim.keymap.set('n', '<leader>q', ':q<CR>')
vim.keymap.set('n', '<leader>eq', 'o<ESC>^C=<C-r>=repeat("=", strlen(getline(line(".")-1))-1)<CR><CR>')
vim.keymap.set('n', '<leader>db', 'o<TAB>log.Infof("andrew ')
vim.keymap.set('n', '<leader>ent', 'o<TAB>utils.SigDebugEnter(fmt.Sprintf("andrew"))<CR>initialTime := time.Now()<CR>defer utils.SigDebugExit(func() string { return fmt.Sprintf("took %v", time.Since(initialTime)) })<CR><ESC>')
vim.keymap.set('n', '<leader>util', 'o "github.com/siglens/siglens/pkg/utils"<ESC>')
vim.keymap.set('n', '<leader>l', ':b#<CR>')
vim.keymap.set('n', '<leader>jsp', ':setlocal spell! spelllang=en_us<CR>:sleep 300m<CR>:setlocal nospell<CR>')

-- Tab movement
vim.keymap.set('n', '<leader>-', ':tabmove -<CR>')
vim.keymap.set('n', '<leader>+', ':tabmove +<CR>')
vim.keymap.set('n', '<leader>=', ':tabmove +<CR>')
vim.keymap.set('n', '<leader>jp', function()
    -- Save position
    local current_pos = vim.fn.getpos('.')
    local current_view = vim.fn.winsaveview()

    -- Execute and capture the output
    local lines = vim.api.nvim_exec2('g/^func/p', { output = true }).output

    -- Display in command area
    vim.api.nvim_echo({{lines, 'None'}}, false, {})

    -- Restore position
    vim.fn.setpos('.', current_pos)
    vim.fn.winrestview(current_view)
end)
vim.keymap.set('n', '<leader>jo', function()
    -- Save position
    local current_pos = vim.fn.getpos('.')
    local current_view = vim.fn.winsaveview()

    -- Get word under cursor
    local type_name = vim.fn.expand('<cword>')
    
    -- Search pattern for methods
    -- Matches:
    -- func (x TypeName)
    -- func (x *TypeName) 
    -- where x can be any receiver name
    local pattern = '^func (\\([^ )]\\+ \\*\\?' .. type_name .. '\\))'
    
    -- Execute and capture the output
    local lines = vim.api.nvim_exec2('g/' .. pattern .. '/p', { output = true }).output

    -- Display in command area
    vim.api.nvim_echo({{lines, 'None'}}, false, {})

    -- Restore position
    vim.fn.setpos('.', current_pos)
    vim.fn.winrestview(current_view)
end)
vim.keymap.set('n', '<leader>jk', ':split ~/.teleport/scratch<CR>')

-- Tab switching
for i = 1, 9 do
    vim.keymap.set('n', string.format('<leader>%d', i), string.format('%dgt', i))
end

-- Quickfix navigation
vim.keymap.set('n', '[q', ':cprevious<CR>zz', { silent = true })
vim.keymap.set('n', ']q', ':cnext<CR>zz', { silent = true })

