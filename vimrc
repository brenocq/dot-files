"----------- Plugvim ------------
":PlugInstall
call plug#begin()
Plug 'scrooloose/nerdtree'
Plug 'vim-airline/vim-airline'
Plug 'vim-airline/vim-airline-themes'
Plug 'joshdick/onedark.vim'
Plug 'sheerun/vim-polyglot'
Plug 'morhetz/gruvbox'
Plug 'chiel92/vim-autoformat'
Plug 'easymotion/vim-easymotion'
Plug 'mattn/emmet-vim'
call plug#end()

"----------- NerdTree -----------
syntax on
filetype plugin indent on
nnoremap <C-n> :NERDTreeToggle<CR>
"---------- Theme ---------
colorscheme gruvbox
set bg=dark
"colorscheme onedark
"match keyword "\v<[A-Z]+>" 
"---------- My commands ---------
set number
set relativenumber
set tabstop=4
no <down> ddp 
no <left> <Nop>
no <right> <Nop>
no <up> ddkP
ino <down> <Nop>
ino <left> <Nop>
ino <right> <Nop>
ino <up> <Nop>
"---------- Motion + Writing ---------
let g:EasyMotion_do_mapping = 0 " Disable default mappings
nmap s <Plug>(easymotion-overwin-f2)

let g:user_emmet_leader_key=','
