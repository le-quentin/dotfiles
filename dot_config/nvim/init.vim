" #############################################################################
" #																PLUGINS																			#
" #############################################################################
call plug#begin('~/.config/nvim/plugins')

" Dependencies for other plugins
Plug 'nvim-lua/plenary.nvim' " required by nvim-telescope
"""""""""""""""""""""""""""""""""""""""""

" Surroundings, to add verbs to delete/change/... surroundings
Plug 'tpope/vim-surround'

" Advanced repeat, to be able to repeat plugins action with .
Plug 'tpope/vim-repeat'

" vimpolyglot, to get syntax highlighting for 500+ file formats
Plug 'sheerun/vim-polyglot'

" vim-fugitive, providing git integration
Plug 'tpope/vim-fugitive'

" use treesitter, a language parser generator, to get better syntax highlighting for basically all languagaes
Plug 'nvim-treesitter/nvim-treesitter', {'do': ':TSUpdate'}

" vim-tmux-navigator, navigate vim and tmux panes with the same bindings (ctrl+direction)
Plug 'christoomey/vim-tmux-navigator'

" nvim-tree, replacing netrw for sweet sweet file navigation in a pane
Plug 'nvim-tree/nvim-web-devicons' " optional, for file icons
Plug 'nvim-tree/nvim-tree.lua'

" lualine, for a nice looking statusline
Plug 'nvim-lualine/lualine.nvim'

" coc-nvim, basically turning vim into an IDE with language servers, linting etc
Plug 'neoclide/coc.nvim', {'branch': 'release'}

" nvim-telescope: fuzzy find in various list (files, tags, commands...)
" Plug 'nvim-telescope/telescope.nvim', { 'tag': '0.1.0' }
Plug 'nvim-telescope/telescope.nvim', { 'branch': 'master' }

" telescope-coc: integrate coc lists in telescope, so you can fuzzy search in symbols, commands etc
Plug 'fannheyward/telescope-coc.nvim'

" Built fzf to improve performance in telescope
Plug 'nvim-telescope/telescope-fzf-native.nvim', { 'do': 'cmake -S. -Bbuild -DCMAKE_BUILD_TYPE=Release && cmake --build build --config Release && cmake --install build --prefix build' }

" Autosave with a hook: only autosave git committed files
Plug '907th/vim-auto-save'
Plug 'zigius/vim-auto-save-git-hook'

" gc/gb actions to line-comment/block-comment stuff
Plug 'numToStr/Comment.nvim'

" Test wrapper, to run tests in various language with vim commands
Plug 'vim-test/vim-test'

" Vimux, opening a tmux pane from vim to run commands, instead of the defautl :term
Plug 'preservim/vimux'

" nvim-dap, interactive debugger inside nvim
Plug 'mfussenegger/nvim-dap'
" nvim-dap-go, uses Treesitter to be able to debug nearest go test
Plug 'leoluz/nvim-dap-go'
" nvim-dap-vscode-js, nodejs debugger adapter
Plug 'mxsdev/nvim-dap-vscode-js'

call plug#end()

" #############################################################################
" #													GENERAL SETTINGS																	#
" #############################################################################

" Alias command to source vimrc again
command Config :edit ~/.config/nvim/init.vim
command Resource :source ~/.config/nvim/init.vim
command Rs :Resource

" Floating windows not having this horrible magenta background by default
:hi NormalFloat ctermbg=black

" Errors in Coc Diagnostics not having this horrible gray on red 
:hi ErrorMsg ctermfg=black

" Simple status line
set statusline=%<%f\ %h%m%r%=%-14.(%l,%c%V%)\ %P

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

" ###################################### Build shortcuts 
" Call :make run with leader r 
nnoremap <leader>r :make run<CR>
" Call :make build with leader b
nnoremap <leader>b :make build<CR>

" ###################################### lualine (nice looking statusline)

" We'll show the status only if there's something going on, other than that
" We're not interested, diagnostics are already in lualine
function! CocStatus() 
    let l:cocstat = coc#status()
    if stridx(l:cocstat, "%") >= 0 || stridx(l:cocstat, "starting") >= 0 
        return l:cocstat
    endif
    return ""
endfunction

function! CocCurrentFunction()
    return get(b:, 'coc_current_function', '')
endfunction

lua require('init-lualine')

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

" nvim-tree lua config
lua require('init-nvim-tree')

" #############################################################################
" #												     git autosave                                   #
" #############################################################################

let g:auto_save = 1
let g:auto_save_silent = 1
let g:auto_save_events = ["CursorHold"]
let updatetime=4000

" #############################################################################
" #													      Tests                                       #
" #############################################################################

" neovim test strategy => pop tests in a terminal
let test#strategy = 'vimux'

" Leader T => search for test class associated with current class (by
" searching global tags starting with the class name)
nnoremap <Leader>T :execute ':Tags ' . expand('%:t:r') . ' Test'<CR>

" Shortcuts for the test wrapper
nmap <silent> t<C-n> :TestNearest<CR>
nmap <silent> t<C-f> :TestFile<CR>
nmap <silent> t<C-s> :TestSuite<CR>
nmap <silent> t<C-l> :TestLast<CR>
nmap <silent> t<C-g> :TestVisit<CR>

" Typescript customisation => allow .ts files to be test files
let g:test#javascript#ava#file_pattern = '\vtests?/.*\.(js|jsx|ts|tsx|coffee)$'

" #############################################################################
" #													Vim-Fugitive                                      #
" #############################################################################

function! s:ToggleBlame()
    if &l:filetype ==# 'fugitiveblame'
        close
    else
        Git blame
    endif
endfunction

noremap <M-g> :call <SID>ToggleBlame()<CR>

" #############################################################################
" #													Tree-sitter                                       #
" #############################################################################

lua require('init-tree-sitter')

" #############################################################################
" #													   Comment                                        #
" #############################################################################

lua require('Comment').setup()

" #############################################################################
" #													LSP servers                                       #
" #############################################################################

let g:coc_global_extensions=[ 
    \ "coc-java",
    \ "coc-json",
    \ "coc-docker",
    \ "coc-pyright",
    \ "coc-go",
    \ "coc-clangd",
    \ "coc-pairs"
\]

" #############################################################################
" #													Debugger                                          #
" #############################################################################

lua require('init-nvim-dap')

noremap <leader>db :lua require('dap').toggle_breakpoint()<CR>
noremap <leader>dc :lua require('dap').continue()<CR>
noremap <leader>dn :lua require('dap').step_over()<CR>
noremap <leader>di :lua require('dap').step_into()<CR>
noremap <leader>dp :lua require('dap').repl.open()<CR>

augroup debug_test
  autocmd!
  autocmd FileType go noremap <leader>dt :lua require('dap-go').debug_test()<CR>
augroup END

" #############################################################################
" #													 Coc Nvim                                         #
" #############################################################################

" Some servers have issues with backup files, see #649.
set nobackup
set nowritebackup

" Having longer updatetime (default is 4000 ms = 4 s) leads to noticeable
" delays and poor user experience.
set updatetime=300

" Always show the signcolumn, otherwise it would shift the text each time
" diagnostics appear/become resolved.
set signcolumn=yes

" This can be used to disable coc-pairs for specific filetypes and symbols
" autocmd FileType markdown let b:coc_pairs_disabled = ['`']

" Use tab for trigger completion with characters ahead and navigate.
" NOTE: There's always complete item selected by default, you may want to enable
" no select by `"suggest.noselect": true` in your configuration file.
" NOTE: Use command ':verbose imap <tab>' to make sure tab is not mapped by
" other plugin before putting this into your config.
inoremap <silent><expr> <TAB>
      \ coc#pum#visible() ? coc#pum#next(1) :
      \ CheckBackspace() ? "\<Tab>" :
      \ coc#refresh()
inoremap <expr><S-TAB> coc#pum#visible() ? coc#pum#prev(1) : "\<C-h>"

" Make <CR> to accept selected completion item or notify coc.nvim to format
" <C-g>u breaks current undo, please make your own choice.
inoremap <silent><expr> <CR> coc#pum#visible() ? coc#pum#confirm()
                              \: "\<C-g>u\<CR>\<c-r>=coc#on_enter()\<CR>"

function! CheckBackspace() abort
  let col = col('.') - 1
  return !col || getline('.')[col - 1]  =~# '\s'
endfunction

" Use <c-space> to trigger completion.
if has('nvim')
  inoremap <silent><expr> <c-space> coc#refresh()
else
  inoremap <silent><expr> <c-@> coc#refresh()
endif

" Use `[e` and `]e` to navigate diagnostics
" Use `:CocDiagnostics` to get all diagnostics of current buffer in location list.
nmap <silent> [e <Plug>(coc-diagnostic-prev)
nmap <silent> ]e <Plug>(coc-diagnostic-next)

" GoTo code navigation.
nmap <silent> gd <Plug>(coc-definition)
nmap <silent> gy <Plug>(coc-type-definition)
nmap <silent> gi <Plug>(coc-implementation)
nmap <silent> gr <Plug>(coc-references)

" Use K to show documentation in preview window.
nnoremap <silent> K :call ShowDocumentation()<CR>

function! ShowDocumentation()
  if CocAction('hasProvider', 'hover')
    call CocActionAsync('doHover')
  else
    call feedkeys('K', 'in')
  endif
endfunction

" Highlight the symbol and its references when holding the cursor.
autocmd CursorHold * silent call CocActionAsync('highlight')

" Symbol renaming.
nmap <leader>rn <Plug>(coc-rename)

" Formatting selected code.
xmap <leader>f  <Plug>(coc-format-selected)
nmap <leader>f  <Plug>(coc-format-selected)

augroup mygroup
  autocmd!
  " Setup formatexpr specified filetype(s).
  autocmd FileType typescript,json setl formatexpr=CocAction('formatSelected')
  " Update signature help on jump placeholder.
  autocmd User CocJumpPlaceholder call CocActionAsync('showSignatureHelp')
augroup end

" Applying codeAction to the selected region.
" Example: `<leader>aap` for current paragraph
xmap <leader>a  <Plug>(coc-codeaction-selected)
nmap <leader>a  <Plug>(coc-codeaction-selected)

" Remap keys for applying codeAction to the current buffer.
nmap <leader>ac  <Plug>(coc-codeaction)
" Apply AutoFix to problem on the current line.
nmap <leader>qf  <Plug>(coc-fix-current)

" Run the Code Lens action on the current line.
nmap <leader>w  <Plug>(coc-codelens-action)

" Map function and class text objects
" NOTE: Requires 'textDocument.documentSymbol' support from the language server.
xmap if <Plug>(coc-funcobj-i)
omap if <Plug>(coc-funcobj-i)
xmap af <Plug>(coc-funcobj-a)
omap af <Plug>(coc-funcobj-a)
xmap ic <Plug>(coc-classobj-i)
omap ic <Plug>(coc-classobj-i)
xmap ac <Plug>(coc-classobj-a)
omap ac <Plug>(coc-classobj-a)

" Remap <C-f> and <C-b> for scroll float windows/popups.
if has('nvim-0.4.0') || has('patch-8.2.0750')
  nnoremap <silent><nowait><expr> <C-f> coc#float#has_scroll() ? coc#float#scroll(1) : "\<C-f>"
  nnoremap <silent><nowait><expr> <C-b> coc#float#has_scroll() ? coc#float#scroll(0) : "\<C-b>"
  inoremap <silent><nowait><expr> <C-f> coc#float#has_scroll() ? "\<c-r>=coc#float#scroll(1)\<cr>" : "\<Right>"
  inoremap <silent><nowait><expr> <C-b> coc#float#has_scroll() ? "\<c-r>=coc#float#scroll(0)\<cr>" : "\<Left>"
  vnoremap <silent><nowait><expr> <C-f> coc#float#has_scroll() ? coc#float#scroll(1) : "\<C-f>"
  vnoremap <silent><nowait><expr> <C-b> coc#float#has_scroll() ? coc#float#scroll(0) : "\<C-b>"
endif

" Use CTRL-S for selections ranges.
" Requires 'textDocument/selectionRange' support of language server.
nmap <silent> <C-s> <Plug>(coc-range-select)
xmap <silent> <C-s> <Plug>(coc-range-select)

" Add `:Format` command to format current buffer.
command! -nargs=0 Format :call CocActionAsync('format')

" Add `:Fold` command to fold current buffer.
command! -nargs=? Fold :call     CocAction('fold', <f-args>)

" Add `:OR` command for organize imports of the current buffer.
command! -nargs=0 OR   :call     CocActionAsync('runCommand', 'editor.action.organizeImport')

" Add (Neo)Vim's native statusline support.
" NOTE: Please see `:h coc-status` for integrations with external plugins that
" provide custom statusline: lightline.vim, vim-airline.
" set statusline^=%{coc#status()}%{get(b:,'coc_current_function','')}

"  Mappings for CoCList => Replaced by telecope-coc bindings below
"" Show all diagnostics.
"nnoremap <silent><nowait> <leader>d  :<C-u>CocList diagnostics<cr>
"" Manage extensions.
"nnoremap <silent><nowait> <leader>e  :<C-u>CocList extensions<cr>
"" Show commands.
"nnoremap <silent><nowait> <leader>a  :<C-u>CocList commands<cr>
"" Find symbol of current document.
"nnoremap <silent><nowait> <leader>u  :<C-u>CocList outline<cr>
"" Search workspace symbols.
"nnoremap <silent><nowait> <leader>s  :<C-u>CocList -I symbols<cr>
"" Do default action for next item.
"nnoremap <silent><nowait> <leader>j  :<C-u>CocNext<CR>
"" Do default action for previous item.
"nnoremap <silent><nowait> <leader>k  :<C-u>CocPrev<CR>
"" Resume latest coc list.
"nnoremap <silent><nowait> <leader>p  :<C-u>CocListResume<CR>
nnoremap <silent><nowait> <leader>u  :<C-u>CocList outline<cr>

" Automatically watch typescript project if tsserver is running (doesn't work
" if not opening vim on a ts file, need a better solution)
" autocmd User CocNvimInit call CocAction('runCommand', 'tsserver.watchBuild')

" #############################################################################
" #											 Telescope (fuzzy find in list)                       #
" #############################################################################

" Find files using Telescope command-line sugar.
nnoremap <leader>o <cmd>Telescope coc workspace_symbols<cr>
nnoremap <leader>O <cmd>Telescope find_files<cr>
nnoremap <leader>a <cmd>Telescope coc commands<cr>
nnoremap <leader>d <cmd>Telescope coc diagnostics<cr>
nnoremap <leader>f <cmd>Telescope live_grep<cr>
nnoremap <leader>t <cmd>Telescope buffers<cr>
nnoremap <leader>h <cmd>Telescope help_tags<cr>

" At the bottom of your init.vim, keep all configs on one line
lua require("nvim-treesitter.configs").setup({highlight={enable=true}})  

" Integrate coc lists with telescope-coc plugin
lua << EOF
require("telescope").setup({
  defaults = {
    path_display = { "smart" },
    mappings = {
      i = {
        -- map actions.which_key to <C-h> (default: <C-/>)
        -- actions.which_key shows the mappings for your picker,
        -- e.g. git_{create, delete, ...}_branch for the git_branches picker
        ["<C-h>"] = "which_key",
        ["<C-j>"] = "move_selection_next",
        ["<C-k>"] = "move_selection_previous",
      },
    },
  },
  extensions = {
    coc = {
        -- theme = 'ivy',
        prefer_locations = true, -- always use Telescope locations to preview definitions/declarations/implementations etc
    },
    fzf = {
      fuzzy = true,                    -- false will only do exact matching
      override_generic_sorter = true,  -- override the generic sorter
      override_file_sorter = true,     -- override the file sorter
      case_mode = "smart_case",        -- or "ignore_case" or "respect_case"
                                       -- the default case_mode is "smart_case"
    },
  },
})
require('telescope').load_extension('coc')
require('telescope').load_extension('fzf')

EOF
