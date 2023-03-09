set tabstop=2 softtabstop=0 expandtab shiftwidth=2 smarttab
autocmd FileType make setlocal noexpandtab tabstop=4 shiftwidth=4

:syntax on
:set ruler
:set number

" Custom key bindings.
inoremap <expr> ) CloseExpr()
" Add a way to type ')' even if nothing's hanging.
inoremap ;) )

function! CloseExpr()
  let pos_initial = getpos('.')
  let paren = searchpairpos('(', '', ')', 'b', '', 'n')
  call setpos('.', pos_initial)
  let curly = searchpairpos('{', '', '}', 'b', '', 'n')
  call setpos('.', pos_initial)
  let square = searchpairpos('\[', '', '\]', 'b', '', 'n')

  " Figure out which type was most recently opened.
  let pos = reduce([paren, curly, square], { a, e -> s:PosGreaterThan(a, e) ? a : e })

  " Check if all previous expressions are already closed.
  if s:PosEquals(pos, [0, 0])
    echom "Nothing to close"
    return ""
  endif
  
  " Write the closing token.
  if s:PosEquals(pos, paren)
    return ")"
  elseif s:PosEquals(pos, curly)
    return "}"
  elseif s:PosEquals(pos, square)
    return "]"
  else
    echom "Something's wrong"
  endif
endfunction

function! s:PosGreaterThan(p1, p2)
  call assert_equal(len(a:p1), 2)
  call assert_equal(len(a:p2), 2)
  return (a:p1[0] > a:p2[0] || (a:p1[0] == a:p2[0] && a:p1[1] > a:p2[1]))
endfunction

function! s:PosEquals(p1, p2)
  call assert_equal(len(a:p1), 2)
  call assert_equal(len(a:p2), 2)
  return a:p1[0] == a:p2[0] && a:p1[1] == a:p2[1]
endfunction

" Set the color scheme
" :color pablo
colorscheme alduin  " From https://github.com/AlessandroYorba/Alduin
