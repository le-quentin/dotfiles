-- disable netrw at the very start of your init.lua (strongly advised)
vim.g.loaded_netrw = 1
vim.g.loaded_netrwPlugin = 1

-- empty setup using defaults
-- require("nvim-tree").setup()

local function my_on_attach(bufnr)
  local api = require('nvim-tree.api')

  local function opts(desc)
    return { desc = 'nvim-tree: ' .. desc, buffer = bufnr, noremap = true, silent = true, nowait = true }
  end

  -- copy default mappings here from defaults in next section
  api.config.mappings.default_on_attach(bufnr)
  vim.keymap.del('q', { buffer = bufnr }) -- Disable the default quit shortcut, we wanna get command history
  --TODO set those keys
        -- { key = "u", action = "dir_up" },
        -- { key = "n", action = "create" },
        -- { key = "d", action = "trash" },
        -- { key = "D", action = "remove" },
  ---

  -- remove a default
  -- vim.keymap.del('n', '<C-]>', { buffer = bufnr })

  -- override a default
  -- vim.keymap.set('n', '<C-e>', api.tree.reload,                       opts('Refresh'))

  -- add your mappings
  -- vim.keymap.set('n', '?',     api.tree.toggle_help,                  opts('Help'))
  ---
end

-- OR setup with some options
require("nvim-tree").setup({
  sort_by = "case_sensitive",
  actions = {
    open_file = {
      quit_on_open = true,
      window_picker = {
        enable = false,
      },
    },
  },
  on_attach = my_attach,
  view = {
    adaptive_size = true,
    -- centralize_selection = true,
		-- float = {
		-- 	enable = true,
		-- 	quit_on_focus_loss = true,
		-- },
  },
  renderer = {
    group_empty = true,
  },
  filters = {
    -- dotfiles = true,
  },
})
