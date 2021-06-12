set laststatus=2
set showtabline=1
set t_Co=256
set path+=**
set number
set wildmenu
set background=dark
set shellcmdflag=-ic
set lazyredraw
set splitright
set mouse=a
set paste
set clipboard^=unnamed
filetype plugin indent on

set rtp+=~/home/will/dev/fzf/bin/fzf
set rtp+=~/.fzf

call plug#begin()
Plug '~/.fzf'
Plug 'junegunn/fzf.vim'
Plug 'nightsense/cosmic_latte'
Plug 'skywind3000/asyncrun.vim'
Plug 'skywind3000/vim-preview'
Plug 'skywind3000/gutentags'
Plug 'skywind3000/gutentags_plus'
call plug#end()

execute pathogen#infect()
"quick pairs
imap <leader>' ''<ESC>i
imap <leader>" ""<ESC>i
imap <leader>( ()<ESC>i
imap <leader>[ []<ESC>i

nmap <leader><Tab> :tabnext<CR>
nmap <leader><C-S-Tab> :tabprevious<CR>
map <C-S-Tab> :tabprevious<CR>
map <C-Tab> :tabnext<CR>
imap <C-S-Tab> <ESC>:tabprevious<CR>
imap <C-Tab> <ESC>:tabnext<CR>
noremap <F7> :set expandtab!<CR>
nnoremap th  :tabfirst<CR>
nnoremap tj  :tabnext<CR>
nnoremap tk  :tabprev<CR>
nnoremap tl  :tablast<CR>
nnoremap tt  :tabedit<Space>
nnoremap tn  :tabnext<CR>
nnoremap tm  :tabm<Space>
nnoremap td  :tabclose<CR>
nnoremap tc  :tabnew<Space>
" Mappings to access buffers (don't use "\p" because a
" delay before pressing "p" would accidentally paste).
" \l       : list buffers
" \b \f \g : go back/forward/last-used
" \1 \2 \3 : go to buffer 1/2/3 etc
nnoremap <Leader>l :ls<CR>
nnoremap <Leader>g :e#<CR>
nnoremap <Leader>1 :1b<CR>
nnoremap <Leader>2 :2b<CR>
nnoremap <Leader>3 :3b<CR>
nnoremap <Leader>4 :4b<CR>
nnoremap <Leader>5 :5b<CR>
nnoremap <Leader>6 :6b<CR>
nnoremap <Leader>7 :7b<CR>
nnoremap <Leader>8 :8b<CR>
nnoremap <Leader>9 :9b<CR>
nnoremap <Leader>0 :10b<CR>
"fzf stuff
nnoremap <leader>f :Files .<CR>
nnoremap <leader>b :Buffers<CR>
imap <c-x><c-l> <plug>(fzf-complete-line)

"[F1] Taken by vim Help.
"[F2] Taken by fzf pluggin.
vnoremap <F3> y:AsyncRun -mode=term -pos=left <C-R>0<BS><CR><C-W><RIGHT>
nnoremap <F3> :AsyncRun -mode=term -pos=right ./%<CR>
nnoremap <F4> :AsyncRun -mode=term -pos=right %
let g:asyncrun_open = 15
nnoremap <F5> :FZF ~<CR>  
nnoremap <F6> :AsyncRun -mode=term -pos=bottom ~/dev/B_L_R_via_sshfs/backup.sh
vnoremap <F6> :AsyncRun -mode=term -pos=bottom ~/dev/B_L_R_via_sshfs/backup.sh
" vnoremap <F2> y:tabnew <Bar> r! <C-R>0<BACKSPACE><CR>
"vnoremap <F6> y:vsplit new <Bar> setlocal buftype=nofile bufhidden=hide noswapfile <Bar> r! <C-R>0<BS><CR>

" Set buffer hidden (non recording)
nnoremap <Leader>h :set hidden<CR>
nnoremap <Leader>H :set confirm<CR>
" Open tag in vertical edit split. For buffers switch default is <C-c>]
nnoremap <leader>] :vsplit<CR><C-]>
nnoremap <leader>[ :q<CR>
" It's useful to show the buffer number in the status line.
set laststatus=2 statusline=%02n:%<%f\ %h%m%r%=%-14.(%l,%c%V%)\ %P
"run into scratch buffer with :R cmd or use :read cmd to insert.
command! -nargs=* -complete=shellcmd R new | setlocal buftype=nofile bufhidden=hide noswapfile | r !<args>
vnoremap <C-c> "+y
vnoremap <C-d> "+d
inoremap <C-v> <ESC>"+pa
xnoremap <leader>y "+r
xnoremap <leader>p "+p
nnoremap <leader>yf <cmd>let @+=expand('%')<cr>

autocmd FileType perl set makeprg=/usr/bin/perl\ -c\ %\ $*
autocmd FileType perl set errorformat=%f:%l:%m
autocmd FileType perl set autowrite
autocmd BufWritePost *.pl,*.pm,*.t :make 

colorscheme cosmic_latte
map <C-S> :w<CR>
