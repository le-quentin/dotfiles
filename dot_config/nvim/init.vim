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

" nvim-tree, replacing netrw for sweet sweet file navigation in a pane
Plug 'nvim-tree/nvim-web-devicons' " optional, for file icons
Plug 'nvim-tree/nvim-tree.lua'

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
nnoremap <silent> \ :nohlsearch<CR>

" ###################################### Splits 
" Ctrl+T open current split in new tab
nnoremap <C-T> <C-W>T
" Ctrl+S saves current split
nnoremap <C-S> :w<CR>
" Ctrl+Q closes current split
nnoremap <C-Q> :q<CR>

" ###################################### nvim-tree (file browser)
" Alt+1 opens file side pane and focuses it
noremap <M-1> :NvimTreeToggle<CR>
" Alt+space opens file side pand and focuses the current file
noremap <M-Space> :NvimTreeFindFile<CR>

" Hightlight the cursor line, only in nvim-tree
:hi CursorLine   cterm=NONE ctermbg=gray ctermfg=black
autocmd! BufEnter * call ToggleCursorLineInNvimTree()
function! ToggleCursorLineInNvimTree()
    if (bufname("%") =~ "NvimTree")
        setlocal cursorline
    else
        setlocal nocursorline
    endif
endfunction

" nvim-tree lua config (extract in lua file if becomes too big)
lua << EOF
-- disable netrw at the very start of your init.lua (strongly advised)
vim.g.loaded_netrw = 1
vim.g.loaded_netrwPlugin = 1

-- empty setup using defaults
-- require("nvim-tree").setup()

-- OR setup with some options
require("nvim-tree").setup({
  sort_by = "case_sensitive",
  view = {
    adaptive_size = true,
    -- centralize_selection = true,
		-- float = {
		-- 	enable = true,
		-- 	quit_on_focus_loss = true,
		-- },
    mappings = {
      list = {
        { key = "u", action = "dir_up" },
        { key = "n", action = "create" },
        { key = "d", action = "trash" },
        { key = "D", action = "remove" },
        { key = "q", action = "" }, -- Disable the default quit shortcut, we wanna get command history
      },
    },
  },
  renderer = {
    group_empty = true,
  },
  filters = {
    -- dotfiles = true,
  },
})
EOF

