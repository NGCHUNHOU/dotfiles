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

" nnoremap <silent> <C-P> :FZF<CR>
nnoremap <silent> <C-S-E> :NERDTreeToggle<CR>
" nmap <silent> <C-S-F> :Rg<CR>
" nmap <silent> <C-S-F> :Grepper<CR>

" let g:floaterm_width = 0.7
" let g:floaterm_height  = 1.0
" let g:floaterm_opener = "edit"
" let g:floaterm_wintype = "split"
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

function! PFZF()
	let userinput=input("Directory> ", "", "file")
	execute 'Z '.userinput
	execute "call fzf#run({ 'sink': 'tabe' })"
endfunction
nnoremap <silent> <C-P> :call PFZF()<CR>

function! PGrepper() abort
	let us=input("Directory> ", "", "file")
	execute "Z ". us
	execute "Grepper"
endfunction
nmap <silent> <C-S-F> :call PGrepper()<CR>

" buffer terminal quick swtich
function! RenameTermAndLeave()
       if stridx(bufname(), "bash") >= 0
               let us=input("Rename> ")
               execute "file ".us
       endif
       let as=input("Go to Buffer> ", "", "buffer")
       execute "b! ".as
endfunction

nmap <silent> <C-`> :term ++curwin<CR>
tmap <silent> <C-`> <C-W>:call RenameTermAndLeave()<CR>
tmap <silent> <F3> <C-W><S-N>
nmap <silent> <F3> i
