" =============================================================================
" File:          plugin/todolist.vim
" Description:   Simple todolist manager
" Author:        Young Kim <github.com/young-k>
" =============================================================================
 
" Initializes plugin settings and mappings
function! s:init()
  set filetype=todo
  setlocal tabstop=2
  setlocal shiftwidth=2 expandtab
  setlocal cursorline
  setlocal noautoindent
  setlocal nonumber
endfunction

function! s:newfile()
  let day = 0
  let lst = []

  call add(lst, '* Inbox')
  call add(lst, '')

  while day < 7
    let datequery = "date -v '+" . string(day) . "d' '+%a %b %d'"
    let datestr = system(datequery)[0:-2]

    if day == 0
      let datestr = "Today"
      let datestr .= ' [' . system(datequery)[0:-2] . ']'
    elseif day == 1
      let datestr = "Tomorrow"
      let datestr .= ' [' . system(datequery)[0:-2] . ']'
    endif

    call add(lst, '* ' . datestr)
    call add(lst, '')
    let day += 1
  endwhile
  call append(0, lst)
  normal! gg
endfunction

function! s:createitem(dir)
  if a:dir == 1
    normal! o  [ ] 
  else
    normal! O  [ ] 
  endif
  startinsert!
endfunction

function! s:toggle()
  let currentline = getline(".")
  let save_pos = getpos(".")

  if matchstr(currentline, '\[●\]') != ''
    let save_pos[2] -= 2
    call setline('.', substitute(currentline, '\[●\]', '[ ]', ''))
  elseif matchstr(currentline, '\[ \]') != ''
    let save_pos[2] += 2
    call setline('.', substitute(currentline, '\[ \]', '[●]', ''))
  endif

  call setpos('.', save_pos)
endfunction

" Sets mappings
function! s:map()
  nnoremap <buffer> O :call <SID>createitem(0)<CR>
  nnoremap <buffer> o :call <SID>createitem(1)<CR>
  nnoremap <buffer> t :call <SID>toggle()<CR>
  inoremap <buffer> <CR> <ESC>:call <SID>createitem(1)<CR>
endfunction

" Resets mappings
function! s:resetmap()
  silent! nunmap <buffer> o
  silent! nunmap <buffer> O
  silent! nunmap <buffer> t
  silent! iunmap <buffer> i
endfunction

function! s:savefile()
  let alltodos = []
  let todos = []
  let currdate = 'Inbox'

  for currline in getline(2, '$') " Skip Inbox
    let date = matchstr(currline, '\D\{3}\s\D\{3}\s\d\{2}')

    if date != '' " date str
      " Add all todos before resetting data
      call add(alltodos, currdate)
      for t in todos
        call add(alltodos, t)
      endfor

      let todos = []
      let currdate = date
    elseif matchstr(currline, '\S') != '' " non-white space string
      if matchstr(currline, '●') != ''
        let todostr = currline[8:]
      else 
        let todostr = currline[6:]
      endif
      call add(todos, todostr)
    endif

  endfor

  call add(alltodos, currdate)
  for t in todos
    call add(alltodos, t)
  endfor

  call writefile(alltodos, '.todo')
endfunction

" Plugin startup code
if !exists('g:todolist')
  " TODO: fill this in

  " Autocommands
  augroup todolist#todolist_group
    autocmd!
    autocmd BufRead,BufNewFile *.todo call s:init()
    autocmd BufNewFile *.todo call s:newfile()
    autocmd BufRead,BufNewFile *.todo call s:map()
    autocmd BufLeave *.todo call s:resetmap()
    autocmd BufWrite *.todo call s:savefile()
  augroup end
endif
