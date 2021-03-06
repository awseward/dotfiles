" TODO: Figure out why I'd been disabling netrw
" " " Disable netrw
" let g:loaded_netrw = 1
" let g:netrw_loaded_netrwPlugin = 1

" Set leader key
let mapleader = " "

" When started as "evim", evim.vim will already have done these settings.
if v:progname =~? "evim"
  finish
endif

" Use Vim settings, rather than Vi settings (much better!).
" This must be first, because it changes other options as a side effect.
set nocompatible

" allow backspacing over everything in insert mode
set backspace=indent,eol,start

if has("vms")
  set nobackup    " do not keep a backup file, use versions instead
else
  set backup      " keep a backup file (restore to previous version)
  set undofile    " keep an undo file (undo changes after closing)
endif
set history=150   " keep 150 lines of command line history
set ruler         " show the cursor position all the time
set showcmd       " display incomplete commands
set incsearch     " do incremental searching

" For Win32 GUI: remove 't' flag from 'guioptions': no tearoff menu entries
" let &guioptions = substitute(&guioptions, "t", "", "g")

" Don't use Ex mode, use Q for formatting
map Q gq

" CTRL-U in insert mode deletes a lot.  Use CTRL-G u to first break undo,
" so that you can undo CTRL-U after inserting a line break.
inoremap <C-U> <C-G>u<C-U>

" In many terminal emulators the mouse works just fine, thus enable it.
"if has('mouse')
"  set mouse=a
"endif

" Switch syntax highlighting on, when the terminal has colors
" Also switch on highlighting the last used search pattern.
if &t_Co > 2 || has("gui_running")
  syntax on
  set hlsearch
endif

" Only do this part when compiled with support for autocommands.
if has("autocmd")

  " Enable file type detection.
  " Use the default filetype settings, so that mail gets 'tw' set to 72,
  " 'cindent' is on in C files, etc.
  " Also load indent files, to automatically do language-dependent indenting.
  filetype plugin indent on

  " Put these in an autocmd group, so that we can delete them easily.
  augroup vimrcEx
    au!

    " For all text files set 'textwidth' to 78 characters.
    autocmd FileType text setlocal textwidth=78

    " When editing a file, always jump to the last known cursor position.
    " Don't do it when the position is invalid or when inside an event handler
    " (happens when dropping a file on gvim).
    " Also don't do it when the mark is in the first line, that is the default
    " position when opening a file.
    autocmd BufReadPost *
          \ if line("'\"") > 1 && line("'\"") <= line("$") |
          \   exe "normal! g`\"" |
          \ endif

  augroup END

else

  set autoindent		" always set autoindenting on

endif " has("autocmd")

" Convenient command to see the difference between the current buffer and the
" file it was loaded from, thus the changes you made.
" Only define it when not defined already.
if !exists(":DiffOrig")
  command DiffOrig vert new | set bt=nofile | r ++edit # | 0d_ | diffthis
        \ | wincmd p | diffthis
endif

"
" Begin custom config
"

" vim.plug
if filereadable(expand("~/.vim/vimrc.plugins"))
  source ~/.vim/vimrc.plugins
endif

" filetype mappings
if filereadable(expand("~/.vim/vimrc.filetypes"))
  source ~/.vim/vimrc.filetypes

  " Keep vimrc.filetypes file aligned, sorted
  au BufWritePre vimrc.filetypes silent! call _CleanUpVimFiletypes() | redraw!
  function _CleanUpVimFiletypes()
    " align
    :1,$left
    :1,$EasyAlign *\
    " sort by filetype
    :sort iu /.*filetype=/
    " remove blank lines
    :g/^\s*$/d
  endfunction
endif

au BufWritePost *.dhall silent! call _DhallFormat() | redraw!
function _DhallFormat()
  !dhall --unicode format <afile>
  :e
endfunction

function _DhallFreeze()
  :silent exec "!dhall freeze %:p"
  :e!
  :redraw!
  :w
endfunction

command DhFr call _DhallFreeze()

if filereadable(expand("~/.vim/vimrc.languages"))
  source ~/.vim/vimrc.languages

  " NOTE: Commented this out because honestly it's a little bit much...
  "
  " " Keep vimrc.languages file aligned, sorted
  " au BufWritePre *vimrc.languages silent! call _CleanUpVimLanguages() | redraw!
  " function _CleanUpVimLanguages()
  "   " align
  "   :1,$left
  "   :1,$EasyAlign *\
  "   " sort
  "   :sort iu
  "   " remove blank lines
  "   :g/^\s*$/d
  " endfunction
endif

" Status bar
set laststatus=2

" File behavior
set backupdir=~/.local/share/vim/backups
set undodir=~/.local/share/vim/undofiles
set noswapfile
set wildmenu
set wildmode=list:longest

" Search options
set hlsearch
set ignorecase
set smartcase

" Indentation and spacing
set expandtab
set shiftwidth=2
set smartindent
set tabstop=2
set nojoinspaces

" Line numbers
set number

" Faster viewport scrolling
nnoremap <C-e> 4<C-e>
nnoremap <C-y> 4<C-y>

" Crosshair (CursorColumn)
set nocursorcolumn
set nocursorline

" Misc
set virtualedit=block

" Keep cursor centered when possible
" set scrolloff=999

