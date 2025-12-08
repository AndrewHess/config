-------------------------------------------------------------------------------
--- Basic Settings
-------------------------------------------------------------------------------

vim.g.mapleader = "f" -- The leader key
vim.opt.tabstop = 4
vim.opt.softtabstop = 0
vim.opt.expandtab = true
vim.opt.shiftwidth = 4
vim.opt.smarttab = true
vim.opt.ruler = true
vim.opt.number = true
vim.opt.foldmethod = "manual"
vim.opt.mouse = ""
vim.opt.tags:append(".tags")
vim.opt.wildmenu = true
vim.opt.history = 1000
vim.opt.ignorecase = true
vim.opt.termguicolors = true
vim.opt.listchars = { tab = ">-", space = "." }
vim.opt.showtabline = 2
vim.opt.signcolumn = "yes"
vim.cmd('filetype indent off') -- TODO: Check if I want this enabled

-------------------------------------------------------------------------------
--- LazyNvim plugins (see ~/.config/nvim/lua/plugins/)
-------------------------------------------------------------------------------

require("config.lazy")

-------------------------------------------------------------------------------
--- Tabs
-------------------------------------------------------------------------------

-- Save last tab
vim.g.lasttab = 1
vim.api.nvim_create_autocmd("TabLeave", {
    pattern = "*",
    callback = function()
        vim.g.lasttab = vim.fn.tabpagenr()
    end
})

_G.ToggleTabs = function()
    local currenttab = vim.fn.tabpagenr()
    vim.cmd('tabn ' .. vim.g.lasttab)
    vim.g.lasttab = currenttab
end

vim.keymap.set('n', '<leader>a', function() ToggleTabs() end)
vim.keymap.set('n', '<leader>;', ':tabe<CR>')

-- Tab movement
vim.keymap.set('n', '<leader>-', ':tabmove -<CR>')
vim.keymap.set('n', '<leader>+', ':tabmove +<CR>')
vim.keymap.set('n', '<leader>=', ':tabmove +<CR>')

-- Tab switching
for i = 1, 9 do
    vim.keymap.set('n', string.format('<leader>%d', i), string.format('%dgt', i))
end

-------------------------------------------------------------------------------
--- Quality-of-life helpers
-------------------------------------------------------------------------------

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

-------------------------------------------------------------------------------
--- Make
-------------------------------------------------------------------------------

-- Set makeprg per filetype
vim.api.nvim_create_autocmd("FileType", {
    pattern = "go",
    callback = function()
        vim.opt_local.makeprg = "go build"
    end
})
vim.api.nvim_create_autocmd("FileType", {
    pattern = "rust",
    callback = function()
        vim.opt_local.makeprg = "cargo build"
    end
})

-- -- Single keymap that uses whatever makeprg is set
-- vim.keymap.set('n', '<leader>mr', ':make<CR>', { desc = "Build and open quickfix" })
vim.keymap.set('n', '<leader>mr', function()
    vim.cmd('silent make')
    vim.cmd('botright term ' .. vim.o.makeprg)
end, { desc = "Build in terminal" })

-------------------------------------------------------------------------------
--- Keymappings
-------------------------------------------------------------------------------

vim.keymap.set('n', '<leader>f', 'f')
vim.keymap.set('n', '<C-]>', function()
    ReloadTags()
    vim.cmd('normal! g<C-]>')
end)
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
vim.keymap.set('n', '<leader>s', 'F(b')
vim.keymap.set('n', '<leader>ix', '1z=')
vim.keymap.set('n', '<leader>;', ':tabe<CR>')
vim.keymap.set('n', '<leader>p', 'viwpyiw')
vim.keymap.set('n', '<leader>v', ':terminal go test -v ./%:h -count=1 -tags=e2e_all<CR>G')
vim.keymap.set('n', '<leader>nv',
    ':terminal go test -v ./%:h -count=1 -tags=e2e_all -run=^<C-r>=expand("<cword>")<CR>$<CR>G')
vim.keymap.set('n', '<leader>ml', ':Gitsigns blame<CR>')
vim.keymap.set('n', '<leader>q', ':q<CR>')
vim.keymap.set('n', '<leader>eq', 'o<ESC>^C=<C-r>=repeat("=", strlen(getline(line(".")-1))-1)<CR><CR>')
vim.keymap.set('n', '<leader>db', 'o<TAB>log.Infof("andrew ')
vim.keymap.set('n', '<leader>ent',
    'o<TAB>utils.SigDebugEnter(fmt.Sprintf("andrew"))<CR>initialTime := time.Now()<CR>defer utils.SigDebugExit(func() string { return fmt.Sprintf("took %v", time.Since(initialTime)) })<CR><ESC>')
vim.keymap.set('n', '<leader>util', 'o "github.com/siglens/siglens/pkg/utils"<ESC>')
vim.keymap.set('n', '<leader>l', ':b#<CR>')
vim.keymap.set('n', '<leader>jsp', ':setlocal spell! spelllang=en_us<CR>:sleep 300m<CR>:setlocal nospell<CR>')

-- Scroll with ctrl-h and ctrl-l
vim.keymap.set('n', '<C-h>', 'g<')
vim.keymap.set('n', '<C-l>', 'g>')

-- Timestamp mappings
vim.keymap.set('n', '<leader>now', ":put =strftime('%Y-%m-%d %H:%M:%S', localtime())<CR>A ")
vim.keymap.set('n', '<leader>noww', ":put =strftime('%Y-%m-%d %H:%M:%S', localtime())<CR>A Work<ESC>zz:w<CR>")
vim.keymap.set('n', '<leader>nowd', ":put =strftime('%Y-%m-%d %H:%M:%S', localtime())<CR>A Work.Deep<ESC>zz:w<CR>")
vim.keymap.set('n', '<leader>nowr', ":put =strftime('%Y-%m-%d %H:%M:%S', localtime())<CR>A Work.Review<ESC>zz:w<CR>")
vim.keymap.set('n', '<leader>nowp', ":put =strftime('%Y-%m-%d %H:%M:%S', localtime())<CR>A Work.Prep<ESC>zz:w<CR>")
vim.keymap.set('n', '<leader>nowb', ":put =strftime('%Y-%m-%d %H:%M:%S', localtime())<CR>A Break<ESC>zz:w<CR>")
vim.keymap.set('n', '<leader>nowe', ":put =strftime('%Y-%m-%d %H:%M:%S', localtime())<CR>A Done<ESC>zz:w<CR>")

-------------------------------------------------------------------------------
--- Go to top of this function
-------------------------------------------------------------------------------
vim.api.nvim_create_autocmd("FileType", {
    pattern = "go",
    callback = function()
        vim.keymap.set('n', '<leader>nn', [[<cmd>call search('^func \(([^)]\+) \)\?.', 'bWe')<CR>]], { buffer = true })
    end
})

vim.api.nvim_create_autocmd("FileType", {
    pattern = "rust",
    callback = function()
        vim.keymap.set('n', '<leader>nn', [[<cmd>call search('fn \(([^)]\+) \)\?.', 'bWe')<CR>]], { buffer = true })
    end
})
