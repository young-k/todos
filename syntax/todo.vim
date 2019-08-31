" =============================================================================
" File:          syntax/todolist.vim
" Description:   Syntax for *.todo files
" Author:        Young Kim <github.com/young-k>
" =============================================================================

if exists("b:current_syntax")
  finish
endif

let b:current_syntax = "todo"

syntax match asterisk "*"
syntax match header "*.*$" contains=asterisk

syntax match unchecked "\[ \]"
syntax match checked "\[●\]"

syntax match doublequote "\""
syntax match subheader "\".*$" contains=doublequote

highlight def link asterisk       Statement
highlight def link header         Type

highlight def link doublequote    Statement
highlight def link subheader      Type

highlight unchecked ctermfg=red
highlight checked   ctermfg=green
