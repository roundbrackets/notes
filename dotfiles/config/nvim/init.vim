filetype plugin indent on
syntax enable
set foldmethod=syntax

set tabstop=2
set shiftwidth=2
set sw=2
set expandtab
set number
set history=500
set ruler
set cursorcolumn
set cursorline

" load lua plugins
lua require('config/lazy')
" lua require("virt-column").setup()

autocmd BufReadPost *
 \ let line = line("'\"")
 \ | if line >= 1 && line <= line("$") && &filetype !~# 'commit'
 \      && index(['xxd', 'gitrebase'], &filetype) == -1
 \ |   execute "normal! g`\""
 \ | endif

" Convenient command to see the difference between the current buffer and the
" file it was loaded from, thus the changes you made.
" Only define it when not defined already.
" Revert with: ":delcommand DiffOrig".
if !exists(":DiffOrig")
  command DiffOrig vert new | set bt=nofile | r ++edit # | 0d_ | diffthis
		  \ | wincmd p | diffthis
endif

if has("autocmd")
  autocmd FileType yaml setlocal ts=2 sts=2 sw=2 expandtab 
  autocmd FileType python setlocal ts=4 sts=4 sw=4 expandtab fileencoding=utf-8 fileformat=unix foldmethod=indent
  autocmd FileType php setlocal ts=2 sts=2 sw=2 expandtab
endif

" Allow backspacing over everything in insert mode.
"set backspace=indent,eol,start
"
"set showcmd		" display incomplete commands
"set wildmenu		" display completion matches in a status line
"
"set ttimeout		" time out for key codes
"set ttimeoutlen=100	" wait up to 100ms after Esc for special key
"
"" Show @@@ in the last line if it is truncated.
"set display=truncate
"
"" Show a few lines of context around the cursor.  Note that this makes the
"" text scroll if you mouse-click near the start or end of the window.
"set scrolloff=5
"
"" Do incremental searching when it's possible to timeout.
"if has('reltime')
"  set incsearch
"endif
"
"" Do not recognize octal numbers for Ctrl-A and Ctrl-X, most users find it
"" confusing.
"set nrformats-=octal
"
"" In many terminal emulators the mouse works just fine.  By enabling it you
"" can position the cursor, Visually select and scroll with the mouse.
"" Only xterm can grab the mouse events when using the shift key, for other
"" terminals use ":", select text and press Esc.
"if has('mouse')
"  if &term =~ 'xterm'
"    set mouse=a
"  else
"    set mouse=nvi
"  endif
"endif
