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
