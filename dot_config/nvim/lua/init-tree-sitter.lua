require("tree-sitter-manager").setup({
  auto_install = true,
  nohighlight = { "ansible" }, -- ansible-vim handles this filetype
})

return false
