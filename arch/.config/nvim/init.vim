"----------- Plugvim ------------
":PlugInstall
call plug#begin()
Plug 'scrooloose/nerdtree'
Plug 'ryanoasis/vim-devicons'
Plug 'tiagofumo/vim-nerdtree-syntax-highlight'
Plug 'sheerun/vim-polyglot'
Plug 'morhetz/gruvbox'
Plug 'easymotion/vim-easymotion'
Plug 'prettier/vim-prettier', { 'do': 'yarn install' }
Plug 'iamcco/markdown-preview.vim' 
Plug 'rhysd/vim-clang-format'
Plug 'powerman/vim-plugin-AnsiEsc'
Plug 'lervag/vimtex'
Plug 'tpope/vim-fugitive'
Plug 'nvim-lua/plenary.nvim'
Plug 'nvim-telescope/telescope.nvim'
call plug#end()
set tags=./tags;/

"----------- NerdTree -----------
syntax on
filetype plugin indent on
nnoremap <C-n> :NERDTreeToggle<CR>

"---------- Theme ---------
colorscheme gruvbox
set bg=dark
set notermguicolors

"---------- Window style ---------
let mapleader = "'"
set number
set relativenumber
set iskeyword&
set hlsearch
nnoremap ; :
set encoding=UTF-8

"----- Tabs
nnoremap <leader>t :tabedit<CR>

"----- Close brackets
inoremap {      {}<Left>
inoremap {<CR>  {<CR>}<Esc>O
inoremap {{     {
inoremap {}     {}

"------ Window movement
nnoremap <C-j> <C-w>j
nnoremap <C-k> <C-w>k
nnoremap <C-h> <C-w>h
nnoremap <C-l> <C-w>l

"------ Folding
nnoremap <leader>c zfa}
nnoremap <leader>o zo

"---------- Motion + Writing ---------
let g:EasyMotion_do_mapping = 0 " Disable default mappings
nmap <leader>s <Plug>(easymotion-overwin-f2)
nnoremap <leader>d :Telescope find_files<CR>

map <C-k> <C-u>
map <C-j> <C-d>
autocmd FileType nerdtree map <buffer> <C-k> <C-u>
autocmd FileType nerdtree map <buffer> <C-j> <C-d>

" Copy/paste clipboard
vmap <leader>c :w !xclip -sel clip<CR><CR>
nnoremap <leader>v :r !xclip -o -sel clip<CR>

" Remember where cursor was in each file
augroup remember_cursor_position
  autocmd!
  autocmd BufReadPost *
        \ if &ft != 'commit' && line("'\"") > 1 && line("'\"") <= line("$") |
        \   exe "normal! g`\"" |
        \ endif
augroup END


"----------- Code style ------------
set tabstop=4
set softtabstop=4
set shiftwidth=4
set expandtab

set cindent
set cinoptions=g0

"----------- Syntax ------------
" Asm
augroup twig_ft
  au!
  autocmd BufNewFile,BufRead *.s set syntax=asm
augroup END

" ASL (Atta shading language)
au BufRead,BufNewFile *.asl set filetype=glsl

" Vulkan
autocmd FileType cpp,c source ~/.config/nvim/syntax/vulkan.vim

" Spell check
set spell spelllang=en_us

" Clang format
autocmd FileType h,hpp,c,cpp,inl,tcc nnoremap <leader>f :<C-u>ClangFormat<CR>
autocmd FileType h,hpp,c,cpp,inl,tcc vnoremap <leader>f :ClangFormat<CR>
autocmd FileType ts,js,py,json nnoremap <leader>f mfgg=G`f
let g:clang_format#detect_style_file = 1

" Git diff
autocmd FileType diff AnsiEsc

" No highlight
noremap <leader>h :set hlsearch!<CR>

"----------- Preview ------------
" Markdown
noremap <leader>m :MarkdownPreview<Enter>

" Latex
let g:vimtex_view_method = 'zathura'
let g:vimtex_compiler_latexmk = {
  \ 'build_dir' : 'build',
  \ 'options': [
    \ '-shell-escape',
    \ '-outdir=build',
    \ '-pdf',
    \ '-interaction=nonstopmode',
    \ '-file-line-error',
    \ '-synctex=1',
    \ ]
  \}

"----------- Code Generation ------------
" Guide navigation
noremap ,m <Esc>/<++><Enter>cf>
inoremap ,m <Esc>/<++><Enter>cf>
vnoremap ,m <Esc>/<++><Enter>cf>

" C++
autocmd FileType cpp,c inoremap ,fun (<++>)<CR>{<CR><++><CR><Backspace><Backspace>}<CR><CR><++><Esc>?(<++>)<CR>i
autocmd FileType cpp,c inoremap ,if if(<++>)<CR>{<CR><++><CR><Backspace><Backspace>}<CR><CR><++><Esc>?<++>)<CR>cf>
autocmd FileType cpp,c inoremap ,while while(<++>)<CR>{<CR><++><CR><Backspace><Backspace>}<CR><CR><++><Esc>?<++>)<CR>cf>
autocmd FileType cpp,c inoremap ,for for(<++>; <++>; <++>)<CR>{<CR><++><CR><Backspace><Backspace>}<CR><CR><++><Esc>?(<++><CR>lcf>
