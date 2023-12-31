set runtimepath^=~/.vim runtimepath+=~/.vim/after
let &packpath = &runtimepath

" Custom plugins
set runtimepath+=~/.config/nvim/pack/gtd

set tabstop=4 softtabstop=0 expandtab shiftwidth=4 smarttab
autocmd FileType make setlocal noexpandtab tabstop=4 shiftwidth=4
autocmd FileType yaml setlocal shiftwidth=2 softtabstop=2 expandtab

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

let mapleader = "f"

" Rebind keys
nnoremap <C-]> <C-]>z<CR>
inoremap kj <ESC>

" Custom commands
nnoremap <leader>n :NoNeckPain<CR>
nnoremap <leader>m :NoNeckPainResize 120<CR>
nnoremap <leader>t :!gotags -R **/*.go > .tags<CR>
nnoremap <leader>sf <cmd>lua require('telescope.builtin').find_files()<CR>
nnoremap <leader>sg <cmd>lua require('telescope.builtin').live_grep()<CR>
nnoremap <leader>ss yiw:Telescope live_grep<CR><C-r>"<ESC>
nnoremap <leader>d :lua require('gtd.view_manager').show_views_list()<CR>
nnoremap <leader>t :call GoFunctionTop()<CR>
nnoremap <leader>f f
nnoremap <leader>h :noh<CR>
nnoremap <leader>o :norm o<ESC>0d$
nnoremap <leader>O O<ESC>0d$
nnoremap <leader>w :w<CR>


function! GoImports()
  let l:view = winsaveview()
  execute 'silent! %!goimports'
  call winrestview(l:view)
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

" Miscellanous
Plug 'https://tpope.io/vim/commentary.git' " Commenting

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

