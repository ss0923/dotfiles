local ht = require("haskell-tools")
local bufnr = vim.api.nvim_get_current_buf()
local map = function(keys, func, desc)
  vim.keymap.set("n", keys, func, { buffer = bufnr, desc = "Haskell: " .. desc })
end

map("<localleader>s", ht.hoogle.hoogle_signature, "Hoogle signature search")

map("<localleader>e", ht.lsp.buf_eval_all, "Eval all code snippets")

map("<localleader>l", vim.lsp.codelens.run, "Run code lens")

map("<localleader>r", ht.repl.toggle, "REPL toggle (project)")
map("<localleader>f", function()
  ht.repl.toggle(vim.api.nvim_buf_get_name(0))
end, "REPL toggle (current file)")
map("<localleader>q", ht.repl.quit, "REPL quit")
