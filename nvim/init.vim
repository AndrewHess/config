set runtimepath^=~/.vim runtimepath+=~/.vim/after
let &packpath = &runtimepath

" Custom plugins
set runtimepath+=~/.config/nvim/pack/gtd

let mapleader = "f"
set tabstop=4 softtabstop=0 expandtab shiftwidth=4 smarttab
autocmd FileType make setlocal noexpandtab tabstop=4 shiftwidth=4
autocmd FileType yaml setlocal shiftwidth=2 softtabstop=2 expandtab
autocmd TabLeave * let g:lasttab = tabpagenr()

" Enable Go auto-formatting on save
let g:go_fmt_command = "goimports"


" Activate syntax highlighting
autocmd BufRead,BufNewFile *.peg set filetype=pigeon
autocmd BufRead,BufNewFile *.mine set filetype=mine
autocmd BufRead,BufNewFile *.tpl set filetype=yaml

" Language Server Protocol
augroup lsp
  au!
  au FileType go lua vim.api.nvim_buf_set_keymap(0, 'n', '<leader>jr', '<cmd>lua vim.lsp.buf.rename()<CR>', {noremap=true, silent=true})
  au FileType go lua vim.api.nvim_buf_set_keymap(0, 'n', '<leader>ja', '<cmd>lua vim.lsp.buf.code_action()<CR>', {noremap=true, silent=true})
  au FileType go lua vim.api.nvim_buf_set_keymap(0, 'n', '<leader>jt', '<cmd>lua vim.lsp.buf.type_definition()<CR>', {noremap=true, silent=true})
  au FileType go lua vim.api.nvim_buf_set_keymap(0, 'n', '<leader>jd', '<cmd>lua vim.lsp.buf.definition()<CR>', {noremap=true, silent=true})
  au FileType go lua vim.api.nvim_buf_set_keymap(0, 'n', '<leader>jh', '<cmd>lua telescope_lsp_references()<CR>', {noremap=true, silent=true})
  au FileType go lua vim.api.nvim_buf_set_keymap(0, 'n', '<leader>jf', '<cmd>lua references_preserve_view()<CR>', {noremap=true, silent=true})
augroup END
  " au FileType go lua vim.api.nvim_buf_set_keymap(0, 'n', '<leader>jf', '<cmd>lua vim.lsp.buf.references()<CR>', {noremap=true, silent=true})

" Save server.yaml without a newline.
augroup ServerYamlEOL
  autocmd!
  autocmd BufWritePre server.yaml setlocal noendofline nofixendofline
augroup END

filetype plugin indent on

:syntax on
:set ruler
:set number
:set colorcolumn=80,100
:set foldmethod=manual
:set mouse=
:set tags+=.tags
:set wildmenu
:set history=1000
:set ignorecase
:set termguicolors
:set listchars=tab:>-,space:.
:set showtabline=2 " Always show tabs

" Rebind keys
nnoremap <C-]> :call ReloadTags()<CR>g<C-]>
inoremap kj <ESC>
inoremap <C-k>ok <C-v>u2610

