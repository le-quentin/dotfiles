" #############################################################################
" #																PLUGINS																			#
" #############################################################################

call plug#begin('~/.config/nvim/plugins')

" Surroundings, to add verbs to delete/change/... surroundings
Plug 'tpope/vim-surround'

" Advanced repeat, to be able to repeat plugins action with .
Plug 'tpope/vim-repeat'

" vimpolyglot, to get syntax highlighting for 500+ file formats
Plug 'sheerun/vim-polyglot'

" vim-tmux-navigator, navigate vim and tmux panes with the same bindings (ctrl+direction)
Plug 'christoomey/vim-tmux-navigator'

call plug#end()

" #############################################################################
" #													GENERAL SETTINGS																	#
" #############################################################################

" Remap Leader to space key
:let mapleader = " "

" Hybrid line numbers
:set number
:set relativenumber
:nnoremap <leader>n :set relativenumber!<CR>

" \ disables the previous search
nmap \ :nohlsearch<CR>

" trigger `autoread` when files changes on disk
set autoread
autocmd FocusGained,BufEnter,CursorHold,CursorHoldI * if mode() != 'c' | checktime | endif
" notification after file change
autocmd FileChangedShellPost *
	\ echohl WarningMsg | echo "File changed on disk. Buffer reloaded." | echohl None
