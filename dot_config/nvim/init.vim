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
let mapleader = " "

" Hybrid line numbers
set number
set relativenumber
nnoremap <leader>n :set relativenumber!<CR>

" \ disables the previous search
nnoremap \ :nohlsearch<CR>

" ###################################### Splits 

" Ctrl+T open current split in new tab
nnoremap <C-T> <C-W>T
" Ctrl+S saves current split
nnoremap <C-S> :w<CR>
" Ctrl+Q closes current split
nnoremap <C-Q> :q<CR>

" ###################################### Netrw (file browser)

" Remove the banner
let g:netrw_banner = 0
" Tree view
let g:netrw_liststyle = 3

" Provide custom bindings for netrw buffers
augroup netrw_mapping
  autocmd!
  autocmd filetype netrw call NetrwMapping()
augroup END

function! NetrwMapping()
	" Use the ctrl+l split navigation binding, erasing the original refresh shortcut
  nnoremap <buffer> <silent> <c-l> :wincmd l<cr>
endfunction
