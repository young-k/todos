" =============================================================================
" File:          syntax/todolist.vim
" Description:   Syntax for *.todo files
" Author:        Young Kim <github.com/young-k>
" =============================================================================

if exists("b:current_syntax")
  finish
endif

let b:current_syntax = "todo"

" syn match name ".*$"
syn keyword asterisk '*' 

syn match asterisk "*"
syn match header "*.*$" contains=asterisk

syn match unchecked "\[ \]"
syn match checked "\[●\]"
syn match recurring "(.*)"

hi def link asterisk       Statement
hi def link header         Type
hi def link unchecked      Unchecked
hi def link unchecked      Checked
hi def link recurring      Comment

highlight Unchecked ctermfg=red
highlight Checked   ctermfg=green
