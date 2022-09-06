set number
set splitbelow
set splitright
set autochdir
set wildmode=longest,list,full
set wildmenu
set title
set clipboard=unnamed
if executable('rg')
  set grepprg=rg\ --vimgrep\ --smart-case\ $*
else
  let &grepprg='grep -n -R --exclude=' . shellescape(&wildignore) . ' $*'
endif
syntax on

execute pathogen#infect('$VIM/vim82/bundle/{}')
execute pathogen#infect('$VIM/vim82/bundle2/{}')

set bg=dark
colorscheme gruvbox

" nnoremap <silent> <C-P> :FZF<CR>
nnoremap <silent> <C-S-E> :NERDTreeToggle<CR>
" nmap <silent> <C-S-F> :Rg<CR>
" nmap <silent> <C-S-F> :Grepper<CR>

" let g:floaterm_width = 0.7
" let g:floaterm_height  = 1.0
" let g:floaterm_opener = "edit"
" let g:floaterm_wintype = "split"

" prevent cmd sh.exe popup when invoke FZF ( window 7/10 https://github.com/junegunn/fzf/issues/2153 )
let $TERM = "cygwin"

" 
" toggle terminal with ctrl-`
" nmap <silent> <C-`> :FloatermToggle<CR>
" tmap <silent> <C-`> <C-W>:FloatermKill<CR>
" tmap <silent> <C-S-A> <C-W>:FloatermNew<CR>
" tmap <silent> <F1> <C-W>:FloatermPrev<CR>
" tmap <silent> <F2> <C-W>:FloatermNext<CR>

" move between split panes inside terminal vim 
nmap <silent> <C-S-H> :wincmd h<CR>
nmap <silent> <C-S-L> :wincmd l<CR>
nmap <silent> <C-S-J> :wincmd j<CR>
nmap <silent> <C-S-K> :wincmd k<CR>

function! PromptDir()
	let userinput=input("Directory> ", "", "file")
	if userinput != "~"
		execute 'Z '.userinput
	else
		cd "".userinput
	endif
endfunction

function! PFZF()
	execute ":call PromptDir()"
	if &buftype ==# 'terminal'
		execute ":hide enew"	
	endif
	" execute "call fzf#run({ 'sink': 'edit' })"
	execute "Files"
endfunction
nnoremap <silent> <C-P> :call PFZF()<CR>
tmap <silent> <C-P> <C-W>:call PFZF()<CR>

" function! PGrepper() abort
" 	let us=input("Directory> ", "", "file")
" 	execute "Z ". us
" 	execute "Grepper"
" endfunction
" nmap <silent> <C-S-F> :call PGrepper()<CR>

" redefine fzf.vim Rg command to exclude filename search result
command! -bang -nargs=* Rg call fzf#vim#grep("rg --column --line-number --no-heading --color=always --smart-case ".shellescape(<q-args>), 1, fzf#vim#with_preview({'options': '--delimiter : --nth 4..'}), <bang>0) 

function! PFZFGrep() abort
	execute ":call PromptDir()"
	if &buftype ==# 'terminal'
		execute ":hide enew"	
	endif
	execute ":Rg"
endfunction
nmap <silent> <F4> :call PFZFGrep()<CR>
tmap <silent> <F4> <C-W>:call PFZFGrep()<CR>

function! GoToBuffer()
       let as=input("Go to Buffer> ", "", "buffer")
       execute "b! ".as
endfunction

function! PromptName()
       if stridx(bufname(), "bin/bash") >= 0 || stridx(bufname(), "bin/sh") >= 0
               let us=input("Rename> ")
               execute "file ".us
       endif
endfunction

" buffer terminal quick swtich
function! RenameTermFile()
       execute ":call PromptName()"
       execute ":call GoToBuffer()"
endfunction

function! RenameTermNew()
       execute ":call PromptName()"
       execute "hide term ++curwin"
endfunction

nmap <silent> <C-Z> <C-W>:call GoToBuffer()<CR>
" alacritty doesnt support backtick call term, so use F1 instead
" nmap <silent> <C-`> :term ++curwin<CR>
" tmap <silent> <C-`> <C-W>:call RenameTermNew()<CR>
nmap <silent> <expr> <F1> winnr() != 1 ? ':only!<CR>:term! ++curwin<CR>' : ':term! ++curwin<CR>'
tmap <silent> <expr> <F1> winnr() != 1 ? '<C-W>:only!<CR><C-W>:call RenameTermNew()<CR>' : '<C-W>:call RenameTermNew()<CR>'

nmap <silent> <F2> <C-W>:vert term<CR>
tmap <silent> <F2> <C-W>:vert term<CR>
tmap <silent> <C-Z> <C-W>:call RenameTermFile()<CR>
tmap <silent> <F3> <C-W><S-N>
nmap <silent> <F3> i

" better keybinding for netrw
au FileType netrw nmap <buffer> h -
au FileType netrw nmap <buffer> l <CR>

" F1 = open new terminal in full screen
" F2 = split vertical terminal
" F3 = toggle between copy mode and terminal mode
" F4 = search text in files
" ctrl+p = quick open file
" ctrl+z = swtich buffer
