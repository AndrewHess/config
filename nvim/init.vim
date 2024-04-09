set runtimepath^=~/.vim runtimepath+=~/.vim/after
let &packpath = &runtimepath

" Custom plugins
set runtimepath+=~/.config/nvim/pack/gtd

set tabstop=4 softtabstop=0 expandtab shiftwidth=4 smarttab
autocmd FileType make setlocal noexpandtab tabstop=4 shiftwidth=4
autocmd FileType yaml setlocal shiftwidth=2 softtabstop=2 expandtab
autocmd TabLeave * let g:lasttab = tabpagenr()

" Run goimports when saving a .go file
augroup goimports
    autocmd!
    autocmd BufWritePre *.go execute 'call GoImports()'
augroup END


" Activate syntax highlighting
autocmd BufRead,BufNewFile *.peg set filetype=pigeon
autocmd BufRead,BufNewFile *.mine set filetype=mine

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

let mapleader = "f"

" Rebind keys
nnoremap <C-]> :call ReloadTags()<CR>g<C-]>
inoremap kj <ESC>
inoremap <C-k>ok <C-v>u2610

" Custom commands
nnoremap <leader>l :call ReloadTags()<CR>
nnoremap <leader>t <cmd>lua require('telescope.builtin').find_files()<CR>
nnoremap <leader>g <cmd>lua require('telescope.builtin').live_grep()<CR>
nnoremap <leader>mm yiw:Telescope live_grep<CR><C-r>"<ESC>
nnoremap <leader>mh :set makeprg=go\ build\ cmd/sigscalr/main.go<CR>:make<CR>
nnoremap <leader>ms :set makeprg=go\ build\ cmd/siglens/main.go<CR>:make<CR>
nnoremap <leader>d :lua require('gtd.view_manager').show_views_list()<CR>
nnoremap <leader>T :call GoFunctionTop()<CR>
nnoremap <leader>f f
nnoremap <leader>h :noh<CR>
nnoremap <leader>o :norm o<ESC>0d$
nnoremap <leader>O O<ESC>0d$
nnoremap <leader>w :set list!<CR>
nnoremap <leader>a :call ToggleTabs()<CR>
nnoremap <leader>e :e %:h<CR>
nnoremap <leader>] :tab split<CR>:call ReloadTags()<CR>g<C-]>
" nnoremap <leader>] :tab split<CR>:exec("tag ".expand("<cword>"))<CR>

nnoremap <leader>1 1gt
nnoremap <leader>2 2gt
nnoremap <leader>3 3gt
nnoremap <leader>4 4gt
nnoremap <leader>5 5gt
nnoremap <leader>6 6gt
nnoremap <leader>7 7gt
nnoremap <leader>8 8gt
nnoremap <leader>9 9gt

function! ReloadTags()
    :silent! !gotags -R . > .tags
endfunction


function! GoImports()
  let l:view = winsaveview()

  " Save the current buffer content in a variable
  let l:current_buffer = join(getline(1, '$'), "\n")

  " Run goimports and capture the output
  let l:output = system('goimports', l:current_buffer)

  " Check if goimports succeeded
  if v:shell_error == 0
    " Replace buffer content only if goimports succeeded
    :%delete _
    call setline(1, split(l:output, "\n"))

    " Restore the cursor and window view
    call winrestview(l:view)
  else
    " Show error message
    echohl ErrorMsg
    echom "goimports failed:"
    for line in split(l:output, "\n")
        echom line
    endfor
    echom ""
    echohl None
  endif
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


" Toggle tabs
let g:lasttab = 1
function! ToggleTabs()
    let l:currenttab = tabpagenr()
    exec "tabn " . g:lasttab
    let g:lasttab = l:currenttab
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

" no-neck-pain for centering windows
Plug 'shortcuts/no-neck-pain.nvim', { 'tag': '*' }

" Copilot
Plug 'github/copilot.vim'

" Color schemes
Plug 'whatyouhide/vim-gotham'
Plug 'https://github.com/AlessandroYorba/Alduin'
Plug 'https://github.com/AlessandroYorba/Despacio'
Plug 'https://github.com/w0ng/vim-hybrid'
Plug 'https://github.com/haishanh/night-owl.vim'

" Miscellanous
Plug 'https://tpope.io/vim/commentary.git' " Commenting
Plug 'https://github.com/gcmt/taboo.vim' " Rename tabs

" Initialize plugin system
" - Automatically executes `filetype plugin indent on` and `syntax enable`.
call plug#end()
" You can revert the settings after the call like so:
"   filetype indent off   " Disable file-type-specific indentation
"   syntax off            " Disable syntax highlighting

filetype indent off

" Set the color scheme
"colorscheme alduin
"colorscheme gotham256
"colorscheme despacio
colorscheme hybrid

source ~/.config/nvim/syntax/mine.vim

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
        '--no-ignore', -- Don't check .gitignore; just search everything
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

let g:copilot_filetypes = {
    \ 'yaml': v:true,
    \ 'markdown': v:true,
\ }
