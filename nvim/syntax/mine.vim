" Define hBlock as a contained syntax item
syntax match hBlock /h:(.\{-})/ "\{-} is vim non-greedy * regex

" Define resultBlock as a region starting from → and ending at the end of the
" line and specify that it contains hBlock
syntax region resultBlock start=/→/ end=/$/ contains=hBlock

" Set styling
highlight resultBlock ctermfg=blue
highlight hBlock ctermfg=red