" TODO: Consider whether this is even necessary. Can't remember the last time
"       I actually used `:grep`.
" Use ag for things
" if executable('rg')
"   set grepprg=rg\ --vimgrep\ --no-heading
"   " set grepformat=%f:%l:%c:%m,%f:%l:%m
" elseif executable('ag')
"   set grepprg=ag\ --nogroup\ --nocolor
"   " set grepformat=%f:%l:%c:%m,%f:%l:%m
" endif

if has('win16') || has('win32') || has('win64') || has('win32unix')
  " Ignore .gitignore files
  let g:ctrlp_user_command = ['.git', 'cd %s && git ls-files -co --exclude-standard']
else
  map <C-p> :Files<CR>
  if executable('rg')
    let $FZF_DEFAULT_COMMAND = 'rg --files --no-ignore-vcs --hidden'
  elseif executable('ag')
    let $FZF_DEFAULT_COMMAND = 'ag --files-with-matches --hidden -g ""'
  endif
endif

map <leader>B :Buffers<CR>
map <leader>E :bufdo! :e!<CR><CR>
map <leader>F :Filetypes<CR>
map <leader>f :Rg<Space>
map <leader>Q :bufdo! :bd!<CR><CR>
map <leader>q :bd!<CR><CR>
map <leader>R :source ~/.vimrc<CR>
map <leader>W :FixWhitespace<CR>:w<CR>
map <leader>p :Commands<CR>

"
" Colors
"
function! ApplyColorOverrides()
  if filereadable(expand("~/.vim/vimrc.color-overrides"))
    source ~/.vim/vimrc.color-overrides
  endif
endfunction

function! RandomColorSchemeWithOverrides()
  RandomColorScheme
  call ApplyColorOverrides()
endfunction

set t_Co=256

colorscheme paramount

if $LIGHT_SHELL != ""
  set background=light
else
  set background=dark
end

call ApplyColorOverrides()

" https://www.reddit.com/r/vim/comments/5416d0/true_colors_in_vim_under_tmux/
set termguicolors
let &t_8f = "\<Esc>[38;2;%lu;%lu;%lum"
let &t_8b = "\<Esc>[48;2;%lu;%lu;%lum"

map <leader>m :call RandomColorSchemeWithOverrides()<CR>
" Change colorschemes on `updatetime`ms of no input (normal & insert)
" autocmd CursorHold,CursorHoldI * call RandomColorSchemeWithOverrides()

" Enable vim-jsx
let g:jsx_ext_required = 0

" Rename current file (Gary Bernhardt)
function! RenameFile()
  let old_name = expand('%')
  let new_name = input('New file name: ', expand('%'), 'file')
  if new_name != '' && new_name != old_name
    exec ':saveas ' . new_name
    exec ':silent !rm ' . old_name
    redraw!
  endif
endfunction
map <Leader>n :call RenameFile()<cr>

" Tell syntastic to use eslint for javascript
let g:syntastic_javascript_checkers = ['eslint']

" Always start at top of file in commit message editor
autocmd FileType gitcommit call setpos('.', [0, 1, 1, 0])

" Evenly size splits on vim resize
autocmd VimResized * wincmd =

" Cursor crosshair
map <leader>c :set cursorcolumn!<Bar>set cursorline!<CR>

" Toggle relative line numbers
map <leader>r :set relativenumber!<CR>

" Rot13 whole buffer
map <leader>u ggg?G``

" Search for word under cursor with ripgrep
map <leader>g :Rg <C-R><C-W><CR>

" Clear highlights after a search
nnoremap <CR> :noh<CR><CR>

" Sort in visual, select modes (case-insensitive)
vmap <leader>s :sort iu<CR>

" Make sure :W doesn't trigger Windows from fzf-vim
command! W :w

" Map Ctrl-C to escape
inoremap <C-c> <Esc>

" Start interactive EasyAlign in visual mode (e.g. vipga)
xmap ga <Plug>(EasyAlign)

" Start interactive EasyAlign for a motion/text object (e.g. gaip)
nmap ga <Plug>(EasyAlign)

" Reload buffers
map <leader>e :set autoread <bar> :checktime <bar> :set noautoread<cr>

" macOS clipboard workaround (https://github.com/tmux/tmux/issues/543#issuecomment-248980734)
set clipboard=unnamed

" https://www.reddit.com/r/vim/comments/2om1ib/how_to_disable_sql_dynamic_completion/cmop4zh
let g:omni_sql_no_default_maps = 1

" https://vi.stackexchange.com/a/2956
let g:syntastic_mode_map = { 'passive_filetypes': ['python'] }

" https://github.com/frazrepo/vim-rainbow#simple-configuration
let g:rainbow_active = 1
au FileType diff call rainbow#clear()

" Adapted from https://web.archive.org/save/https://vim.fandom.com/wiki/Copy_filename_to_clipboard
" also with some help from https://stackoverflow.com/a/36501915 as well...
nnor ,cf :let @*=expand("%p")<CR>    " Copy file path      (relative)
nnor ,CF :let @*=expand("%:p")<CR>   "   ...               (absolute)
nnor ,cd :let @*=expand("%:.:h")<CR> " Copy directory path (relative)
nnor ,CD :let @*=expand("%:p:h")<CR> "   ...               (absolute)

" colorscheme fight-in-the-shade
let &colorcolumn=join(range(81,999),",")
highlight ColorColumn ctermbg=235 guibg=#222222
