local dap = require("dap")

vim.api.nvim_set_hl(0, 'DebuggerBreakpoint', { ctermfg= "Red" })
vim.api.nvim_set_hl(0, 'DebuggerBreakpointLine', { special= "White", underline = true })
vim.api.nvim_set_hl(0, 'DebuggerBreakpointRejectedLine', { special= "White", underdashed = true })
vim.api.nvim_set_hl(0, 'DebuggerCurrentLine', { ctermfg = "Black", ctermbg = "Red" })
vim.fn.sign_define("DapBreakpoint", { text = "", texthl = "DebuggerBreakpoint", linehl = "DebuggerBreakpointLine", numhl = "DebuggerBreakpointLine" })
vim.fn.sign_define("DapBreakpointRejected", { text = "", texthl = "DebuggerBreakpoint", linehl = "DebuggerBreakpointRejectedLine", numhl = "DebuggerBreakpointRejectedLine" })
vim.fn.sign_define("DapStopped", { text = "▶", texthl = "White", linehl = "DebuggerCurrentLine", numhl = "" })

dap.adapters.delve = {
  type = 'server',
  port = '${port}',
  executable = {
    command = 'dlv',
    args = {'dap', '-l', '127.0.0.1:${port}'},
  }
}

dap.configurations.go = {
  {
    type = "delve",
    name = "Debug package",
    request = "launch",
    mode = "debug",
    program = "./${relativeFileDirname}",
    dlvToolPath = vim.fn.exepath('dlv')  -- Adjust to where delve is installed
  },
  {
    type = "delve",
    name = "Debug test package",
    request = "launch",
    mode = "test",
    program = "./${relativeFileDirname}"
  } 
}

-- This invalidates the require cache; meaning live sourcing of init.vim will also resource this file
return false
