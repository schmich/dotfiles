" Add user vimfiles directory to runtime path.
let g:vim_dir=expand("~/.vim/vimfiles")
execute "set rtp^=".g:vim_dir

" GUI settings: wider and taller window, solid cursor, hide the toolbar.
winpos 413 0
let g:molokai_original=1
set background=dark
colorscheme molokai
set guicursor=a:blinkwait0
set guioptions-=T
if has("gui_running")
  set lines=79 columns=120
  set cursorline
endif

set nocompatible
set autowrite
set backspace=2
set esckeys
set hidden
set joinspaces
set magic
set ruler
set showcmd
set showmode
set nostartofline
set textwidth=0
set whichwrap=b,s,h,l,<,>,[,]
set nowritebackup
set shiftwidth=2
set tabstop=2
set softtabstop=2
set expandtab
"set autoindent
set wildmenu
set wildmode=longest:full
set path+=./**
set indentkeys=0{,0},0),0],!^F,o,O,e 
filetype indent on

" Show line numbers
set number

" Automatically reload the vimrc when it is saved.
augroup vimrchooks
    au!
    autocmd BufWritePost .vimrc,_vimrc,vimrc,.gvimrc,_gvimrc,gvimrc source %
augroup END

" Quick vimrc access.
:command! Vimrc :sp $USERPROFILE\.vim\.vimrc

" Allow typos for quit/write commands.
:command! WQ wq
:command! Wq wq
:command! W w
:command! Q q

highlight flicker gui=bold guifg=white guibg=yellow
autocmd CursorMoved <buffer> exe 'match flicker /\V\<'.escape(expand('<cword>'), '/').'\>/'

" Better search settings (incremental, case-insensitive, no highlighting)
set incsearch
set ignorecase
set nohlsearch

" Show matching brackets/parenthesis when closing them.
set showmatch

" Turn off annoying error bells.
set noerrorbells
set visualbell
set t_vb=

" Automatically cd to the directory of the file being edited.
set autochdir

" No line wrapping
set nowrap

" Syntax highlighting on.
syntax on

" Treat .targets and .proj files as XML.
autocmd BufRead *.targets set filetype=xml
autocmd BufRead *.proj set filetype=xml
autocmd BufRead *.csproj set filetype=xml
autocmd BufRead *.nativeproj set filetype=xml
autocmd BufRead *.wixproj set filetype=xml
autocmd BufRead *.config set filetype=xml
autocmd BufRead *.rake set filetype=ruby

autocmd FileType c,cpp,java,perl,cs set ts=4 formatoptions=cro cindent smarttab tw=0 nowrap sidescroll=20 listchars=extends:$ expandtab
autocmd FileType php,perl set ts=4 formatoptions=cro smarttab tw=0 nowrap sidescroll=20 listchars=extends:$
autocmd FileType xml,xslt,xsl set shiftwidth=2 tabstop=2 softtabstop=2
autocmd FileType javascript,js set ts=2 sw=2 sts=0 expandtab

" A few additions for C++ syntax highlighting.
autocmd FileType c,cpp,h,hpp syn keyword Constant nullptr
autocmd FileType c,cpp,h,hpp syn keyword Keyword ref delegate gcnew override

" For C++, triple-slash inserts C#-style function comments.
autocmd FileType c,cpp,cs inor /// /// <summary><CR>/ <CR>/ </summary><ESC>kA

" Ruby-specific options
"   F5 to run the current program.
autocmd FileType ruby nnor <F5> :!start cmd /c ruby -I. % & pause<CR>
autocmd FileType ruby set shiftwidth=2 tabstop=2 softtabstop=2 expandtab
autocmd FileType ruby setlocal nosmartindent

autocmd FileType python set shiftwidth=4 tabstop=4 softtabstop=4 expandtab

" Do not expand tabs in makefiles.
autocmd FileType make set noexpandtab

" 2-space tabs for Decatur authoring
autocmd BufRead *.ddc,*.ddcg,*.ddp,*.ddf,*.wxl,*.wxs,*.wxi,*.dds,*.wixproj set shiftwidth=2 tabstop=2 softtabstop=2

" Tab autocompletion.
function! AutocompleteTab(dir)
      let col = col('.') - 1 
      if !col || getline('.')[col - 1] !~ '\k' 
          return "\<tab>" 
      else 
          if a:dir == 'f'
             return "\<c-n>" 
          else
             return "\<c-p>" 
          endif
      endif 
endfunction

" 's' for save
no s :w<CR>

" Use Ctrl+J in edit mode to escape back to command mode.
inor <C-j> <ESC>

" Easy move between buffers
map <S-Left> :bp<CR>
imap <S-Left> <C-O>:bp<CR>
map <S-Right> :bn<CR>
imap <S-Right> <C-O>:bn<CR>

" Space and backspace quick edit.
nnor <BS> hx
nnor <SPACE> i<SPACE><ESC>

"nnor <C-T> :tabe **/

" Make F12 the same as goto file.
nnor <F12> gf

" Ctrl+Tab/Ctrl+Shift+Tab to cycle through tabs.
nnor <C-Tab> :tabn<CR>
nnor <C-S-Tab> :tabp<CR>
inor <C-Tab> <C-O>:tabn<CR>
inor <C-S-Tab> <C-O>:tabp<CR>

vnor J j
vnor K k

imap <C-V> <C-O>"+gP