" Custom commands
nnoremap <leader>t <cmd>lua require('telescope.builtin').find_files()<CR>
nnoremap <leader>g <cmd>lua require('telescope.builtin').live_grep()<CR>
nnoremap <leader>r :Telescope resume<CR><ESC>
nnoremap <leader>mm yiw:Telescope live_grep<CR><C-r>"<ESC>
nnoremap <leader>mh :set makeprg=go\ vet\ cmd/sigscalr/main.go<CR>:make<CR>
nnoremap <leader>ms :set makeprg=go\ vet\ cmd/siglens/main.go<CR>:make<CR>
nnoremap <leader>mf :set makeprg=make\ lint<CR>:make<CR>
nnoremap <leader>d :lua require('gtd.view_manager').show_views_list()<CR>
nnoremap <leader>T :call GoFunctionTop()<CR>
nnoremap <leader>f f
nnoremap <leader>h :noh<CR>
nnoremap <leader>o :norm o<ESC>0d$
nnoremap <leader>O O<ESC>0d$
nnoremap <leader>w :set list!<CR>
nnoremap <leader>a :call ToggleTabs()<CR>
nnoremap <leader>ej :e %:h<CR>
nnoremap <leader>] :tab split<CR>:call ReloadTags()<CR>g<C-]>
nnoremap <leader>k :call CloseQuickfixPreserveMainView()<CR>
nnoremap <silent><leader>b :call ToggleBoolean()<CR>
nnoremap <leader>nn :call search('^func \(([^)]\+) \)\?.', 'bWe')<CR>
nnoremap <leader>s F(b
nnoremap <leader>ix 1z=
nnoremap <leader>p viwpyiw
nnoremap <leader>v :terminal go test -v ./%:h -count=1<CR>G
nnoremap <leader>ml :Gitsigns blame<CR>
nnoremap <leader>now :put =strftime('%Y-%m-%d %H:%M:%S')<CR>A 
nnoremap <leader>noww :put =strftime('%Y-%m-%d %H:%M:%S')<CR>A Work<ESC>zz:w<CR>
nnoremap <leader>nowd :put =strftime('%Y-%m-%d %H:%M:%S')<CR>A Work.Deep<ESC>zz:w<CR>
nnoremap <leader>nowr :put =strftime('%Y-%m-%d %H:%M:%S')<CR>A Work.Review<ESC>zz:w<CR>
nnoremap <leader>nowp :put =strftime('%Y-%m-%d %H:%M:%S')<CR>A Work.Prep<ESC>zz:w<CR>
nnoremap <leader>nowb :put =strftime('%Y-%m-%d %H:%M:%S')<CR>A Break<ESC>zz:w<CR>
nnoremap <leader>nowe :put =strftime('%Y-%m-%d %H:%M:%S')<CR>A Done<ESC>zz:w<CR>
nnoremap <leader>q :q<CR>
nnoremap <leader>eq o<ESC>^C=<C-r>=repeat('=', strlen(getline(line('.')-1))-1)<CR><CR>
nnoremap <leader>ent o<TAB>toputils.SigDebugEnter("andrew")<CR>defer toputils.SigDebugExit(nil)<CR><ESC>
nnoremap <leader>util otoputils "github.com/siglens/siglens/pkg/utils"<ESC>
nnoremap <leader>l :b#<CR>
nnoremap <leader>jsp :setlocal spell! spelllang=en_us<CR>:sleep 300m<CR>:setlocal nospell<CR>
nnoremap <leader>- :tabmove -<CR>
nnoremap <leader>+ :tabmove +<CR>
nnoremap <leader>= :tabmove +<CR>
nnoremap <leader>jp :g/^func/p<CR>
nnoremap <leader>jk :split ~/.teleport/scratch<CR>

nnoremap <leader>1 1gt
nnoremap <leader>2 2gt
nnoremap <leader>3 3gt
nnoremap <leader>4 4gt
nnoremap <leader>5 5gt
nnoremap <leader>6 6gt
nnoremap <leader>7 7gt
nnoremap <leader>8 8gt
nnoremap <leader>9 9gt

nnoremap <silent> [q :cprevious<CR>zz
nnoremap <silent> ]q :cnext<CR>zz

function! ReloadTags()
    :silent! !gotags -R . > .tags
endfunction


function! GoFunctionTop()
    let current_pos = getpos(".")
    " Search backward for the func or type keyword
    let found_line = search('^\s*\(func\|type\)\s', 'bW')
    if found_line > 0
        " Reposition the view with the found line at the top
        normal! zt
    endif
    " Restore the cursor to its original position
    call setpos('.', current_pos)
endfunction

function! CloseQuickfixPreserveMainView()
    " Initialize a variable to store the main window number
    let l:main_win = -1

    " Iterate through all windows to find the main window (not quickfix)
    for win in range(1, winnr('$'))
        if getwinvar(win, '&buftype') !=# 'quickfix'
            let l:main_win = win
            break
        endif
    endfor

    " If a main window is found
    if l:main_win !=# -1
        " Save the view of the main window
        call win_gotoid(win_getid(l:main_win))
        let l:view = winsaveview()

        " Close the quickfix window
        cclose

        " Restore the view of the main window
        call win_gotoid(win_getid(l:main_win))
        call winrestview(l:view)
    else
        " Fallback: just close the quickfix window
        cclose
    endif
endfunction

" Toggle tabs
if !exists('g:lasttab')
    let g:lasttab = 1
endif
function! ToggleTabs()
    let l:currenttab = tabpagenr()
    exec "tabn " . g:lasttab
    let g:lasttab = l:currenttab
endfunction

function! ToggleBoolean()
    let wordUnderCursor = expand('<cword>')
    if wordUnderCursor == 'true'
        execute "normal ciwfalse"
    elseif wordUnderCursor == 'True'
        execute "normal ciwFalse"
    elseif wordUnderCursor == 'false'
        execute "normal ciwtrue"
    elseif wordUnderCursor == 'False'
        execute "normal ciwTrue"
    endif
endfunction

" Use vim-plug for plugins
call plug#begin()
" The default plugin directory will be as follows:
"   - Vim (Linux/macOS): '~/.vim/plugged'
"   - Vim (Windows): '~/vimfiles/plugged'
"   - Neovim (Linux/macOS/Windows): stdpath('data') . '/plugged'
" You can specify a custom plugin directory by passing it as the argument
"   - e.g. `call plug#begin('~/.vim/plugged')`
"   - Avoid using standard Vim directory names like 'plugin'

" Make sure you use single quotes
"
" Telescope for searching
Plug 'nvim-lua/plenary.nvim'
Plug 'nvim-treesitter/nvim-treesitter'
Plug 'nvim-telescope/telescope.nvim', { 'tag': '0.1.x' }

" Several small plugins
Plug 'folke/snacks.nvim'

" LSP
Plug 'neovim/nvim-lspconfig'

" Fugitive
Plug 'tpope/vim-fugitive'

" Copilot
Plug 'github/copilot.vim'

" Go
Plug 'fatih/vim-go', { 'do': ':GoUpdateBinaries' }

" Color schemes
" Plug 'whatyouhide/vim-gotham'
" Plug 'https://github.com/AlessandroYorba/Alduin'
" Plug 'https://github.com/AlessandroYorba/Despacio'
" Plug 'https://github.com/w0ng/vim-hybrid'
" Plug 'https://github.com/haishanh/night-owl.vim'
Plug 'catppuccin/nvim', { 'as': 'catppuccin' }
" Plug 'rebelot/kanagawa.nvim', { 'as': 'kanagawa'}

" Miscellanous
Plug 'https://tpope.io/vim/commentary.git' " Commenting
Plug 'https://github.com/gcmt/taboo.vim' " Rename tabs
Plug 'dhruvasagar/vim-zoom'
Plug 'lewis6991/gitsigns.nvim' " Git staged/unstaged changes

" Initialize plugin system
" - Automatically executes `filetype plugin indent on` and `syntax enable`.
call plug#end()
" You can revert the settings after the call like so:
"   filetype indent off   " Disable file-type-specific indentation
"   syntax off            " Disable syntax highlighting

filetype indent off

" Set the color scheme
" colorscheme alduin
" colorscheme gotham256
" colorscheme despacio
" colorscheme hybrid
colorscheme catppuccin
" colorscheme kanagawa

source ~/.config/nvim/syntax/mine.vim

lua << EOF
require('snacks').setup({
  opts = {
    -- your configuration comes here
    -- or leave it empty to use the default settings
    -- refer to the configuration section below
    bigfile = { enabled = true },
    dashboard = { enabled = true },
    indent = { enabled = true },
    input = { enabled = true },
    notifier = { enabled = true },
    quickfile = { enabled = true },
    scroll = { enabled = true },
    statuscolumn = { enabled = true },
    words = { enabled = true },
  },
  keys = {
    { "<leader>z",  function() Snacks.zen() end, desc = "Toggle Zen Mode" },
  }
})
EOF

lua << EOF
require('telescope').setup{
  defaults = {
    vimgrep_arguments = {
        'rg',
        '--color=never',
        '--no-heading',
        '--with-filename',
        '--line-number',
        '--column',
        '--smart-case',
    },
    file_ignore_patterns = {
        '*.log',
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
}
EOF

lua << EOF
require('gitsigns').setup()
EOF

lua << EOF
require('lspconfig').gopls.setup({})

function telescope_lsp_references()
  require('telescope.builtin').lsp_references({
    include_declaration = true,
    show_line = false,
  })
end

function references_preserve_view()
    -- Identify the main code window (not a quickfix window)
    local main_win = nil
    for _, win in ipairs(vim.api.nvim_list_wins()) do
        local buftype = vim.api.nvim_buf_get_option(vim.api.nvim_win_get_buf(win), 'buftype')
        if buftype ~= 'quickfix' then
            main_win = win
            break
        end
    end

    if main_win then
        -- Save the current view of the main window
        local view = vim.api.nvim_win_call(main_win, function()
            return vim.fn.winsaveview()
        end)

        -- Open references
        vim.lsp.buf.references()

        -- Restore the view after a short delay
        vim.defer_fn(function()
            vim.api.nvim_win_call(main_win, function()
                vim.fn.winrestview(view)
            end)
        end, 100)
    else
        vim.lsp.buf.references()
    end
end
EOF

let g:copilot_filetypes = {
    \ 'yaml': v:true,
    \ 'markdown': v:true,
\ }
