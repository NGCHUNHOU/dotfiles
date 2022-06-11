set number
set splitbelow
set splitright
set autochdir
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
nmap <silent> <C-S-F> :Grepper<CR>

let g:floaterm_width = 0.7
let g:floaterm_height  = 1.0

" toggle terminal with ctrl-`
nmap <silent> <C-`> :FloatermToggle<CR>
tmap <silent> <C-`> <C-W>:FloatermKill<CR>
tmap <silent> <C-S-A> <C-W>:FloatermNew<CR>
tmap <silent> <F1> <C-W>:FloatermPrev<CR>
tmap <silent> <F2> <C-W>:FloatermNext<CR>

function! PFZF()
	let userinput=input('Directory> ')
	execute 'Z '.userinput
	execute "call fzf#run({ 'sink': 'tabe' })"
endfunction

nnoremap <silent> <C-P> :call PFZF()<CR>
