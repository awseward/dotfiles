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
set history=500   " keep 500 lines of command line history
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

" Disable mouse
set mouse=

" Switch syntax highlighting on, when the terminal has colors
" Also switch on highlighting the last used search pattern.
if &t_Co > 2 || has("gui_running")
  syntax on
  set hlsearch
endif

" Only do this part when compiled with support for autocommands.
if has("autocmd")
  autocmd Filetype sql setlocal expandtab tabstop=2 shiftwidth=2 softtabstop=2

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
  function _CleanUpVimFiletypes()
    " align
    :1,$left
    :1,$EasyAlign *\
    " sort by filetype
    :sort iu /.*filetype=/
    " remove blank lines
    :g/^\s*$/d
  endfunction

  augroup FiletypesFileCleanup
    au!
    au BufWritePre vimrc.filetypes silent! call _CleanUpVimFiletypes() | redraw!
  augroup END
endif

if filereadable(expand("~/.vim/vimrc.languages"))
  source ~/.vim/vimrc.languages

  " " Keep vimrc.languages file aligned, sorted
  function _CleanUpVimLanguages()
    " align
    :1,$left
    :1,$EasyAlign *\
    " sort
    :sort iu
    " remove blank lines
    :g/^\s*$/d
  endfunction

  augroup LanguagesFileCleanup
    au!
    au BufWritePre *vimrc.languages silent! call _CleanUpVimLanguages() | redraw!
  augroup END
endif

" Status bar
set laststatus=2

" File behavior
if has('nvim')
  set backupdir=~/.local/share/nvim/backups
  set   undodir=~/.local/share/nvim/undofiles
else
  set backupdir=~/.local/share/vim/backups
  set   undodir=~/.local/share/vim/undofiles
end
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

if has('win16') || has('win32') || has('win64') || has('win32unix')
  " Ignore .gitignore files
  let g:ctrlp_user_command = ['.git', 'cd %s && git ls-files -co --exclude-standard']
else
  map <C-p> :Files<CR>
  if executable('rg')
    let $FZF_DEFAULT_COMMAND = 'rg --files --hidden'
    " let $FZF_DEFAULT_COMMAND = 'rg --files --no-ignore-vcs --hidden'
  elseif executable('ag')
    let $FZF_DEFAULT_COMMAND = 'ag --files-with-matches --hidden -g ""'
  endif
endif

nnoremap <silent> ca <cmd>lua vim.lsp.buf.code_action()<CR>

" TODO: (See if this can be sped up a bit, it's suuuper slow)
let g:rg_command = 'rg --sort-files --vimgrep'

map <leader>b :Buffers<CR>
map <leader>E :bufdo! :e!<CR><CR>
map <leader>F :Filetypes<CR>
map <leader>f :Rg<Space>
map <leader>Q :bufdo! :bd!<CR><CR>
map <leader>q :bufdo :bd<CR><CR>
map <leader>R :source ~/.vimrc<CR>
map <leader>W :FixWhitespace<CR>:w<CR>
map <leader>p :Commands<CR>
map <leader>h :History<CR>

"
" Colors
"
set t_Co=256

colorscheme photon

" https://www.reddit.com/r/vim/comments/5416d0/true_colors_in_vim_under_tmux/
set termguicolors
let &t_8f = "\<Esc>[38;2;%lu;%lu;%lum"
let &t_8b = "\<Esc>[48;2;%lu;%lu;%lum"

let &colorcolumn=join(range(81,999),",")
highlight ColorColumn ctermbg=235 guibg=#222222

" Rename current file (Gary Bernhardt) – TODO: Find a source link for this
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
" https://stackoverflow.com/a/24931292/1148594
let g:omni_sql_no_default_maps = 1
let g:ftplugin_sql_omni_key = '<Plug>DisableSqlOmni'

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

" ¯\_(ツ)_/¯ Might be good to have this as a foothold someday
" See also: https://github.com/nanotee/nvim-lua-guide#using-lua-from-vimscript
if has('nvim')
  :lua require('init')
end

" Copied this from whatever old vim was defaulting to, but the height
" modifiers don't seem to be working…
set guicursor=n-v-c:block,o:hor50,i-ci:hor15,r-cr:hor30,sm:block

" TODO: Improve this — will probably just end up on CoC to be honest…
" This line (https://github.com/codota/tabnine-vim/blob/e27face391a4d9a3e43ff251010f77deddf0c88d/autoload/youcompleteme.vim#L142)
" causes the command-line buffer (`q:`) to be VERY slow to come up, so for now
" all I''m doing is commenting it out in the location that vim-plug installs
" it to. I'm doing this mainly because there's no good way I can discern to
" just cleanly disable that one particular autocommand

" https://github.com/vim-ruby/vim-ruby#usage
:let g:ruby_indent_hanging_elements = 0
:let g:ruby_indent_assignment_style = 'variable'

let g:markdown_fenced_languages = ['html', 'python', 'ruby', 'vim', 'bash', 'shell', 'sh']
set shiftround

" " Move lines around (https://vimtricks.com/p/vimtrick-moving-lines/)
" nnoremap <c-j> :m .+1<CR>==
" nnoremap <c-k> :m .-2<CR>==
" inoremap <c-j> <Esc>:m .+1<CR>==gi
" inoremap <c-k> <Esc>:m .-2<CR>==gi
" vnoremap <c-j> :m '>+1<CR>gv=gv
" vnoremap <c-k> :m '<-2<CR>gv=gv

" Not sure why I have had to add this in explicitly (it used to just work),
" but I grabbed it from here: https://github.com/vim/vim/blob/66f65a46c5d169f20f780721d4f74d4729855b96/runtime/syntax/gitcommit.vim#L108C2-L108C38
hi def link gitcommitOverflow Error
