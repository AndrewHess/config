set runtimepath^=~/.vim runtimepath+=~/.vim/after
let &packpath = &runtimepath

set tabstop=4 softtabstop=0 expandtab shiftwidth=4 smarttab
autocmd FileType make setlocal noexpandtab tabstop=4 shiftwidth=4
autocmd FileType yaml setlocal shiftwidth=2 softtabstop=2 expandtab

" Run goimports when saving a .go file
" autocmd BufWritePost *.go execute 'silent! !goimports -w ' . shellescape(expand('%:p')) | e
autocmd BufWritePre *.go execute 'call GoImports()'

" Activate syntax highlighting
autocmd BufRead,BufNewFile *.peg set filetype=pigeon
autocmd BufRead,BufNewFile *.mine set filetype=mine

:syntax on
:set ruler
:set number
:set colorcolumn=80,100
:set foldmethod=manual
:set mouse=
:set tags+=./tags
:set wildmenu
:set history=1000

nnoremap <leader>f :call GoImports()<CR>
nnoremap <leader>n :NoNeckPain<CR>
nnoremap <leader>m :NoNeckPainResize 100<CR>

function! GoImports()
  let l:view = winsaveview()
  execute 'silent! %!goimports'
  call winrestview(l:view)
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

" fzf for searching
Plug 'junegunn/fzf', { 'do': { -> fzf#install() } }
Plug 'junegunn/fzf.vim'

" no-neck-pain for centering windows
Plug 'shortcuts/no-neck-pain.nvim', { 'tag': '*' }

" Copilot
Plug 'github/copilot.vim'

" Gotham theme
Plug 'whatyouhide/vim-gotham'

" Initialize plugin system
" - Automatically executes `filetype plugin indent on` and `syntax enable`.
call plug#end()
" You can revert the settings after the call like so:
"   filetype indent off   " Disable file-type-specific indentation
"   syntax off            " Disable syntax highlighting

filetype indent off

" Set the color scheme
colorscheme alduin  " From https://github.com/AlessandroYorba/Alduin
"colorscheme gotham256

source ~/.config/nvim/syntax/mine.vim


