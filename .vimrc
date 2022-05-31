scriptencoding utf-8
set encoding=utf-8
set laststatus=2
set showtabline=1
set t_Co=256
set path+=**
set number
set list
set listchars=tab:\|\\u202F,trail:\\u202F
set wildmenu
let g:airline_powerline_fonts=1
"let g:tmuxline_preset = 'nightly_fox'
let g:airline_theme='deus'
set rtp+=~/.fzf
call plug#begin()  "Use :PlugInstall when adding here new plugins.
Plug 'fatih/vim-go'
Plug 'junegunn/fzf.vim'
Plug 'godlygeek/tabular'
Plug 'preservim/vim-markdown'
Plug 'nightsense/cosmic_latte'
Plug 'vim-airline/vim-airline'
Plug 'vim-airline/vim-airline-themes'
Plug 'scrooloose/nerdtree'
Plug 'tpope/vim-surround'
Plug 'tpope/vim-repeat'
Plug 'justinmk/vim-sneak'
call plug#end()
"install also pathogen
execute pathogen#infect()

filetype plugin indent on
"syntax disable
nnoremap <Leader>y "+
vnoremap <C-c> "+y
vnoremap <C-d> "+d
inoremap <C-v> <ESC>"+pa
" Substitute in line
vnoremap gs "zy:s/<C-r>z//g<Left><Left>
nnoremap gs "zyiw:s/<C-r>z//g<Left><Left>
nnoremap <expr> <silent> 0 col('.') == match(getline('.'),'\S')+1 ? '0' : '^'
"============== Custom Mappings ===============
"" general mapping
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
map <leader>[ :qa!<CR>
map <leader>s :w<CR>
nnoremap <silent> <Leader><Left> :vertical resize +3<CR>
nnoremap <silent> <Leader><Right> :vertical resize -3<CR>
nnoremap <silent> <Leader><Up> :resize -3<CR>
nnoremap <silent> <Leader><Down> :resize +3<CR>
" Set buffer hidden (non recording)
nnoremap <Leader>h :set hidden<CR>
nnoremap <Leader>H :set confirm<CR>
"Moving lines up|down
nnoremap <c-j> :m .+1<CR>==
nnoremap <c-l> :m .-2<CR>==
inoremap <c-j> <Esc>:m .+1<CR>==gi
inoremap <c-l> <Esc>:m .-2<CR>==gi
vnoremap <c-j> :m '>+1<CR>gv=gv
vnoremap <c-l> :m '<-2<CR>gv=gv

noremap <leader>n :set relativenumber!<CR>

"Map to special slavic latin characters.
nnoremap <leader>z a[ŽžŠšĆćČč]<esc>hhh
nnoremap <leader>x dbXldvw<CR>
inoremap <leader>z <C-O>a[ŽžŠšĆćČč]<esc>hhhi
inoremap <leader>x <C-O>db<C-O>X<C-O>l<C-O>dvw

" It's useful to show the buffer number in the status line.
set laststatus=2 statusline=%02n:%<%f\ %h%m%r%=%-14.(%l,%c%V%)\ %P
set cul
"run into scratch buffer with :R cmd or use :read cmd to insert.
command! -nargs=* -complete=shellcmd R new | setlocal buftype=nofile bufhidden=hide noswapfile | r !<args>
set mouse=a
"literal pasting mode, this disables insert mode mappings. if set.
"set paste
"run bash command
"map <F5> yyp!!sh<CR><Esc>
"Execute selection and display in new tab
vnoremap <F2> y:tabnew <Bar> r! <C-R>0<BACKSPACE><CR>
set splitright
vnoremap <F3> y:vsplit new <Bar> setlocal buftype=nofile bufhidden=hide noswapfile <Bar> r! <C-R>0<BACKSPACE><CR>
"Following needed to get .bashrc loaded
set shellcmdflag=-ic

function! CursorLineNrOn() abort
  if &number || &relativenumber
    hi CursorLineNr ctermfg=white ctermbg=black guifg=red guibg=black cterm=underline
  endif
  return ''
endfunction

function! CursorLineNrOff() abort
  if &number || &relativenumber
    "hi CursorLineNr ctermbg=dark"ctermfg=blue ctermbg=black guifg=blue guibg=black
    hi clear CursorLineNr
    hi CursorLineNr cterm=underline"color cosmic_latte 
  endif
  return ''
endfunction

autocmd ModeChanged *:[vV\x16]* call CursorLineNrOn()
autocmd ModeChanged [vV\x16]*:* call CursorLineNrOff()
augroup AutoHighlighting
    au!
    autocmd CmdlineEnter /,\? set hlsearch
    autocmd CmdlineLeave /,\? set nohlsearch
augroup EN
set guicursor=i:ver25-iCursor
set background=dark
colorscheme cosmic_latte
set grepprg=rg\ --vimgrep\ --smart-case\ --follow

silent! call repeat#set("\<Plug>MyWonderfulMap", v:count)

"This file originates from https://github.com/wbudic/wb-shell-scripts
